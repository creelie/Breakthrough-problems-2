A new exact value of a book Ramsey number: R(B_57, B_58) = 231, the case n = 58 of Wesley's
conjecture R(B_{n−1}, B_n) = 4n − 1 (Discrete Math. 349 (2026), 114913), which was its smallest open
case. The lower bound is a graph on 230 vertices, a two-block circulant graph over Z_115 of the shape
Turturean uses for even n (|A| = 58, |B| = 57), with no B_57 whose complement has no B_58; the upper
bound is Rousseau–Sheehan. The paper reduces both book conditions to one inequality, checked at the
57 values d = 1, …, 57 in its Table 1. The graph was found by a two-phase local search (Turturean's
scheme, with a breakout-weighted search for B) and checked on all 26,335 pairs of vertices in C and
in Python. The equality itself is proved in Lean 4 (core Lean, standard axioms only): the kernel
checks the graph, and Goodman's count, formalised for every graph, gives the upper bound. The
priority check of 15 October 2026 found no earlier source.

This release also keeps the hand-checkable proof of R(B_66, B_67) = 267, a value first shown by
Chung, Du and Wesley in the Station data of 24 August 2026 (not new here; see v1.0.1), now also
proved in full in Lean 4.

Attached: both papers (PDF), their LaTeX sources with the figures as PNG, and the arXiv tarballs.
The conjecture stays open in general; for n ≤ 100 the open values are now 59, 60, 64, 65, 68, 72,
73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100.

Author: Deep Bhattacharjee (ORCID 0000-0003-0466-750X).
