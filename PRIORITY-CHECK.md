# Priority check: the book Ramsey number R(B_57, B_58)

Question: before this work, had anyone shown R(B_57, B_58) = 231, that is, given a graph on 230
vertices with no book B_57 whose complement has no book B_58 (the case n = 58 of Wesley's conjecture
R(B_{n-1}, B_n) = 4n - 1)?

Checked 15 October 2026, finished 10:40 UTC. **Answer: no source found.** Every source that lists the
solved values (the Station ledger included) gives n = 58 as open, and none of the known families
reaches it.

| Source | What was checked | Result |
|---|---|---|
| Epoch AI, FrontierMath open problem "Book Ramsey numbers" (https://epoch.ai/frontiermath/open-problems/ramsey-book-graphs) | the page and its updates, fetched 15 October 2026 | updates of 2 May (Turturean, all n ≤ 56 plus families), 25 June (Dualverse AI), 31 July (Price, n = 70), 13 August (Station: n = 70, 106, 142, 154, 166, 190, …, 86, 127, 233), and the note of 22 September that the page no longer lists incremental results; 58 is not mentioned |
| W. J. Wesley, Discrete Math. 349 (2026), 114913 | Theorem 2 | 2·58 − 1 = 115 = 5·23 is not a prime power |
| D. Turturean, summary document (text export of 15 October 2026) | the list of covered values | all n ≤ 56 and 57, 61, 63, 69, 71, 75, 77, 79, 83, 85, 87, 91, 95, 97, 99; not 58. The Szekeres family needs 4n − 1 prime, and 4·58 − 1 = 231 = 3·7·11 |
| S. Chung, W. Du, W. J. Wesley, arXiv:2608.23691v2 (14 September 2026) | the three families | conference family needs n − 1 = 57 = 3·19 a prime power (or n = 5·9^{2t+1} + 1, or 66); doubled Legendre family needs 115 a prime power; Yamada–Pott family gives 11, 28, 86, …; none is 58 |
| Station data v2 (local copy of 14 October 2026; later commits not checked, as that repository is outside this session's GitHub scope) | ledger of Section 6.1 | lists 58, 59, 60, … as open for n ≤ 100 |
| L. Price (Epoch update of 31 July 2026) | the single value reported | n = 70 |
| L. Dai and Q. Lin, arXiv:2606.07214v2 (updated 13 October 2026) | abstract | diagonal numbers R(B_n, B_n) and R(B_{n−2}, B_n); nothing on R(B_57, B_58) |
| arXiv API | `abs:book AND abs:Ramsey`, newest first, listing of 15 October 2026 10:06 UTC | nothing on R(B_{n−1}, B_n) beyond the papers above |
| Zenodo API | `"book Ramsey"`, newest first | one unrelated record (quadrilateral–book Ramsey numbers, Boza, 24 August 2026) |
| OpenRefute (local clone of creelie/trureturing-OpenRefute, 10 October 2026) | `Problems/`, `Library/`, `D5/` for book graphs, book Ramsey, Wesley | nothing |
| Web search | "R(B_57,B_58)", "R(B_{57},B_{58})", Wesley's conjecture with n = 58, 59, 60 | nothing beyond the sources above |

Conclusion: R(B_57, B_58) = 231 is, to the best of this check, new here. The graph is
`data/n58.json`; it was checked by `verification/c/check_book.c`, `verification/python/verify_book.py`,
the search's own `check.py`, and the Lean kernel (`lean/BookRamsey/N58/`). The values n ≤ 100 that stay
open are 59, 60, 64, 65, 68, 72, 73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100.

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
