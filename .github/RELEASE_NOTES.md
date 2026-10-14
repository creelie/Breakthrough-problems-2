R(B_66, B_67) = 267: the case n = 67 of Wesley's conjecture R(B_{n−1}, B_n) = 4n − 1 (Discrete
Math. 349 (2026), 114913), which no earlier construction covered. The upper bound is Rousseau and
Sheehan's (J. Graph Theory 2 (1978)); the lower bound is a two-block circulant graph on
Z_133 × {0, 1} with no B_66 whose complement has no B_67, its connection sets being unions of orbits
of the cube roots of unity modulo 133. The proof reduces both book conditions to one inequality,
checked by hand on ten orbits.

Attached: the paper (PDF), its LaTeX source with the figures as PNG, and the arXiv tarball. The
repository contains the Lean 4 kernel check of all 35,245 pairs of vertices (core Lean, standard
axioms only), independent checks in C and Python, the CP-SAT search, and the dated priority check.
Only n = 67 is settled; the conjecture stays open in general.

Author: Deep Bhattacharjee (ORCID 0000-0003-0466-750X).
