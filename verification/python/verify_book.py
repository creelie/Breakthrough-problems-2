"""verify_book.py -- check a lower bound R(B_{n-1}, B_n) > 4n - 2 directly from a data file.

Builds the two-block circulant graph Gamma(A, B) on Z_v x {0, 1}, v = 2n - 1: (x,0)~(y,0) iff y-x in A,
(x,1)~(y,1) iff y-x in C = Z_v minus (A and 0), (x,0)~(y,1) iff y-x in B. For odd n (data/n67.json)
|A| = |B| = n - 1 and the graph is (2n-2)-regular; for even n (data/n58.json) |A| = n, |B| = n - 1 and
the degrees are 2n - 1 and 2n - 3. Then, for all pairs of distinct vertices, it counts common
neighbours and common non-neighbours and checks

  * the graph is simple: symmetric, no loops, A = -A, 0 not in A, the sizes and degrees above;
  * every edge has at most n-2 common neighbours        (no B_{n-1} in the graph);
  * every non-edge has at most n-1 common non-neighbours (no B_n in the complement).

It uses nothing from the papers beyond the two sets, and no library beyond the Python standard library.

Usage: python3 verification/python/verify_book.py [data/n58.json | data/n67.json]
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "data", "n58.json")
D = json.load(open(path))
n, v = D["n"], D["v"]
A, B = set(D["A"]), set(D["B"])
assert v == 2 * n - 1
even = n % 2 == 0
assert len(A) == (n if even else n - 1) and len(B) == n - 1, "sizes"
assert 0 not in A and all((-a) % v in A for a in A), "A must be symmetric and avoid 0"
C = set(range(1, v)) - A

N = 2 * v
adj = [0] * N   # adjacency rows as bit masks; vertex (x, i) is x + i*v


def edge(p, q):
    x, i = p % v, p // v
    y, j = q % v, q // v
    if i == j:
        return p != q and ((y - x) % v in (A if i == 0 else C))
    if i == 0:
        return (y - x) % v in B
    return (x - y) % v in B


for p in range(N):
    m = 0
    for q in range(N):
        if edge(p, q):
            m |= 1 << q
    adj[p] = m

full = (1 << N) - 1
deg = [bin(m).count("1") for m in adj]
want = [2 * n - 1] * v + [2 * n - 3] * v if even else [2 * n - 2] * N
assert deg == want, "degrees"
for p in range(N):
    assert not (adj[p] >> p) & 1, "loop"
    for q in range(N):
        assert ((adj[p] >> q) & 1) == ((adj[q] >> p) & 1), "not symmetric"

max_cn = max_cnn = 0
pairs = edges = 0
for p in range(N):
    for q in range(p + 1, N):
        pairs += 1
        if (adj[p] >> q) & 1:
            edges += 1
            max_cn = max(max_cn, bin(adj[p] & adj[q]).count("1"))
        else:
            rest = full & ~adj[p] & ~adj[q] & ~(1 << p) & ~(1 << q)
            max_cnn = max(max_cnn, bin(rest).count("1"))

shape = f"degrees {2*n-1} and {2*n-3}" if even else f"{2*n-2}-regular"
print(f"n = {n}, v = {v}, {N} vertices, {edges} edges, {pairs} pairs, {shape}")
print(f"largest number of common neighbours of an edge:         {max_cn} (bound {n-2})")
print(f"largest number of common non-neighbours of a non-edge:  {max_cnn} (bound {n-1})")
assert pairs == N * (N - 1) // 2
assert max_cn <= n - 2 and max_cnn <= n - 1
print(f"Gamma(A,B) has no B_{n-1} and its complement has no B_{n}: R(B_{n-1},B_{n}) > {N}")
