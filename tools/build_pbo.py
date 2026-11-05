#!/usr/bin/env python3
"""Pack the MCC repo into an Arma 3 mod folder: @mcc_sandbox_a3/addons/mcc_sandbox_mod.pbo

Usage:  python3 tools/build_pbo.py <output folder>
Produces <output>/@mcc_sandbox_a3/ with addons/mcc_sandbox_mod.pbo, mod.cpp and INSTALL.md.
Files are stored unbinarized (Arma reads text config.cpp fine). No signing.
"""
import hashlib, os, struct, sys, time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PREFIX = "mcc_sandbox_mod"
SKIP_DIRS = {".git", ".github", ".claude", "tools", "docs"}
SKIP_FILES = {"$PBOPREFIX$", ".gitignore", ".gitattributes", "README.md"}

def collect():
    files = []
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_DIRS)
        for f in sorted(filenames):
            if f in SKIP_FILES:
                continue
            full = os.path.join(dirpath, f)
            rel = os.path.relpath(full, ROOT).replace("/", "\\")
            with open(full, "rb") as fh:
                files.append((rel, fh.read(), int(os.path.getmtime(full))))
    # Addon Builder normally generates this; config.cpp includes it.
    if not any(r.lower() == "bis_addoninfo.hpp" for r, _, _ in files):
        info = b'class BIS_AddonInfo\r\n{\r\n\tauthor = "shay_gman";\r\n\ttimepacked = "%d";\r\n};\r\n' % int(time.time())
        files.append(("BIS_AddonInfo.hpp", info, int(time.time())))
    return files

def pack(out_path):
    files = collect()
    hdr = bytearray()
    # Header extension entry with the prefix
    hdr += b"\0" + struct.pack("<5I", 0x56657273, 0, 0, 0, 0)
    hdr += b"prefix\0" + PREFIX.encode() + b"\0" + b"\0"
    for rel, data, mtime in files:
        hdr += rel.encode("ascii", "replace") + b"\0" + struct.pack("<5I", 0, len(data), 0, mtime, len(data))
    hdr += b"\0" + struct.pack("<5I", 0, 0, 0, 0, 0)
    body = bytearray(hdr)
    for _, data, _ in files:
        body += data
    digest = hashlib.sha1(body).digest()
    with open(out_path, "wb") as fh:
        fh.write(body + b"\0" + digest)
    return len(files), len(body)

def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "build")
    mod = os.path.join(out, "@mcc_sandbox_a3")
    os.makedirs(os.path.join(mod, "addons"), exist_ok=True)
    n, size = pack(os.path.join(mod, "addons", PREFIX + ".pbo"))
    with open(os.path.join(mod, "mod.cpp"), "w", newline="\r\n") as fh:
        fh.write('name = "MCC Sandbox 5";\npicture = "\\mcc_sandbox_mod\\data\\mod.paa";\nlogo = "\\mcc_sandbox_mod\\data\\mod.paa";\n'
                 'logoOver = "\\mcc_sandbox_mod\\data\\mod.paa";\ntooltip = "MCC Sandbox 5";\n'
                 'overview = "Mission Control Center: build and run missions on the fly with Zeus and Eden. GAIA AI commander.";\n'
                 'author = "shay_gman";\n')
    inst = os.path.join(ROOT, "INSTALL.md")
    if os.path.exists(inst):
        with open(inst, "rb") as a, open(os.path.join(mod, "INSTALL.md"), "wb") as b:
            b.write(a.read())
    print("packed %d files, %.1f MB -> %s" % (n, size / 1e6, mod))

if __name__ == "__main__":
    main()
