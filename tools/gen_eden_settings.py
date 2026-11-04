#!/usr/bin/env python3
"""
gen_eden_settings.py - generate Eden (3DEN) scenario attributes for every MCC CBA setting.

Reads every `[...] call CBA_fnc_addSetting` in mcc/settings/*.sqf and mcc/medic/XEH_preinit.sqf and writes:
  mcc/cfg/eden/settingsAttributes.hpp  - AttributeCategories classes, #included inside
                                         Cfg3DEN >> Mission >> MCC5 >> AttributeCategories (config.cpp)
  mcc/fnc/eden/edenSettingsMap.sqf     - SQF array [property, cbaVariable, kind(, min, max)] #included by
                                         mcc/fnc/eden/fn_applyEdenAttributes.sqf

Every attribute has a "use addon setting" state (Combo -1 / "" or an empty Edit box), so a mission only changes
a setting when the mission maker picks a value.

Usage (from anywhere):  python3 tools/gen_eden_settings.py
Re-run it whenever a CBA setting is added, removed or changed. Output is deterministic.
"""
import glob
import os
import re
import sys
import xml.etree.ElementTree as ET

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCES = sorted(glob.glob(os.path.join(ROOT, "mcc", "settings", "*.sqf"))) + [
    os.path.join(ROOT, "mcc", "medic", "XEH_preinit.sqf")
]
OUT_HPP = os.path.join(ROOT, "mcc", "cfg", "eden", "settingsAttributes.hpp")
OUT_SQF = os.path.join(ROOT, "mcc", "fnc", "eden", "edenSettingsMap.sqf")
STRINGTABLE = os.path.join(ROOT, "stringtable.xml")

# Settings that already have a hand-written attribute in config.cpp (class MCC_Attributes, see MCC_edenAttributeMap
# in fn_applyEdenAttributes.sqf). Only these exact variables are skipped; all other MCC_MW*/MCC_campaign*/
# MCC_GAIA_SUPPORT_* settings get a generated attribute (property MCC5S_<var>, so there is no name clash).
HANDWRITTEN = {
    "MCC_logisticsMode", "MCC_MWmaxObjectives", "MCC_MWmissionSize", "MCC_MWmaxSpawnedUnits",
    "MCC_campaignMaxAOs", "MCC_campaignAOSize", "MCC_campaignAmbientCap",
    "MCC_GAIA_SUPPORT_ENABLED", "MCC_GAIA_SUPPORT_ARTY", "MCC_GAIA_SUPPORT_CAS", "MCC_GAIA_SUPPORT_REINF",
    "MCC_GAIA_COORDINATION", "MCC_GAIA_HC_BALANCE", "MCC_zeusForMCCUsers",
}

PROPERTY_PREFIX = "MCC5S_"


# ---------------------------------------------------------------- stringtable
def load_stringtable():
    table = {}
    if not os.path.isfile(STRINGTABLE):
        return table
    for key in ET.parse(STRINGTABLE).getroot().iter("Key"):
        kid = key.get("ID")
        text = None
        for tag in ("English", "Original"):
            el = key.find(tag)
            if el is not None and el.text:
                text = el.text
                break
        if kid and text is not None:
            table[kid.lower()] = text
    return table


STRINGS = load_stringtable()


# ---------------------------------------------------------------- SQF tokenizer
class Tok:
    def __init__(self, kind, value, pos):
        self.kind, self.value, self.pos = kind, value, pos

    def __repr__(self):
        return "Tok(%s,%r)" % (self.kind, self.value)


def tokenize(src):
    toks = []
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        if c.isspace():
            i += 1
        elif src.startswith("//", i):
            j = src.find("\n", i)
            i = n if j < 0 else j
        elif src.startswith("/*", i):
            j = src.find("*/", i + 2)
            i = n if j < 0 else j + 2
        elif c in "\"'":
            # SQF string: the quote char is escaped by doubling it
            j = i + 1
            buf = []
            while j < n:
                if src[j] == c:
                    if j + 1 < n and src[j + 1] == c:
                        buf.append(c)
                        j += 2
                        continue
                    break
                buf.append(src[j])
                j += 1
            toks.append(Tok("str", "".join(buf), i))
            i = j + 1
        elif c.isdigit() or (c == "." and i + 1 < n and src[i + 1].isdigit()):
            m = re.match(r"0x[0-9a-fA-F]+|\d*\.?\d+(?:[eE][+-]?\d+)?", src[i:])
            text = m.group(0)
            toks.append(Tok("num", float(int(text, 16)) if text.lower().startswith("0x") else float(text), i))
            i += len(text)
        elif c.isalpha() or c == "_":
            m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", src[i:])
            toks.append(Tok("id", m.group(0), i))
            i += len(m.group(0))
        else:
            toks.append(Tok("op", c, i))
            i += 1
    return toks


