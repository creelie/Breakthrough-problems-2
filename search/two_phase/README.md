# Two-phase search for open values of n

This directory searches for graphs proving R(B_{n-1}, B_n) = 4n - 1 at values of n that are still
open. It follows the two-phase method of Turturean (May 2026), who found the values n <= 56 this way.
The new parts here are the code, the LP-margin search and the slack-volume search for the first
phase.

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
   The default first phase is `phaseH.c` instead: an iterated local search (best pair swap, then
   three random swaps, repeated) that maximises the slack-volume score
   G(A) = sum_k log Phi((R(k) + mu) / sigma), with S = (n - 4)/2 (n even) or (n - 1)/2 (n odd)
   units of slack spread over the P = n - 1 pair offsets, mu = S/P and sigma = sqrt(2S). The score
   estimates the log-probability that a random slack profile leaves every |B̂(k)|^2 = R(k) - ĝ(k)
   nonnegative. At n = 40 it ranks candidate sets in nearly the order of the excess the second phase
   reaches on them, and the sets it finds make the second phase much shorter (n = 40 solved within
   six minutes on four cores, against 43 minutes with the LP-margin sets).
2. **Phase B.** For the fixed A, `bsa.c` anneals B against the bounds, with B's autocorrelation
   pulled toward the LP's slack profile (`mkcap.py`). With `BALG=bwls` the second phase is
   `bwls.c` instead: a weighted local search on pair swaps (remove one element of B, add one
   outside it). Each bound carries a weight; the search takes the swap that lowers the weighted
   excess most among the eight best-ranked removals and additions, with a short tabu list, and when
   no swap helps it raises the weights of the violated bounds by one (breakout), letting them decay
   back toward one with probability 0.2 per raise. On the known-solvable set at n = 40 it found B in
   all six runs, in 2 to 26 seconds each, where `bsa.c` found none in six runs of 60 seconds.
   On the set that solved n = 46 on Actions it finds B about once per 15 CPU-minutes (restarts every
   100000 steps), against about once per 80 CPU-minutes for `bsa.c`.

`drive.sh n job minutes minutes_per_A workers` repeats both phases until time runs out
(`SEL=lp` selects the older first phase). Every
solution is checked by brute force by `check.py`, which recounts the common neighbours on all
edges and the common non-neighbours on all non-edges of the 4n - 2 vertex graph. A solution printed
here is only a candidate: it must be checked independently, and checked against the published lists
(Turturean; the Station ledger of Chung, Du and Wesley), before any claim is made.

The workflow `.github/workflows/search-two-phase.yml` runs the jobs listed in `plan.json` on
GitHub Actions. Values of n that Turturean already settled (n = 40 and 46 in the first plan) serve
as calibration of the time a solution takes; the second plan runs n = 46, 52 and 56 for that
purpose.

Results with `BALG=bwls`, restarts every 10^6 steps, one-hour rounds on four workers (run
38681705838, jobs 101 to 112):

| n | jobs x rounds | outcome |
|---|---|---|
| 52 (known) | 2 x 5 | solved in job 101, round 4 (`bsol_52_1010034`); otherwise least excess 1 |
| 58 (open before this run) | 5 x 5 | solved in job 106, round 5 (`bsol_58_1060041`, now `data/n58.json`); one other round reached excess 1 |
| 59 (open) | 5 x 5 | least excess 2 in every round |

With `bsa.c` the same n = 52 search had not found a solution in 4 hours on 4 workers (least
excess 1).
