"""check_paper.py -- recompute every number printed in preprint/main.tex for n = 67.

Reads from the TeX source: the group H, the orbit representatives, the generators of A and B, the
explicit lists of A and B, Table 1, the footnote on N_AA(1), the slack counts of Figure 2 and the
remarks, and checks each against a fresh computation (and the lists against data/n67.json).

Usage: python3 verification/python/check_paper.py [preprint/main.tex]
"""
import json
import os
import re
import sys
from math import gcd

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
tex = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "preprint", "main.tex")).read()
data = json.load(open(os.path.join(ROOT, "data", "n67.json")))
n, v = 67, 133
ok = 0


def check(cond, what):
    global ok
    if not cond:
        sys.exit("check_paper: FAILED: " + what)
    ok += 1
    print("ok  " + what)


def ints(s):
    return [int(x) for x in re.findall(r"\d+", s)]


# -- H
m = re.search(r"H=\\\{u\\in\\Z_\{133\}:u\^3=1\\\}=\\\{([^}]*)\\\}", tex)
H = ints(m.group(1))
check(sorted(H) == [u for u in range(v) if pow(u, 3, v) == 1], "H is the group of cube roots of unity mod 133")
check({(u % 7, u % 19) for u in H} == {(a, b) for a in (1, 2, 4) for b in (1, 7, 11)}, "H = {1,2,4} x {1,7,11} under CRT")
check(len(H) == 9 and (v - 1) not in H, "|H| = 9 and -1 not in H, so |+-H| = 18")
PH = sorted({u for u in H} | {(-u) % v for u in H})


def orbit(G, x):
    return frozenset(g * x % v for g in G)


orbs = {orbit(PH, x) for x in range(1, v)}
check(len(orbs) == 10, "+-H has ten orbits on the nonzero residues")
reps = {min(O): len(O) for O in orbs}
m = re.search(r"representatives \$1,2,3,4,6,8\$", tex)
check(m is not None, "units: representatives 1,2,3,4,6,8 stated")
for d, size in [(1, 18), (2, 18), (3, 18), (4, 18), (6, 18), (8, 18), (7, 6), (14, 6), (28, 6), (19, 6)]:
    check(len(orbit(PH, d)) == size, f"orbit of {d} under +-H has size {size}")
check(len({orbit(PH, d) for d in (1, 2, 3, 4, 6, 8, 7, 14, 28, 19)}) == 10, "the ten representatives lie in distinct orbits")
check(sum(1 for x in range(1, v) if gcd(x, v) == 1) == 108, "108 units")
check(len({orbit(PH, x) for x in range(7, v, 7)}) == 3 and len({orbit(PH, x) for x in range(19, v, 19)}) == 1,
      "three orbits on the multiples of 7, one on the multiples of 19")
Horbs = {orbit(H, x) for x in range(1, v)}
check(len(Horbs) == 20 and "cube roots of unity have $20$ orbits" in tex, "H has 20 orbits on the nonzero residues (search remark)")

# -- A and B from their generators
m = re.search(r"A&=\\pm H\\cdot\\\{([^}]*)\\\}", tex)
genA = ints(m.group(1))
m = re.search(r"B&=H\\cdot\\\{([^}]*)\\\}", tex)
genB = ints(m.group(1))
A = set().union(*(orbit(PH, x) for x in genA))
B = set().union(*(orbit(H, x) for x in genB))
check(len(A) == 66 and all((-a) % v in A for a in A) and 0 not in A, "|A| = 66, A = -A, 0 not in A")
check(sorted(len(orbit(PH, x)) for x in genA) == [6, 6, 18, 18, 18], "A: three orbits of size 18, two of size 6")
check(sorted(len(orbit(H, x)) for x in genB) == [3] * 4 + [9] * 6 and len(B) == 66, "B: six H-orbits of size 9, four of size 3, |B| = 66")
check(len({orbit(H, x) for x in genB}) == 10, "the ten generators of B lie in distinct H-orbits")
m = re.search(r"A=\\\{&(.*?)\\\},\\\\", tex, re.S)
check(set(ints(m.group(1))) == A and len(ints(m.group(1))) == 66, "explicit list of A matches A = +-H{1,3,4,14,28}")
m = re.search(r"B=\\\{&(.*?)\\\}\.", tex, re.S)
check(set(ints(m.group(1))) == B and len(ints(m.group(1))) == 66, "explicit list of B matches B = H{2,5,...,70}")
check(sorted(A) == data["A"] and sorted(B) == data["B"] and sorted(H) == data["H"], "data/n67.json matches the paper")
check(len(B & {(-b) % v for b in B}) == 42 and "$-B$ in $42$ elements" in tex, "|B n -B| = 42")
check(any((-b) % v not in B for b in B), "B is not fixed by -1")


