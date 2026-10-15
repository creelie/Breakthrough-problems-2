# Book Ramsey numbers: R(B_57, B_58) = 231 and R(B_66, B_67) = 267

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23373628.svg)](https://doi.org/10.5281/zenodo.23373628)

Concept DOI of all versions: [10.5281/zenodo.23373628](https://doi.org/10.5281/zenodo.23373628).

| Release | Content | Version DOI |
|---|---|---|
| v2.0.0 | R(B_57, B_58) = 231 (new) and R(B_66, B_67) = 267, both proved in full in Lean 4 | [10.5281/zenodo.23393415](https://doi.org/10.5281/zenodo.23393415) |
| v1.0.1 | R(B_66, B_67) = 267 only, crediting Chung, Du and Wesley | [10.5281/zenodo.23377549](https://doi.org/10.5281/zenodo.23377549) |
| v1.0.0 | superseded by v1.0.1 | [10.5281/zenodo.23373629](https://doi.org/10.5281/zenodo.23373629) |

The book B_k is the graph K_2 + K̄_k: k triangles sharing one edge. Rousseau and Sheehan,
*On Ramsey numbers for books*, J. Graph Theory 2 (1978), 77–87,
[doi:10.1002/jgt.3190020110](https://doi.org/10.1002/jgt.3190020110), proved
R(B_{n−1}, B_n) ≤ 4n − 1. Wesley, *Lower bounds for book Ramsey numbers*, Discrete Math. 349 (2026),
114913, [doi:10.1016/j.disc.2025.114913](https://doi.org/10.1016/j.disc.2025.114913)
([arXiv:2410.03625](https://arxiv.org/abs/2410.03625)), proved equality for n ≤ 20 and whenever
2n − 1 is a prime power congruent to 1 modulo 4, and conjectured it for every n. The conjecture is an
open problem of Epoch AI's FrontierMath collection
([Book Ramsey numbers](https://epoch.ai/frontiermath/open-problems/ramsey-book-graphs)). Later work
settled all n ≤ 57 and many further values (Turturean; Chung, Du and Wesley,
[arXiv:2608.23691](https://arxiv.org/abs/2608.23691), whose data also settle n = 67; Price, n = 70);
see [PRIORITY-CHECK.md](PRIORITY-CHECK.md).

## R(B_57, B_58) = 231: a new value

**This repository settles n = 58**, which was the smallest open case of the conjecture (as of
15 October 2026; see the n = 58 section of [PRIORITY-CHECK.md](PRIORITY-CHECK.md)). The upper bound
is Rousseau–Sheehan; for the lower bound, a graph on 230 vertices with no B_57 whose complement has no
B_58. Both bounds, and so the value itself, are also proved in Lean 4 (below). The paper is
`preprint58/main.tex` (6 pages), built into `dist/book-ramsey-58_final2.pdf`.

| | |
|---|---|
| vertices | Z_115 × {0, 1}, with 115 = 5 · 23 |
| edges | (x,0)–(y,0) if y − x ∈ A; (x,1)–(y,1) if y − x ∈ C = Z_115 ∖ (A ∪ {0}); (x,0)–(y,1) if y − x ∈ B |
| A | ±{3, 10, 11, 14, 16, 18, 21, 23, 24, 25, 26, 27, 28, 29, 30, 32, 36, 37, 38, 43, 44, 46, 47, 48, 49, 52, 54, 55, 56} (58 elements) |
| B | 57 elements, listed in [`data/n58.json`](data/n58.json) |
| the graph | degrees 115 and 113, every edge in at most 56 triangles, every non-adjacent pair with at most 57 common non-neighbours |

For even n a regular two-block circulant graph of this kind cannot exist (a symmetric set avoiding 0
has even size), so the graph has the shape Turturean uses for even n: |A| = n, |B| = n − 1,
|C| = n − 2. The paper proves that for this shape both book conditions reduce to

    N_AA(d) + N_BB(d) ≤ n + 1 − 3[d ∈ A]   for every d ≠ 0,

with total slack n − 4 (54 here), and checks the 57 values d = 1, …, 57 in its Table 1. The graph has
no multiplier symmetry beyond d ↦ −d. It was found by the two-phase search in
[`search/two_phase/`](search/two_phase/README.md) (Turturean's scheme, with a weighted local search
with breakout for B), in job 106 of Actions run 38681705838.

## R(B_66, B_67) = 267: a hand-checkable proof

**Correction.** Release v1.0.0 presented R(B_66, B_67) = 267 as a new value. It is not: Chung, Du and
Wesley proved it in the data accompanying their Station paper, published on 24 August 2026
([station_data_v2](https://github.com/dualverse-ai/station_data_v2),
`artifacts/book_ramsey/verification.ipynb`, Section 5.1, certificate `finite_n67`), and their graph
is isomorphic to the one here (`verification/python/station_isomorphism.py`). The priority check of
v1.0.0 read their paper but not that repository. What this repository adds for n = 67 is the
description of the graph by multiplier orbits, a proof checkable by hand, and a Lean 4 proof of the value.
The paper is `preprint/main.tex`, built into `dist/book-ramsey-67_final2.pdf`.

| | |
|---|---|
| vertices | Z_133 × {0, 1}, with 133 = 7 · 19 |
| edges | (x,0)–(y,0) if y − x ∈ A; (x,1)–(y,1) if y − x ∈ C = Z_133 ∖ (A ∪ {0}); (x,0)–(y,1) if y − x ∈ B |
| H | the cube roots of unity mod 133: {1, 11, 30, 39, 58, 64, 102, 106, 121} = {1,2,4} × {1,7,11} in Z_7 × Z_19 |
| A | ±H · {1, 3, 4, 14, 28} (66 elements, A = −A) |
| B | H · {2, 5, 8, 10, 12, 14, 20, 28, 57, 70} (66 elements) |
| the graph | 132-regular, every edge in at most 65 triangles, every non-adjacent pair with at most 66 common non-neighbours |

The full lists are in [`data/n67.json`](data/n67.json). For odd n the reduced inequality is
N_AA(d) + N_BB(d) ≤ n − 1 − [d ∈ A]; since A and B are fixed by H, the left side is constant on the
ten orbits of ±H, and Table 1 of that paper checks the inequality on those ten orbits.

## Lean 4

The Lean 4 development in `lean/` (core Lean v4.35.0, no Mathlib) proves both values outright:

```lean
/-- Every graph on N vertices contains B_m or has a complement containing B_n. -/
def Arrows (N m n : Nat) : Prop :=
  ∀ G : Nat → Nat → Bool, Symm N G → HasRedBook N m G ∨ HasBlueBook N n G

/-- R(B_m, B_n) = R: every graph on R vertices arrows and no smaller number does. -/
def IsBookRamsey (m n R : Nat) : Prop := Arrows R m n ∧ ∀ N, N < R → ¬ Arrows N m n

theorem BookRamsey.book_ramsey_58 : IsBookRamsey 57 58 231
theorem BookRamsey.book_ramsey_67 : IsBookRamsey 66 67 267
```

A graph on the vertices 0, ..., N-1 is a symmetric `G : Nat → Nat → Bool`; `HasRedBook N k G` says
that some edge uv has at least k common neighbours other than u and v (a book B_k), and
`HasBlueBook N k G` says the same of a non-edge and common non-neighbours (`lean/BookRamsey/Upper.lean`).

- Lower bounds (`lower58`, `lower67`). For each graph, `lean/BookRamsey/N58/` and
  `lean/BookRamsey/N67/` define the adjacency from bit masks of A and B, and the kernel evaluates the
  common neighbours and common non-neighbours of all pairs of vertices (26,335 and 35,245;
  `decide +kernel`, one theorem per vertex, no `native_decide`): every edge has at most 56 (resp. 65)
  common neighbours and every non-edge at most 57 (resp. 66) common non-neighbours.
- Upper bounds (`upper58`, `upper67`). `lean/BookRamsey/Upper.lean` proves Goodman's count in the form
  of Rousseau and Sheehan for every graph: if every edge lies in at most a triangles and every
  non-edge has at most b common non-neighbours, then N(N-1)(N-2) ≤ Σ_w (3 d(w) D(w) + a d(w) + b D(w)),
  with d(w) the degree and D(w) = N - 1 - d(w), by counting ordered triples of distinct vertices by
  the colours of their pairs. For N = 4n - 1, a = n - 2, b = n - 1 each term is at most
  (N-1)(N-2), with equality only at d(w) = 2n - 1, and then the degrees add up to the odd number
  N(2n - 1); the kernel evaluates this last step for n = 58 and 67. The finite sums are in
  `lean/BookRamsey/Sums.lean`.

`lean/Check.lean` prints the axioms of `no_red_book`, `no_blue_book`, `adj_symm`, `adj_irrefl` and
`lower_bound` for both graphs and of `upper58`, `lower58`, `book_ramsey_58`, `upper67`, `lower67`,
`book_ramsey_67`, and `scripts/audit_axioms.py` checks that only `propext`, `Classical.choice` and
`Quot.sound` occur (`verification/axioms.txt`). `Sums.lean` and `Upper.lean` are written by hand; the
other Lean files are generated from `data/n58.json` and `data/n67.json` by `scripts/gen_lean.py`.

## Independent checks outside Lean (`scripts/run_all.sh`)

- `verification/c/check_book.c`: rebuilds each graph from its data file, checks that it is simple
  with the degrees of its shape, counts common neighbours and common non-neighbours of all pairs, and
  prints the slack of the reduced inequality at every d (n = 58: 0 at 70 values, 1 at 34, 2 at 10;
  n = 67: 0 at 78, 1 at 42, 2 at 12).
- `verification/python/verify_book.py`: the same count, written separately in Python.
- `verification/python/check_paper58.py`: reads A_+, A, B, Table 1, the footnote, captions and
  remarks out of `preprint58/main.tex`, recomputes them, and checks Lemmas 2.1 and 2.2 and
  Proposition 2.3 on the graph itself (86 checks).
- `verification/python/check_paper.py`: the same for `preprint/main.tex` (49 checks).
- `verification/python/open_values.py`: recomputes the values n ≤ 100 that no published
  construction covered before n = 58 was settled, and those that remain (footnote 1 of both papers).
- `verification/python/station_isomorphism.py`: relabels the n = 67 graph by the bijection in
  `data/station_isomorphism.json` and checks that the result has the SHA-256 digest that Chung, Du and
  Wesley publish for their certificate `finite_n67` (with `--npz` it also compares entry by entry with
  their array, which is not redistributed here).
- `search/orbit_search.py`: the search that found the n = 67 example. With A and B unions of orbits
  of the cube roots of unity, the inequality becomes a system in 20 + 20 Boolean variables, which the
  CP-SAT solver of OR-Tools solves in about a second; the set it returns is checked on all pairs.
- `search/two_phase/`: the search that found the n = 58 example (described in its README, with the
  runs on GitHub Actions); every solution it prints is rechecked on all pairs by `check.py`.

## Layout

```
data/n58.json              n, v, A, B for n = 58
data/n67.json              n, v, H, A, B for n = 67
data/station_isomorphism.json  the bijection onto the certificate of Chung, Du and Wesley
lean/                      Lean 4 (core only, v4.35.0)
  BookRamsey/N58/, N67/    Defs.lean (the graph), RowsXX.lean (kernel checks, one theorem per
                           vertex), Main.lean (no book in the graph or its complement)
  BookRamsey/Sums.lean     finite sums and double counting
  BookRamsey/Upper.lean    Goodman's count and the upper bound R(B_{n-1}, B_n) <= 4n - 1
  BookRamsey/Value.lean    book_ramsey_58 and book_ramsey_67
  Check.lean               axiom audit
verification/c/            check_book.c
verification/python/       verify_book.py, check_paper58.py, check_paper.py, open_values.py,
                           station_isomorphism.py
verification/axioms.txt    output of Check.lean
search/                    orbit_search.py (needs OR-Tools), two_phase/ (n = 58)
preprint58/                the n = 58 paper (amsart) and its TikZ figures
preprint/                  the n = 67 paper
dist/                      both papers as PDF, as LaTeX with PNG figures, and as arXiv tarballs
scripts/                   gen_lean.py, gen_figures.py, build_paper.sh, run_all.sh, audit_axioms.py
PRIORITY-CHECK.md          the dated priority checks for n = 58 and n = 67
MasterBookRamsey58_masterzipfinal2.zip  n = 58: paper, Discrete Mathematics manuscript and cover
                           letter, priority check, and the repository at release v2.0.0
MasterBookRamsey67_masterzipfinal2.zip  n = 67: the same at release v1.0.0
```

To reproduce: `scripts/run_all.sh` (C compiler, Python 3; OR-Tools for the search),
`cd lean && lake build && lake env lean Check.lean` (Lean through elan; the kernel checks of the
graphs took about 16 minutes on a four-core machine, 6.4 for n = 58 and 10 for n = 67, with up to
about 2 GB of memory per Lean process; the upper bounds take seconds), and
`scripts/build_paper.sh` (TeX Live). The workflow `.github/workflows/verify.yml` runs all three.

## What is open

The conjecture R(B_{n−1}, B_n) = 4n − 1 stays open in general, and for n ≤ 100 at 59, 60, 64, 65,
68, 72, 73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100. At n = 59 the two-phase search came no
closer than a total excess of 2 over the bounds in 25 one-hour rounds, and found no graph.

## Author

Deep Bhattacharjee, formerly Electro-Gravitational Space Propulsion Laboratory (EGSPL),
Bhubaneswar, Odisha 751030, India. d.bhattacharjee@erl-forschung.de, itsdeep@live.com,
ORCID [0000-0003-0466-750X](https://orcid.org/0000-0003-0466-750X).

The author used Claude (Anthropic) to search for the example, to check it by computer and in Lean,
and to draft the text; the author verified every step and is responsible for the content.

MIT License.
