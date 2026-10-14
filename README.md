# The book Ramsey number R(B_66, B_67)

The book B_k is the graph K_2 + K̄_k: k triangles sharing one edge. Rousseau and Sheehan,
*On Ramsey numbers for books*, J. Graph Theory 2 (1978), 77–87,
[doi:10.1002/jgt.3190020110](https://doi.org/10.1002/jgt.3190020110), proved
R(B_{n−1}, B_n) ≤ 4n − 1. Wesley, *Lower bounds for book Ramsey numbers*, Discrete Math. 349 (2026),
114913, [doi:10.1016/j.disc.2025.114913](https://doi.org/10.1016/j.disc.2025.114913)
([arXiv:2410.03625](https://arxiv.org/abs/2410.03625)), proved equality for n ≤ 20 and whenever
2n − 1 is a prime power congruent to 1 modulo 4, and conjectured it for every n. The conjecture is an
open problem of Epoch AI's FrontierMath collection
([Book Ramsey numbers](https://epoch.ai/frontiermath/open-problems/ramsey-book-graphs)). Later work
settled all n ≤ 56 and many further values (Turturean; Chung, Du and Wesley,
[arXiv:2608.23691](https://arxiv.org/abs/2608.23691); Price, n = 70), but not n = 67
(see [PRIORITY-CHECK.md](PRIORITY-CHECK.md)).

**This repository proves R(B_66, B_67) = 267.** The upper bound is Rousseau–Sheehan. For the lower
bound it gives a graph on 266 vertices with no B_66 whose complement has no B_67.

| | |
|---|---|
| vertices | Z_133 × {0, 1}, with 133 = 7 · 19 |
| edges | (x,0)–(y,0) if y − x ∈ A; (x,1)–(y,1) if y − x ∈ C = Z_133 ∖ (A ∪ {0}); (x,0)–(y,1) if y − x ∈ B |
| H | the cube roots of unity mod 133: {1, 11, 30, 39, 58, 64, 102, 106, 121} = {1,2,4} × {1,7,11} in Z_7 × Z_19 |
| A | ±H · {1, 3, 4, 14, 28} (66 elements, A = −A) |
| B | H · {2, 5, 8, 10, 12, 14, 20, 28, 57, 70} (66 elements) |
| the graph | 132-regular, every edge in at most 65 triangles, every non-adjacent pair with at most 66 common non-neighbours |

The full lists are in [`data/n67.json`](data/n67.json).

## What is proved, and how

The paper (`preprint/main.tex`, built into `dist/`) proves the result by hand. For a two-block
circulant graph Γ(A, B) on Z_{2n−1} × {0,1} it shows that the cross pairs never matter and that both
book conditions reduce to one inequality

    N_AA(d) + N_BB(d) ≤ n − 1 − [d ∈ A]   for every d ≠ 0,

where N_XY(d) = |X ∩ (Y + d)| (Proposition 2.3). Since A and B are fixed by H, the left side is
constant on the ten orbits of ±H, and the paper's Table 1 checks the inequality on those ten orbits.

The Lean 4 development in `lean/` (core Lean v4.35.0, no Mathlib) checks the graph itself: it
defines the 266 × 266 adjacency from bit masks of A and B, and the kernel evaluates the common
neighbours and common non-neighbours of all 35,245 pairs of vertices (`decide +kernel`, one theorem
per vertex, no `native_decide`). The final theorem is

```lean
theorem lower_bound :
    (∀ p q, p < 266 → q < 266 → adj p q = adj q p) ∧ (∀ p, adj p p = false) ∧
    (∀ p q, p < 266 → q < 266 → adj p q = true → cn p q ≤ 65) ∧
    (∀ p q, p < 266 → q < 266 → p ≠ q → adj p q = false → cnn p q ≤ 66)
```

where `cn p q` counts common neighbours and `cnn p q` common non-neighbours other than p and q.
An edge in k triangles is the spine of a B_k, so this says that the graph has no B_66 and its
complement has no B_67, that is R(B_66, B_67) > 266; the Lean files state the graph property and
leave this last translation, and the upper bound of Rousseau and Sheehan, to the paper.
`lean/Check.lean` prints the axioms of `no_red_book`, `no_blue_book`, `adj_symm`, `adj_irrefl` and
`lower_bound`, and `scripts/audit_axioms.py` checks that only `propext`, `Classical.choice` and
`Quot.sound` occur (`verification/axioms.txt`). The Lean files are generated from `data/n67.json`
by `scripts/gen_lean.py`.

Independent checks outside Lean (`scripts/run_all.sh`):

- `verification/c/check_book.c`: rebuilds the graph from `data/n67.json`, checks that it is simple
  and 132-regular, counts common neighbours and common non-neighbours of all pairs, and prints the
  slack of the inequality above at every d (0 at 78 values, 1 at 42, 2 at 12).
- `verification/python/verify_n67.py`: the same count, written separately in Python.
- `verification/python/check_paper.py`: reads H, the orbit representatives, A, B, Table 1, the
  footnotes, captions and remarks out of `preprint/main.tex` and recomputes all 48 numbers.
- `verification/python/open_values.py`: recomputes the values n ≤ 100 that no earlier construction
  covers (58, 59, 60, 64, 65, 67, 68, 72, 73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96, 100).
- `search/orbit_search.py`: the search that found the example. With A and B unions of orbits of
  the cube roots of unity, the inequality becomes a system in 20 + 20 Boolean variables, which the
  CP-SAT solver of OR-Tools solves in about a second; the set it returns is checked on all pairs.

## Layout

```
data/n67.json              n, v, H, A, B
lean/                      Lean 4 (core only, v4.35.0)
  BookRamsey/Defs.lean     the graph
  BookRamsey/RowsXX.lean   the kernel checks, one theorem per vertex
  BookRamsey/Main.lean     the theorems above
  Check.lean               axiom audit
verification/c/            check_book.c
verification/python/       verify_n67.py, check_paper.py, open_values.py
verification/axioms.txt    output of Check.lean
search/                    orbit_search.py (needs OR-Tools)
preprint/                  the paper (amsart) and its TikZ figures
dist/                      the paper as PDF, as LaTeX with PNG figures, and as an arXiv tarball
scripts/                   gen_lean.py, gen_figures.py, build_paper.sh, run_all.sh, audit_axioms.py
PRIORITY-CHECK.md          the dated check that n = 67 was open
```

To reproduce: `scripts/run_all.sh` (C compiler, Python 3; OR-Tools for the search),
`cd lean && lake build && lake env lean Check.lean` (Lean through elan; the kernel check took 31
minutes on a shared four-core machine, with up to about 2 GB of memory per Lean process), and
`scripts/build_paper.sh` (TeX Live). The workflow `.github/workflows/verify.yml` runs all three.

## What is open

Only n = 67 is settled here. The conjecture R(B_{n−1}, B_n) = 4n − 1 stays open in general, and
for n ≤ 100 at 58, 59, 60, 64, 65, 68, 72, 73, 76, 78, 80, 81, 84, 88, 89, 92, 93, 94, 96 and 100;
the same orbit search did not find examples there for the subgroups and time limits tried.

## Author

Deep Bhattacharjee, formerly Electro-Gravitational Space Propulsion Laboratory (EGSPL),
Bhubaneswar, Odisha 751030, India. d.bhattacharjee@erl-forschung.de, itsdeep@live.com,
ORCID [0000-0003-0466-750X](https://orcid.org/0000-0003-0466-750X).

The author used Claude (Anthropic) to search for the example, to check it by computer and in Lean,
and to draft the text; the author verified every step and is responsible for the content.

MIT License.
