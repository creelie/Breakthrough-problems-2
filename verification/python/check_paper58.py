"""check_paper58.py -- recompute every number printed in preprint58/main.tex for n = 58.

Reads from the TeX source: the sets A_+, A and B, Table 1, the footnote on N_AA(1), the slack counts
of Figure 2 and the remarks, and checks each against a fresh computation (and the sets against
data/n58.json). It also checks the identities of Section 2 (Lemmas 2.1 and 2.2, Proposition 2.3 and
Remark 2.4) on the graph itself.

Usage: python3 verification/python/check_paper58.py [preprint58/main.tex]
"""
import json
import os
import re
import sys
from math import gcd

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
tex = open(sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "preprint58", "main.tex")).read()
data = json.load(open(os.path.join(ROOT, "data", "n58.json")))
n, v = 58, 115
ok = 0


def check(cond, what):
    global ok
    if not cond:
        sys.exit("check_paper58: FAILED: " + what)
    ok += 1
    print("ok  " + what)


def ints(s):
    return [int(x) for x in re.findall(r"\d+", s)]


# -- the sets
Ap = ints(re.search(r"A_\+=\\\{&(.*?)\\\},\\\\", tex, re.S).group(1))
B = set(ints(re.search(r"B=\\\{&(.*?)\\\}\.", tex, re.S).group(1)))
Al = ints(re.search(r"A=\\\{&(.*?)\\\}\.", tex, re.S).group(1))
A = set(Ap) | {(-a) % v for a in Ap}
check(len(Ap) == 29 and all(1 <= a <= 57 for a in Ap) and "The $29$ elements of $A_+$" in tex, "A_+ has 29 elements in 1..57")
check(len(A) == 58 and 0 not in A and A == {(-a) % v for a in A}, "A = +-A_+ has 58 elements, avoids 0, A = -A")
check(sorted(Al) == sorted(A) and len(Al) == 58, "the written-out list of A is +-A_+")
check(len(B) == 57 and len(ints(re.search(r"B=\\\{&(.*?)\\\}\.", tex, re.S).group(1))) == 57, "|B| = 57")
check(sorted(A) == data["A"] and sorted(B) == data["B"] and data["n"] == n and data["v"] == v, "data/n58.json matches the paper")
C = set(range(1, v)) - A
check(len(C) == n - 2, "|C| = n - 2 = 56")


def N(X, Y, d):
    return len(X & {(y + d) % v for y in Y})


def f(d):
    return N(A, A, d) + N(B, B, d)


# -- Section 2 on the graph itself
V = [(x, i) for i in (0, 1) for x in range(v)]


def adj(p, q):
    (x, i), (y, j) = p, q
    if p == q:
        return False
    if i == j:
        return (y - x) % v in (A if i == 0 else C)
    if i == 0:
        return (y - x) % v in B
    return (x - y) % v in B


nb = {p: {q for q in V if adj(p, q)} for p in V}
check(all(len(nb[(x, 0)]) == 2 * n - 1 and len(nb[(x, 1)]) == 2 * n - 3 for x in range(v)), "degrees 115 and 113")
check(all((q in nb[p]) == (p in nb[q]) for p in V for q in V), "the adjacency is symmetric")
lam_ok = all(len(nb[(0, 0)] & nb[(d, 0)]) == f(d) and len(nb[(0, 1)] & nb[(d, 1)]) == f(d) - 3 + 2 * (d in A)
             for d in range(1, v))
lam_ok &= all(len(nb[(0, 0)] & nb[(d, 1)]) == n - 1 - (d in B) for d in range(v))
check(lam_ok, "Lemma 2.1: the three formulas for lambda")
deg = {p: len(nb[p]) for p in V}
mu_ok = True
worst_cn, worst_cnn = 0, 0
pairs = 0
for a in range(len(V)):
    p = V[a]
    for b in range(a + 1, len(V)):
        q = V[b]
        pairs += 1
        lam = len(nb[p] & nb[q])
        if q in nb[p]:
            worst_cn = max(worst_cn, lam)
        else:
            mu = len(V) - 2 - len(nb[p] | nb[q])
            shift = -2 if p[1] == q[1] == 0 else (2 if p[1] == q[1] == 1 else 0)
            mu_ok &= mu == lam + shift
            worst_cnn = max(worst_cnn, mu)
check(mu_ok, "Lemma 2.2: mu = lambda - 2, lambda + 2, lambda")
check(pairs == 26335 and "$26{,}335$ pairs" in tex, "26,335 pairs of vertices")
check(worst_cn == n - 2 and worst_cnn == n - 1, "every edge has <= 56 common neighbours, every non-edge <= 57 common non-neighbours")

