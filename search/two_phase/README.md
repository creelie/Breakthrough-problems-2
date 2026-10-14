# Two-phase search for open values of n

This directory searches for graphs proving R(B_{n-1}, B_n) = 4n - 1 at values of n that are still
open. It follows the two-phase method of Turturean (May 2026), who found the values n <= 56 this way.
The only new parts here are the code and the LP-margin search for the first phase.

The graph lives on Z_v x {0, 1} with v = 2n - 1. Inside each copy, the edges are given by a
symmetric set A (red) and its complement, minus 0. Between the copies, they are given by a set B.
The book conditions reduce to bounds on f(d) = N_AA(d) + N_BB(d), where N_XX(d) counts the pairs
(x, x + d) in X:

| shape | size of A | size of B | f(d) bound for d in A | f(d) bound for d not in A |
|---|---|---|---|---|
| n odd (regular) | n - 1 | n - 1 | n - 2 | n - 1 |
| n even (Turturean) | n | n - 1 | n - 2 | n + 1 |

1. **Phase A.** `phaseA.c` anneals A to make the Fourier quantity R(k) = n - 2 - Â(k)^2 - 3Â(k)
   large for every frequency k (for odd n, R(k) = n - 1 - Â(k)^2 - Â(k)). `alp.py` then improves
   A by annealing on the margin t of the linear program in `lpscore.py`: if a B exists, its
   spectrum |B̂(k)|^2 is a feasible point of that LP.
2. **Phase B.** For the fixed A, `bsa.c` anneals B against the bounds, with B's autocorrelation
   pulled toward the LP's slack profile (`mkcap.py`).

`drive.sh n job minutes minutes_per_A workers` repeats both phases until time runs out. Every
solution is checked by brute force by `check.py`, which recounts the common neighbours on all
edges and the common non-neighbours on all non-edges of the 4n - 2 vertex graph. A solution printed
here is only a candidate: it must be checked independently, and checked against the published lists
(Turturean; the Station ledger of Chung, Du and Wesley), before any claim is made.

The workflow `.github/workflows/search-two-phase.yml` runs the jobs listed in `plan.json` on
GitHub Actions. Values of n that Turturean already settled (n = 40 and 46 in the first plan) serve
as calibration of the time a solution takes.
