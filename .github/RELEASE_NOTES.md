R(B_57, B_58) = 231, the case n = 58 of Wesley's conjecture R(B_{n−1}, B_n) = 4n − 1, as the
journal manuscript submitted to Discrete Mathematics.

This release adds the one-column journal version of the paper (Elsevier `elsarticle`, 10 pages):
`paper/paper1/book-ramsey-58.pdf` and its LaTeX source `paper/paper2/book-ramsey-58-tex.zip`, both
attached here. Table 1 now stands on the page after Theorem 3.1, which it proves, instead of after
the references. The mathematics, the data, the C and Python checks and the Lean 4 proofs are those
of v2.0.0.

The lower bound is a graph on 230 vertices, a two-block circulant graph over Z_115, with no B_57
whose complement has no B_58; the upper bound is Rousseau–Sheehan. The paper reduces both book
conditions to one inequality, checked at the 57 values d = 1, …, 57 in its Table 1, and the
equality is proved in Lean 4 with the standard axioms only. The hand-checkable proof of
R(B_66, B_67) = 267 (Chung, Du and Wesley, Station data, 24 August 2026; not new here) is kept.

The conjecture stays open in general; for n ≤ 100 the open values are 59, 60, 64, 65, 68, 72, 73,
76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100.

Author: Deep Bhattacharjee (ORCID 0000-0003-0466-750X).
