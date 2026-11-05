#!/usr/bin/env python3
"""Minimal image -> Arma 3 PAA (DXT1, with mipmaps) converter. Needs Pillow and numpy.
Usage: python3 tools/img2paa.py input.png output.paa
Width and height must be powers of two (e.g. 256x256, 1024x512)."""
import struct, sys
import numpy as np
from PIL import Image

def rgb565(c):
    r, g, b = int(c[0]), int(c[1]), int(c[2])
    return ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)

def unpack565(v):
    r = (v >> 11) & 31; g = (v >> 5) & 63; b = v & 31
    return np.array([(r << 3) | (r >> 2), (g << 2) | (g >> 4), (b << 3) | (b >> 2)], dtype=np.float32)

def dxt1(img):
    a = np.asarray(img.convert("RGB"), dtype=np.float32)
    h, w, _ = a.shape
    out = bytearray()
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            blk = a[by:by + 4, bx:bx + 4].reshape(-1, 3)
            # endpoints: extremes along the main colour axis
            mean = blk.mean(0)
            d = blk - mean
            cov = d.T @ d
            axis = np.linalg.eigh(cov)[1][:, -1] if np.any(cov) else np.array([1, 1, 1], np.float32)
            proj = d @ axis
            c0, c1 = blk[proj.argmax()], blk[proj.argmin()]
            v0, v1 = rgb565(c0), rgb565(c1)
            if v0 < v1:
                v0, v1 = v1, v0
            if v0 == v1:
                idx = 0
                out += struct.pack("<HHI", v0, v1, idx)
                continue
            p0, p1 = unpack565(v0), unpack565(v1)
            pal = np.stack([p0, p1, (2 * p0 + p1) / 3, (p0 + 2 * p1) / 3])
            dist = ((blk[:, None, :] - pal[None, :, :]) ** 2).sum(-1)
            sel = dist.argmin(1)
            idx = 0
            for i, s in enumerate(sel):
                idx |= int(s) << (2 * i)
            out += struct.pack("<HHI", v0, v1, idx)
    return bytes(out)

def convert(src, dst):
    img = Image.open(src).convert("RGB")
    w, h = img.size
    assert w & (w - 1) == 0 and h & (h - 1) == 0, "size must be power of two"
    mips = []
    cw, ch = w, h
    while cw >= 4 and ch >= 4:
        m = img if (cw, ch) == (w, h) else img.resize((cw, ch), Image.LANCZOS)
        mips.append((cw, ch, dxt1(m)))
        cw //= 2; ch //= 2
    avg = np.asarray(img, dtype=np.float32).reshape(-1, 3).mean(0).astype(int)
    avgc = bytes([avg[2], avg[1], avg[0], 255])
    head = struct.pack("<H", 0xFF01)
    head += b"GGATCGVA" + struct.pack("<I", 4) + avgc
    head += b"GGATCXAM" + struct.pack("<I", 4) + b"\xff\xff\xff\xff"
    offs_pos = len(head) + 12
    head += b"GGATSFFO" + struct.pack("<I", 64) + b"\0" * 64
    head += struct.pack("<H", 0)  # palette
    body = bytearray(head)
    offsets = []
    for mw, mh, data in mips:
        offsets.append(len(body))
        body += struct.pack("<HH", mw, mh) + len(data).to_bytes(3, "little") + data
    body += b"\0" * 6
    for i, o in enumerate(offsets[:16]):
        body[offs_pos + 4 * i:offs_pos + 4 * i + 4] = struct.pack("<I", o)
    open(dst, "wb").write(body)

if __name__ == "__main__":
    convert(sys.argv[1], sys.argv[2])
