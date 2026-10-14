# Priority check: the book Ramsey number R(B_66, B_67)

Question: before this work, had anyone shown R(B_66, B_67) = 267, that is, given a graph on 266
vertices with no book B_66 whose complement has no book B_67 (the case n = 67 of Wesley's conjecture
R(B_{n-1}, B_n) = 4n - 1)?

Checked 14 October 2026, 13:30–14:40 UTC, and again 15:15–15:40 UTC. **Answer: yes.** The check
missed the data repository of the Station paper (last row of the table), which settles n = 67 with the
same graph; it was found at about 18:30 UTC the same day.

| Source | What was checked | Result |
|---|---|---|
| Epoch AI, FrontierMath open problem "Book Ramsey numbers" (https://epoch.ai/frontiermath/open-problems/ramsey-book-graphs) | the problem page and its updates (Turturean 2 May, Dualverse AI 25 June, Price 31 July, Station 13 August 2026; the page stopped listing incremental results on 22 September 2026) | no construction for n = 67 is reported |
| W. J. Wesley, *Lower bounds for book Ramsey numbers*, Discrete Math. 349 (2026), 114913 (arXiv:2410.03625v2) | Theorem 2 | equality for n ≤ 20 and whenever 2n − 1 is a prime power ≡ 1 (mod 4); 2·67 − 1 = 133 = 7·19 is not a prime power |
| D. Turturean, *Summary of new results on the Ramsey numbers for book graphs open problem* (Google document linked from the Epoch page, text export of 14 October 2026) | the list of covered values | all n ≤ 56 and 57, 61, 63, 69, 71, 75, 77, 79, 83, 85, 87, 91, 95, 97, 99; the Szekeres (Legendre) family needs 4n − 1 prime ≡ 3 (mod 8), and 4·67 − 1 = 267 = 3·89 |
| S. Chung, W. Du, W. J. Wesley, *Autonomous mathematical discovery in an open-world multi-agent environment*, arXiv:2608.23691v2 (the "Station" and Dualverse AI work), Section 6.13 and Figure 14 | the three families and the finite examples | conference family: n − 1 a prime power ≡ 1 (mod 4), n = 5·9^{2t+1} + 1, and n = 66; doubled Legendre family: 2n − 1 a prime power ≡ 3 (mod 8); Yamada–Pott family: n = (q² − q + 2)/4, q ≡ 3 (mod 4) a prime power (11, 28, 86, 127, 176, 233 below 250); finite examples only up to n = 56; n = 67 is in none of them |
| L. Price (Epoch update of 31 July 2026) | the single value reported | n = 70 |
| L. Dai and Q. Lin, *Book Ramsey numbers via algebraic constructions*, arXiv:2606.07214v2 | abstract and main results | diagonal numbers R(B_n, B_n) and R(B_{n−2}, B_n); nothing on R(B_66, B_67) |
| F. Angulo Lafuente, *A 46-100 verified coverage of the FrontierMath Ramsey book-graph problem via 2-block circulant construction*, ResearchGate preprint, April 2026 | abstract only (the full text returned HTTP 403) | the abstract reports 46 values of n ≤ 100, from base cases, Wesley's difference sets, SAT-based annealing and a 2-block Paley construction, and a barrier for the remaining values; it predates Turturean's 71 values, and none of the later summaries above lists n = 67 as solved |
| arXiv API | `abs:book AND abs:Ramsey`, newest first (to 8 October 2026) | besides the papers above, only other Ramsey problems for books (star-critical numbers, Gallai–Ramsey numbers, R(B_8, B_10) = 37, books versus cycles); nothing on R(B_{n−1}, B_n) for n = 67 |
| Zenodo API | `"book Ramsey"`, `"book graphs" Ramsey` | one unrelated record (quadrilateral–book Ramsey numbers) |
| OpenRefute (the-omega-institute/trureturing issues) | issue search for "book Ramsey" | no issue |
| Web search | the conjecture, "R(B_66,B_67)", "n = 67", the Dualverse claim, a Manifold market on the Szekeres family | nothing beyond the sources above |
| S. Chung, W. Du, W. J. Wesley, Station data v2 (https://github.com/dualverse-ai/station_data_v2, linked from arXiv:2608.23691; first public commit `606e325f`, 24 August 2026), `artifacts/book_ramsey/verification.ipynb` Section 5.1 and `book_ramsey_certificates.npz` | the notebook, the certificate array `finite_n67` and the ledger of Section 6.1 | **Theorem 5.1: R(B_66, B_67) = 267**, by a 266-vertex certificate (SHA-256 `819dbb31…a1cf1`), "a regular two-fibre coloring on 266 vertices built from multiplier orbits over Z_133". It is isomorphic to the graph of this repository (`verification/python/station_isomorphism.py`). The ledger lists 58, 59, 60, 64, 65, 68, 72, 73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100 as open for n ≤ 100. |

Conclusion: R(B_66, B_67) = 267 was first shown by Chung, Du and Wesley in the Station data of
24 August 2026, by the same graph up to isomorphism. This repository found that graph independently
and adds an explicit description by multiplier orbits, a proof checkable by hand and a Lean 4 kernel
check; it does not settle a new value. The values n ≤ 100 that none of the sources above covers are
58, 59, 60, 64, 65, 68, 72, 73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100.