class Raw:
    """An expression the generator does not evaluate (code block, variable, operator expression...)."""

    def __init__(self, text):
        self.text = text

    def __repr__(self):
        return "Raw(%r)" % self.text


class Parser:
    def __init__(self, toks, src):
        self.t, self.src, self.i = toks, src, 0

    def peek(self, k=0):
        j = self.i + k
        return self.t[j] if j < len(self.t) else None

    def next(self):
        tok = self.t[self.i]
        self.i += 1
        return tok

    def skip_balanced(self, open_c, close_c):
        depth = 0
        start = self.peek().pos
        while True:
            tok = self.next()
            if tok.kind == "op" and tok.value == open_c:
                depth += 1
            elif tok.kind == "op" and tok.value == close_c:
                depth -= 1
                if depth == 0:
                    return self.src[start:tok.pos + 1]

    def parse_array(self):
        assert self.next().value == "["
        items = []
        if self.peek().kind == "op" and self.peek().value == "]":
            self.next()
            return items
        while True:
            items.append(self.parse_expr())
            tok = self.next()
            if tok.kind == "op" and tok.value == ",":
                continue
            if tok.kind == "op" and tok.value == "]":
                return items
            raise ValueError("unexpected token %r in array" % tok)

    def parse_expr(self):
        """One array element. Simple values are evaluated; anything else becomes Raw."""
        start = self.i
        val = self.parse_simple()
        nxt = self.peek()
        if nxt is not None and nxt.kind == "op" and nxt.value in ",]":
            return val
        # complex expression: skip until , or ] at depth 0
        self.i = start
        depth = 0
        begin = self.peek().pos
        end = begin
        while True:
            tok = self.peek()
            if tok.kind == "op" and tok.value in "[({":
                depth += 1
            elif tok.kind == "op" and tok.value in "])}":
                if depth == 0:
                    break
                depth -= 1
            elif tok.kind == "op" and tok.value == "," and depth == 0:
                break
            end = tok.pos + (len(tok.value) if isinstance(tok.value, str) else 1)
            self.next()
        return Raw(self.src[begin:end])

    def parse_simple(self):
        tok = self.peek()
        if tok.kind == "op" and tok.value == "[":
            return self.parse_array()
        if tok.kind == "op" and tok.value == "{":
            return Raw(self.skip_balanced("{", "}"))
        if tok.kind == "op" and tok.value == "-" and self.peek(1) and self.peek(1).kind == "num":
            self.next()
            return -self.next().value
        self.next()
        if tok.kind in ("str", "num"):
            return tok.value
        if tok.kind == "id":
            low = tok.value.lower()
            if low == "true":
                return True
            if low == "false":
                return False
            if low == "localize" and self.peek() and self.peek().kind == "str":
                key = self.next().value
                return STRINGS.get(key.lower(), key)
            return Raw(tok.value)
        return Raw(str(tok.value))


def find_settings(path):
    src = open(path, encoding="utf-8", errors="replace").read()
    toks = tokenize(src)
    out = []
    for k in range(len(toks) - 1):
        if toks[k].kind == "id" and toks[k].value.lower() == "call" and toks[k + 1].kind == "id" \
                and toks[k + 1].value.lower() == "cba_fnc_addsetting":
            # walk back from the "]" before "call" to its matching "["
            j = k - 1
            if not (toks[j].kind == "op" and toks[j].value == "]"):
                print("WARN %s: addSetting without literal array" % path, file=sys.stderr)
                continue
            depth = 0
            while j >= 0:
                if toks[j].kind == "op" and toks[j].value == "]":
                    depth += 1
                elif toks[j].kind == "op" and toks[j].value == "[":
                    depth -= 1
                    if depth == 0:
                        break
                j -= 1
            p = Parser(toks, src)
            p.i = j
            args = p.parse_array()
            line = src.count("\n", 0, toks[j].pos) + 1
            out.append((os.path.relpath(path, ROOT), line, args))
    return out


# ---------------------------------------------------------------- generation helpers
def cfg_str(s):
    """Config string literal: double quotes doubled, newlines kept as \\n text (Eden shows them as line breaks)."""
    s = str(s).replace("\r", "").replace("\n", "\\n").replace('"', '""')
    return '"%s"' % s


def sqf_str(s):
    return '"%s"' % str(s).replace('"', '""')


