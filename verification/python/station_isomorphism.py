"""station_isomorphism.py -- Gamma(A, B) of data/n67.json is the n = 67 certificate of Chung, Du and
Wesley (Station data v2, array finite_n67), up to relabelling.

data/station_isomorphism.json gives a bijection m from the 266 vertices of their matrix S to the
vertices of Gamma(A, B) (vertex (x, i) numbered x + 133 i). The script builds Gamma(A, B), forms the
relabelled matrix S'[p][q] = Gamma[m(p)][m(q)], and checks that the SHA-256 digest of S', in the
format their notebook uses, equals the digest they publish. No file of theirs is needed for this.
With --npz PATH (their book_ramsey_certificates.npz) it also compares S' with their array entry by
entry.

Usage: python3 verification/python/station_isomorphism.py [--npz PATH]
"""
import hashlib
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
data = json.load(open(os.path.join(ROOT, "data", "n67.json")))
iso = json.load(open(os.path.join(ROOT, "data", "station_isomorphism.json")))
v, N = 133, 266
A, B = set(data["A"]), set(data["B"])
C = set(range(1, v)) - A


def adj(p, q):
    (x, i), (y, j) = (p % v, p // v), (q % v, q // v)
    if p == q:
        return 0
    if i == j:
        return int((y - x) % v in (A if i == 0 else C))
    if i == 1:
        x, y = y, x
    return int((y - x) % v in B)


m = iso["map"]
assert sorted(m) == list(range(N)), "the map is not a bijection of the 266 vertices"
S = [[adj(m[p], m[q]) for q in range(N)] for p in range(N)]
s = "".join("1" if S[i][j] else "0" for j in range(1, N) for i in range(j))
digest = hashlib.sha256(s.encode("ascii")).hexdigest()
print("relabelled Gamma(A, B):", digest)
print("published finite_n67:  ", iso["station_sha256"])
assert digest == iso["station_sha256"], "digests differ"
if "--npz" in sys.argv:
    import numpy as np
    T = np.load(sys.argv[sys.argv.index("--npz") + 1])["finite_n67"]
    assert T.shape == (N, N) and all(int(T[p, q]) == S[p][q] for p in range(N) for q in range(N))
    print("entry-by-entry comparison with their array: equal")
print("station_isomorphism: Gamma(A, B) is isomorphic to the certificate finite_n67")
