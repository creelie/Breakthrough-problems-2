A hand-checkable proof that R(B_66, B_67) = 267, the case n = 67 of Wesley's conjecture
R(B_{n−1}, B_n) = 4n − 1 (Discrete Math. 349 (2026), 114913). The value was first shown by Chung, Du
and Wesley in the Station data of 24 August 2026 (github.com/dualverse-ai/station_data_v2, notebook
Section 5.1), by a 266-vertex certificate. This release describes that graph, up to isomorphism, as
a two-block circulant graph on Z_133 × {0, 1} whose connection sets are unions of orbits of the cube
roots of unity modulo 133; the proof reduces both book conditions to one inequality, checked by hand
on ten orbits. Version 1.0.0 presented the value as new; that was wrong, and this version corrects it.

Attached: the paper (PDF), its LaTeX source with the figures as PNG, and the arXiv tarball. The
repository contains the Lean 4 kernel check of all 35,245 pairs of vertices (core Lean, standard
axioms only), independent checks in C and Python, the isomorphism with the Station certificate, the
CP-SAT search, and the dated priority check. No new value of n is settled; the conjecture stays open.

Author: Deep Bhattacharjee (ORCID 0000-0003-0466-750X).
