"""Brute-force check of a two-block solution file (A, B; D22 = complement of A u {0}); works for both shapes."""
import sys
def check(n, A, B):
    v = 2*n-1; A = set(A); B = set(B); C = set(range(1, v)) - A; N = 2*v
    assert all((-a) % v in A for a in A) and 0 not in A
    D = {(0,0): A, (1,1): C, (0,1): B, (1,0): {(-b) % v for b in B}}
    rows = []
    for p in range(N):
        x, i = p % v, p // v; r = 0
        for q in range(N):
            y, j = q % v, q // v
            if p != q and (y-x) % v in D[i,j]: r |= 1 << q
        rows.append(r)
    full = (1 << N) - 1; cn = cb = 0
    for p in range(N):
        for q in range(p+1, N):
            if rows[p] >> q & 1: cn = max(cn, bin(rows[p] & rows[q]).count('1'))
            else: cb = max(cb, bin(full & ~rows[p] & ~rows[q] & ~(1<<p) & ~(1<<q)).count('1'))
    return cn, cb
for fn in sys.argv[1:]:
    L = open(fn).read().split('\n'); n = int(L[0].split()[1])
    A = list(map(int, L[1].split()[1:])); B = list(map(int, L[2].split()[1:]))
    cn, cb = check(n, A, B)
    print(fn, 'n', n, '|A|', len(A), '|B|', len(B), 'red', cn, '<=', n-2, 'blue', cb, '<=', n-1, 'OK' if cn <= n-2 and cb <= n-1 else 'FAIL')