# -- Table 1
body = re.search(r"\\label\{tab:main\}.*?\\cmidrule\{9-15\}(.*?)\\bottomrule", tex, re.S).group(1)
seen = []
for line in body.split("\\\\"):
    if not line.strip():
        continue
    for half in line.split("&&"):
        c = [x.strip() for x in half.split("&")]
        if not c[0]:
            continue
        d, inA, naa, nbb, fd, bound, s = map(int, c)
        a = d in A
        check(inA == a and naa == N(A, A, d) and nbb == N(B, B, d) and fd == naa + nbb and bound == 59 - 3 * a
              and s == bound - fd and s >= 0, f"Table 1 row d = {d}: [{inA}] {naa} + {nbb} = {fd} <= {bound}, slack {s}")
        seen.append((d, s))
check(sorted(d for d, _ in seen) == list(range(1, 58)), "Table 1 lists d = 1, ..., 57 once each")
check(sum(s for _, s in seen) == 27 and "The slacks add up to $27$, half of $n-4=54$" in tex, "caption: the slacks in Table 1 add up to 27")
check(all(f((-d) % v) == f(d) and ((-d) % v in A) == (d in A) for d in range(1, v)), "Remark 2.4: f(-d) = f(d)")

# -- footnote: N_AA(1) from the runs of A
fn = re.search(r"the runs (.*?) contribute (.*?)=32", tex, re.S)
runs = fn.group(1).replace("\\dots", "..").replace("$", "").split(";")
contrib = []
covered = set()
for r in runs:
    xs = ints(r)
    lo, hi = xs[0], xs[-1]
    covered |= set(range(lo, hi + 1))
    contrib.append(hi - lo)
check(contrib == ints(fn.group(2)) and sum(contrib) == 32 == N(A, A, 1), "footnote: the runs give N_AA(1) = 32")
check(covered == {a for a in A if (a - 1) in A or (a + 1) in A}, "footnote: the runs are exactly the runs of A of length >= 2")
check(0 not in A and 114 not in A, "footnote: no run wraps around")

# -- slack counts, remarks
sl = [59 - 3 * (d in A) - f(d) for d in range(1, v)]
check(min(sl) >= 0, "inequality (2.1) holds at every d != 0")
cnt = {k: sl.count(k) for k in set(sl)}
check(cnt == {0: 70, 1: 34, 2: 10} and "Equality holds for $70$ values of $d$, the slack is $1$ for $34$ and $2$ for $10$" in tex,
      "Figure 2 caption: slack 0, 1, 2 for 70, 34, 10 values of d")
check(sum(f(d) for d in range(1, v)) == 2 * (n - 1) ** 2 and sum(59 - 3 * (d in A) for d in range(1, v)) == (n - 2) * (2 * n + 1)
      and sum(sl) == n - 4, "Remark 2.4: sum of f, of the bounds and of the slacks")
check(sl.count(0) >= n + 2, "Remark 2.4: equality for at least n + 2 values of d")
fa = [f(d) for d in A]
fc = [f(d) for d in C]
check({k: fa.count(k) for k in set(fa)} == {54: 4, 55: 18, 56: 36}
      and "values $54$, $55$ and $56$, for $4$, $18$ and $36$ of them" in tex, "Remark 4.1: f on A")
check({k: fc.count(k) for k in set(fc)} == {57: 6, 58: 16, 59: 34}
      and "values $57$, $58$ and $59$, for $6$, $16$ and $34$ of them" in tex, "Remark 4.1: f on C")
units = [u for u in range(1, v) if gcd(u, v) == 1]
check([u for u in units if {u * a % v for a in A} == A] == [1, v - 1], "Remark 4.2: only +-1 fix A")
check([u for u in units if {u * b % v for b in B} == B] == [1], "Remark 4.2: only 1 fixes B")
check(len(B & {(-b) % v for b in B}) == 29 and "$B$ meets $-B$ in $29$ elements" in tex, "Remark 4.2: |B n -B| = 29")
check(n % 2 == 0 and all((-x) % v != x for x in range(1, v)), "Section 1: no nonzero residue mod 115 is its own negative")
# -- formal verification: the last step of Goodman's count for N = 231
phi = [3 * d * (230 - d) + 56 * d + 57 * (230 - d) for d in range(231)]
check(max(phi) == 230 * 229 and [d for d, x in enumerate(phi) if x == 230 * 229] == [115] and 231 * 115 % 2 == 1
      and "each term on the right is at most $230\\cdot229$, with equality only when $d(w)=115$" in tex
      and "the odd number $231\\cdot115$" in tex and "$N=231$, $a=56$ and $b=57$" in tex,
      "Formal verification: 3dD + 56d + 57D <= 230*229 with equality only at d = 115, and 231*115 is odd")
print(f"check_paper58: all {ok} checks passed")