# -- Table 1
def N(X, Y, d):
    return len(X & {(y + d) % v for y in Y})


def f(d):
    return N(A, A, d) + N(B, B, d)


body = re.search(r"\\label\{tab:main\}.*?\\midrule(.*?)\\bottomrule", tex, re.S).group(1)
rows = [r for r in body.split("\\\\") if r.strip()]
check(len(rows) == 10, "Table 1 has ten rows")
total = 0
for r in rows:
    c = [x.strip() for x in r.split("&")]
    d, size, inA, naa, nbb, fd, bound, s = int(c[0]), int(c[1]), c[2], *map(int, c[3:])
    a = d in A
    check(size == len(orbit(PH, d)) and (inA == "yes") == a and naa == N(A, A, d) and nbb == N(B, B, d)
          and fd == naa + nbb and bound == 66 - a and s == bound - fd and s >= 0,
          f"Table 1 row d = {d}: |+-Hd| = {size}, {inA}, {naa} + {nbb} = {fd} <= {bound}, slack {s}")
    total += size * s
check(total == 66, "sizes times slacks add up to 66 (caption)")
for d in range(1, v):
    for u in H:
        assert f(u * d % v) == f(d)
    assert f((-d) % v) == f(d)
check(True, "f is invariant under +-H on all of Z_133 (Lemma 2.5)")

# -- footnote: N_AA(1) from the runs of A
fn = re.search(r"the runs (.*?) contribute (.*?)=36", tex, re.S)
runs = fn.group(1).replace("\\dots", "..").replace("$", "").split(";")
contrib = []
covered = set()
for r in runs:
    xs = ints(r)
    lo, hi = xs[0], xs[-1]
    covered |= set(range(lo, hi + 1))
    contrib.append(hi - lo)
check(contrib == ints(fn.group(2)) and sum(contrib) == 36 == N(A, A, 1), "footnote: the runs give N_AA(1) = 36")
check(covered == {a for a in A if (a - 1) in A or (a + 1) in A}, "footnote: the runs are exactly the runs of A of length >= 2")

# -- slack counts, remarks
sl = [66 - (d in A) - f(d) for d in range(1, v)]
check(min(sl) >= 0, "inequality (*) holds at every d != 0")
cnt = {k: sl.count(k) for k in set(sl)}
check(cnt == {0: 78, 1: 42, 2: 12} and "Equality holds for $78$ values of $d$, the slack is $1$ for $42$ and $2$ for $12$" in tex,
      "Figure 2 caption: slack 0, 1, 2 for 78, 42, 12 values of d")
check(sum(f(d) for d in range(1, v)) == 2 * (n - 1) * (n - 2) and sum(sl) == n - 1, "Remark 2.4: sum of f and of the slacks")
check({f(d) for d in A} == {63, 64, 65} and {f(d) for d in range(1, v) if d not in A} == {64, 65, 66},
      "Remark 4.1: f takes 63, 64, 65 on A and 64, 65, 66 on C")
check(266 * 265 // 2 == 35245 and "$35{,}245$ pairs" in tex, "35,245 pairs of vertices")
print(f"check_paper: all {ok} checks passed")