def fmt_num(v):
    if isinstance(v, bool):
        return "1" if v else "0"
    if float(v).is_integer():
        return str(int(v))
    return repr(float(v))


def ident(s):
    s = re.sub(r"[^A-Za-z0-9_]", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    if not s or s[0].isdigit():
        s = "C_" + s
    return s


def is_handwritten(var):
    return var in HANDWRITTEN


def text_of(v):
    if isinstance(v, Raw):
        return v.text
    if isinstance(v, float):
        return fmt_num(v)
    return str(v)


def main():
    settings = []
    for path in SOURCES:
        if os.path.isfile(path):
            settings.extend(find_settings(path))

    categories = {}  # key -> dict(name, attrs[])
    cat_order = []
    sqf_map = []
    skipped = []
    seen = set()

    for (path, line, args) in settings:
        if len(args) < 5 or not isinstance(args[0], str) or not isinstance(args[1], str):
            skipped.append(("?", "?", "%s:%d unparsable" % (path, line)))
            continue
        var, stype, title, cat, value_info = args[0], args[1].upper(), args[2], args[3], args[4]
        if var in seen:
            skipped.append((var, stype, "duplicate"))
            continue
        seen.add(var)
        if is_handwritten(var):
            skipped.append((var, stype, "hand-written attribute exists"))
            continue

        if isinstance(title, list):
            disp = text_of(title[0]) if title else var
            tip = text_of(title[1]) if len(title) > 1 else ""
        else:
            disp, tip = text_of(title), ""
        if isinstance(cat, list):
            cat_name = text_of(cat[0]) if cat else "MCC"
            sub = text_of(cat[1]) if len(cat) > 1 else ""
        else:
            cat_name, sub = text_of(cat), ""
        cat_disp = "%s - %s" % (cat_name, sub) if sub else cat_name

        prop = PROPERTY_PREFIX + var
        body = []
        kind = None
        extra = ""

        if stype == "CHECKBOX":
            default = value_info if isinstance(value_info, bool) else None
            kind = "bool"
            tip2 = "%s\\n(addon default: %s)" % (tip, {True: "On", False: "Off", None: "?"}[default]) if tip else \
                "Addon default: %s" % {True: "On", False: "Off", None: "?"}[default]
            body = [
                'control = "Combo";',
                'typeName = "NUMBER";',
                'defaultValue = "-1";',
                "class Values",
                "{",
                '\tclass V0 {name = "Use addon setting"; value = -1;};',
                '\tclass V1 {name = "Off"; value = 0;};',
                '\tclass V2 {name = "On"; value = 1;};',
                "};",
            ]
        elif stype == "LIST":
            if not (isinstance(value_info, list) and len(value_info) >= 2 and isinstance(value_info[0], list)):
                skipped.append((var, stype, "list values not literal"))
                continue
            values, labels = value_info[0], value_info[1]
            def_idx = value_info[2] if len(value_info) > 2 and isinstance(value_info[2], float) else 0
            if all(isinstance(v, float) for v in values):
                kind = "list_number"
                sentinel = -99999 if -1.0 in values else -1
                body = ['control = "Combo";', 'typeName = "NUMBER";', 'defaultValue = "%d";' % sentinel,
                        "class Values", "{",
                        '\tclass V0 {name = "Use addon setting"; value = %d;};' % sentinel]
                for n, v in enumerate(values):
                    lab = text_of(labels[n]) if n < len(labels) else fmt_num(v)
                    body.append("\tclass V%d {name = %s; value = %s;};" % (n + 1, cfg_str(lab), fmt_num(v)))
                body.append("};")
                extra = ", %d" % sentinel
            elif all(isinstance(v, str) for v in values):
                kind = "list_string"
                body = ['control = "Combo";', 'typeName = "STRING";', 'defaultValue = """""";',
                        "class Values", "{",
                        '\tclass V0 {name = "Use addon setting"; value = "";};']
                for n, v in enumerate(values):
                    lab = text_of(labels[n]) if n < len(labels) else v
                    body.append("\tclass V%d {name = %s; value = %s;};" % (n + 1, cfg_str(lab), cfg_str(v)))
                body.append("};")
            else:
                skipped.append((var, stype, "mixed/unsupported list values"))
                continue
            dflt = labels[int(def_idx)] if int(def_idx) < len(labels) else "?"
            note = "(addon default: %s)" % text_of(dflt)
            tip2 = "%s\\n%s" % (tip, note) if tip else note
        elif stype in ("SLIDER", "TIME"):
            if not (isinstance(value_info, list) and len(value_info) >= 3
                    and all(isinstance(v, float) for v in value_info[:3])):
                skipped.append((var, stype, "slider range not literal"))
                continue
            vmin, vmax, vdef = value_info[0], value_info[1], value_info[2]
            kind = "slider"
            unit = " seconds" if stype == "TIME" else ""
            note = "Empty = use addon setting. Number %s to %s%s (addon default: %s)." % (
                fmt_num(vmin), fmt_num(vmax), unit, fmt_num(vdef))
            tip2 = "%s\\n%s" % (tip, note) if tip else note
            body = ['control = "Edit";', 'typeName = "STRING";', 'defaultValue = """""";']
            extra = ", %s, %s" % (fmt_num(vmin), fmt_num(vmax))
        elif stype == "EDITBOX":
            kind = "editbox"
            default = value_info[0] if isinstance(value_info, list) and value_info else value_info
            dtext = text_of(default)
            if len(dtext) > 300:
                dtext = dtext[:300] + "..."
            note = "Empty = use addon setting. Addon default: %s" % (dtext if dtext else "(empty)")
            tip2 = "%s\\n%s" % (tip, note) if tip else note
            control = "EditMulti3" if len(text_of(default)) > 60 else "Edit"
            body = ['control = "%s";' % control, 'typeName = "STRING";', 'defaultValue = """""";']
        else:
            skipped.append((var, stype, "type not supported in Eden"))
            continue

        key = cat_disp
        if key not in categories:
            categories[key] = {"cls": "MCC5S_Cat_" + ident(cat_disp), "attrs": []}
            cat_order.append(key)
        attr = ["class %s" % prop, "{",
                "\tdisplayName = %s;" % cfg_str(disp),
                "\ttooltip = %s;" % cfg_str(tip2 + "\\nCBA setting: " + var),
                "\tproperty = %s;" % cfg_str(prop),
                '\texpression = "";']
        attr += ["\t" + b for b in body]
        attr.append("};")
        categories[key]["attrs"].append(attr)
        sqf_map.append('\t[%s, %s, %s%s]' % (sqf_str(prop), sqf_str(var), sqf_str(kind), extra))

    # unique class names
    used = set()
    for key in cat_order:
        c = categories[key]["cls"]
        base, n = c, 2
        while c.lower() in used:
            c = "%s_%d" % (base, n)
            n += 1
        used.add(c.lower())
        categories[key]["cls"] = c

    # ---- write hpp
    hdr = [
        "// GENERATED by tools/gen_eden_settings.py - do not edit by hand, re-run the generator instead.",
        "// Included inside Cfg3DEN >> Mission >> MCC5 >> AttributeCategories (config.cpp).",
        "// One category per CBA settings category/subcategory. Every attribute defaults to \"use addon setting\";",
        "// values are applied at mission start by MCC_fnc_applyEdenAttributes (map: mcc\\fnc\\eden\\edenSettingsMap.sqf).",
        "",
    ]
    lines = list(hdr)
    for key in cat_order:
        cat = categories[key]
        lines += ["class %s" % cat["cls"], "{",
                  "\tdisplayName = %s;" % cfg_str(key),
                  "\tcollapsed = 1;",
                  "\tclass Attributes", "\t{"]
        for attr in cat["attrs"]:
            lines += ["\t\t" + a for a in attr]
        lines += ["\t};", "};", ""]
    os.makedirs(os.path.dirname(OUT_HPP), exist_ok=True)
    with open(OUT_HPP, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines))

    # ---- write sqf
    sl = [
        "// GENERATED by tools/gen_eden_settings.py - do not edit by hand, re-run the generator instead.",
        "// #included by mcc\\fnc\\eden\\fn_applyEdenAttributes.sqf",
        "// [scenario attribute (property), CBA setting variable, kind (, kind args)]",
        "// kind: \"bool\" | \"list_number\" (sentinel) | \"list_string\" | \"slider\" (min, max) | \"editbox\"",
        "[",
        ",\n".join(sqf_map),
        "]",
        "",
    ]
    with open(OUT_SQF, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(sl))

    # ---- report
    total = sum(len(categories[k]["attrs"]) for k in cat_order)
    print("Parsed %d CBA_fnc_addSetting calls, generated %d attributes in %d categories." % (
        len(settings), total, len(cat_order)))
    for key in cat_order:
        print("  %3d  %s  (%s)" % (len(categories[key]["attrs"]), key, categories[key]["cls"]))
    print("Skipped %d:" % len(skipped))
    for s in skipped:
        print("  %s [%s]: %s" % s)


if __name__ == "__main__":
    main()
