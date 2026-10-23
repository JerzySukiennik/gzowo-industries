#!/usr/bin/env python3
"""Build do-druku/ from cad/stl/ (parts are exported in print orientation; here they are grounded, centred on the bed and sorted by stage).
Run after cad/export-all.sh:  python3 tools/pack-print.py
"""
import re, struct, os, shutil
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STL = os.path.join(ROOT, "cad", "stl")
OUT = os.path.join(ROOT, "do-druku")
BED = 128.0

STAGES = {
    "01-testy": ["test_plate", "test_hinge_front", "test_hinge_temple", "screw-coupon"],
    "02-plyta": ["plate", "arm"],
    "03-zauszniki": ["temple_r", "temple_l"],
    "04-boxy": ["box_r", "box_l"],
    "05-pokrywki": ["lid_r", "lid_l"],
}


def load(p):
    d = open(p, "rb").read()
    if d[:5] == b"solid" and b"facet" in d[:300]:
        v = np.array([[float(a) for a in m] for m in re.findall(rb"vertex\s+(\S+)\s+(\S+)\s+(\S+)", d)])
        return v.reshape(-1, 3, 3)
    n = struct.unpack("<I", d[80:84])[0]
    a = np.frombuffer(d[84:], dtype=np.dtype([("n", "<3f4"), ("v", "<9f4"), ("a", "<u2")]), count=n)
    return a["v"].reshape(-1, 3, 3).astype(float)


def save(p, t):
    n = np.cross(t[:, 1] - t[:, 0], t[:, 2] - t[:, 0])
    n /= np.linalg.norm(n, axis=1, keepdims=True) + 1e-12
    rec = np.zeros(len(t), dtype=np.dtype([("n", "<3f4"), ("v", "<9f4"), ("a", "<u2")]))
    rec["n"] = n; rec["v"] = t.reshape(-1, 9)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "wb") as f:
        f.write(b"Gzowo Glass".ljust(80, b"\0")); f.write(struct.pack("<I", len(t))); f.write(rec.tobytes())


def ground(t):
    lo = t.reshape(-1, 3).min(0); hi = t.reshape(-1, 3).max(0)
    return t + np.array([BED - (lo[0] + hi[0]) / 2, BED - (lo[1] + hi[1]) / 2, -lo[2]])


for stage in STAGES:
    shutil.rmtree(os.path.join(OUT, stage), ignore_errors=True)
for stage, parts in STAGES.items():
    for name in parts:
        src = f"{STL}/{name}.stl"
        if not os.path.exists(src):
            print("MISSING", name); continue
        t = ground(load(src))
        out = f"{OUT}/{stage}/{name.replace('_', '-')}.stl"
        save(out, t)
        lo = t.reshape(-1, 3).min(0); hi = t.reshape(-1, 3).max(0)
        print(f"{stage}/{name.replace('_', '-')}.stl", (hi - lo).round(1), "zmin", round(lo[2], 2))
