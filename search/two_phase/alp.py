"""Anneal A on the LP margin.  usage: python3 alp.py n seed steps startfile out"""
import sys, random, math, time
import numpy as np
from lpscore import margin, setup
n, seed, steps = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]); start = sys.argv[4]; out = sys.argv[5]
random.seed(seed); v, P, C = setup(n)
A = {int(x) for x in open(start).read().split()} if start != '-' else None
pairs = sorted({min(a, v-a) for a in A}) if A else random.sample(range(1, P+1), n//2 if n % 2 == 0 else (n-1)//2)
inA = set(pairs); outA = [p for p in range(1, P+1) if p not in inA]; inA = list(inA)
def full(ps): return set(ps) | {v-p for p in ps}
cur = margin(n, full(inA), C)[0]; best = cur; bestA = list(inA); t0 = time.time()
for it in range(steps):
    T = 1.0 * (0.02/1.0) ** (it/steps)
    i, j = random.randrange(len(inA)), random.randrange(len(outA))
    trial = inA[:]; trial[i] = outA[j]
    m = margin(n, full(trial), C)[0]
    if m is None: continue
    if m >= cur or random.random() < math.exp((m-cur)/T):
        outA[j] = inA[i]; inA = trial; cur = m
        if cur > best: best = cur; bestA = inA[:]
print(n, seed, 'start', margin(n, full(pairs), C)[0], 'best margin %.3f' % best, '%.0fs' % (time.time()-t0))
open(out, 'w').write(' '.join(map(str, sorted(full(bestA)))) + '\n')
