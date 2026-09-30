#!/usr/bin/env python3
"""Build do-druku/ from cad/stl/ (design orientation -> print orientation, sorted by stage).
Run after cad/export-all.sh:  python3 tools/pack-print.py
"""
import re, struct, os, shutil, sys
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STL = os.path.join(ROOT, "cad", "stl")
OUT = os.path.join(ROOT, "do-druku")
SPLAY = 15.0
BED = 128.0  # X1C bed centre: parts are placed there so a slicer that keeps file coordinates sees them on the plate
HINGE = {1: (81.0, -22.0), -1: (-82.0, -35.0)}  # hinge axis x, y per side (glass.scad pod_c/hinge_y)


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


def rot(t, axis, deg, c=(0, 0, 0)):
    a = np.radians(deg); s, k = np.sin(a), np.cos(a)
    R = {"x": [[1, 0, 0], [0, k, -s], [0, s, k]], "y": [[k, 0, s], [0, 1, 0], [-s, 0, k]], "z": [[k, -s, 0], [s, k, 0], [0, 0, 1]]}[axis]
    c = np.array(c, float)
    return (t - c) @ np.array(R).T + c


def ground(t, center=True):
    lo = t.reshape(-1, 3).min(0); hi = t.reshape(-1, 3).max(0)
    sh = np.array([BED - (lo[0] + hi[0]) / 2, BED - (lo[1] + hi[1]) / 2, -lo[2]]) if center else np.array([0, 0, -lo[2]])
    return t + sh


def lid(name):
    return ground(rot(load(f"{STL}/{name}.stl"), "x", 180))


def temple(name, s):
    hx, hy = HINGE[s]
    t = rot(load(f"{STL}/{name}.stl"), "z", -s * SPLAY, (hx, hy, 0))
    return ground(rot(t, "y", 90 * s))


def front():
    p = f"{STL}/front.stl"
    t = load(p) if os.path.exists(p) else None
    if t is None:
        sys.exit("cad/stl/front.stl missing: run cad/export-all.sh")
    return ground(t)


def on_edge(t):
    return ground(rot(t, "y", 90))


def place(t, dx, dy):
    lo = t.reshape(-1, 3).min(0)
    return t + np.array([dx - lo[0] + 60, dy - lo[1] + 100, 0])


for d in ("01-testy", "02-przymiarka", "03-pokrywki"):
    shutil.rmtree(os.path.join(OUT, d), ignore_errors=True)
coupon = load(f"{STL}/screw-coupon.stl")
hf = ground(load(f"{STL}/test_hinge_front.stl"), center=False)
ht = on_edge(load(f"{STL}/test_hinge_temple.stl"))
plate = np.concatenate([place(coupon, 0, 0), place(hf, 66, 0), place(ht, 106, 0)])
save(f"{OUT}/01-testy/test-plate.stl", plate)
save(f"{OUT}/01-testy/osobno/screw-coupon.stl", place(coupon, 0, 0))
save(f"{OUT}/01-testy/osobno/test-hinge-front.stl", hf)
save(f"{OUT}/01-testy/osobno/test-hinge-temple.stl", ht)
save(f"{OUT}/02-przymiarka/front.stl", front())
save(f"{OUT}/02-przymiarka/temple_r.stl", temple("temple_r", 1))
save(f"{OUT}/02-przymiarka/temple_l.stl", temple("temple_l", -1))
for n in ("lid_hood", "lid_r", "lid_l"):
    save(f"{OUT}/03-pokrywki/{n}.stl", lid(n))
for r, _, fs in os.walk(OUT):
    for f in sorted(x for x in fs if x.endswith('.stl')):
        t = load(os.path.join(r, f)); lo = t.reshape(-1, 3).min(0); hi = t.reshape(-1, 3).max(0)
        print(os.path.relpath(os.path.join(r, f), OUT), (hi - lo).round(1), "zmin", round(lo[2], 2))
