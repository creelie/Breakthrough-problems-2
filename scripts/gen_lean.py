"""gen_lean.py -- write the Lean 4 project lean/ from the data files data/n67.json and data/n58.json.

For each data file, with N = N67 or N58:
  lean/BookRamsey/N/Defs.lean    the graph: bit masks of A and B, adjacency, common (non-)neighbours
  lean/BookRamsey/N/RowsXX.lean  one theorem per vertex p, `rowOk p = true`, checked by `decide +kernel`
                                 (about 17 files of equal work), and the chunk theorem of each file
  lean/BookRamsey/N/Main.lean    symmetry, no book B_{n-1}, no book B_n in the complement, lower_bound
lean/BookRamsey/Value.lean states R(B_{n-1}, B_n) = 4n - 1 for each n, from the graph of Main (the lower
bound) and Goodman's count in the hand-written lean/BookRamsey/Upper.lean (the upper bound), which uses
the finite sums of lean/BookRamsey/Sums.lean. lean/BookRamsey.lean imports every Main and Value, and
lean/Check.lean prints the axioms of the main theorems.
The definitions do not depend on the shape of the graph (|A| = n - 1 for odd n, |A| = n for even n).

Uses only the Lean core (no Mathlib). Usage: python3 scripts/gen_lean.py [OUT [DATA ...]]
"""
import json, os, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'lean')
files = sys.argv[2:] or [os.path.join(ROOT, 'data', f) for f in ('n67.json', 'n58.json')]
modules = []


def gen(path):
    d = json.load(open(path))
    n, v = d['n'], d['v']; NV = 2*v
    A = d['A']; B = d['B']
    am = sum(1 << x for x in A); bm = sum(1 << x for x in B)
    NAME = f'N{n}'
    modules.append(NAME)
    os.makedirs(f'{out}/BookRamsey/{NAME}', exist_ok=True)
    defs = f"""/-
  Book Ramsey lower bound for n = {n}: an explicit graph on 4n-2 = {NV} vertices
  with no book B_{{{n-1}}} whose complement has no book B_{{{n}}}.
  Vertices are 0, ..., {NV-1}; vertex p lies in block p / {v} at position p % {v}.
  Two vertices of block 0 are adjacent when their difference lies in A,
  two vertices of block 1 when it lies in the nonzero residues outside A,
  and (x, 0), (y, 1) are adjacent when y - x lies in B (residues mod {v}).
-/
namespace BookRamsey.{NAME}

/-- Bit mask of the symmetric set A of residues mod {v} ({len(A)} elements). -/
def Amask : Nat := {am}
/-- Bit mask of the cross set B of residues mod {v} ({len(B)} elements). -/
def Bmask : Nat := {bm}

def inA (d : Nat) : Bool := Amask.testBit d
def inB (d : Nat) : Bool := Bmask.testBit d
def inC (d : Nat) : Bool := d != 0 && !(Amask.testBit d)

/-- Residue of (q - p) mod {v}, computed from the positions of p and q. -/
def diff (p q : Nat) : Nat := (q % {v} + {v} - p % {v}) % {v}

/-- Adjacency of the graph on the vertices 0, ..., {NV-1}. -/
def adj (p q : Nat) : Bool :=
  if p == q then false
  else if p < {v} then
    (if q < {v} then inA (diff p q) else inB (diff p q))
  else
    (if q < {v} then inB (diff q p) else inC (diff p q))

/-- Number of common neighbours of p and q. -/
def cn (p q : Nat) : Nat := (List.range {NV}).countP (fun r => adj p r && adj q r)

/-- Number of vertices other than p, q adjacent to neither. -/
def cnn (p q : Nat) : Nat :=
  (List.range {NV}).countP (fun r => r != p && r != q && !(adj p r) && !(adj q r))

/-- The condition for one pair: an edge has at most {n-2} common neighbours,
    a non-edge at most {n-1} common non-neighbours. -/
def okPair (p q : Nat) : Bool :=
  if adj p q then decide (cn p q ≤ {n-2}) else decide (cnn p q ≤ {n-1})

/-- Row p: every pair (p, q) with p < q < {NV} satisfies the condition, and adj p q = adj q p
    for every q < {NV}. -/
def rowOk (p : Nat) : Bool :=
  (List.range' (p+1) ({NV-1} - p)).all (fun q => okPair p q) &&
    (List.range {NV}).all (fun q => adj p q == adj q p)

end BookRamsey.{NAME}
"""
    open(f'{out}/BookRamsey/{NAME}/Defs.lean', 'w').write(defs)
    # balanced chunks by pair count
    K = 16; total = NV*(NV-1)//2; chunks = []; start = 0; acc = 0
    for p in range(NV):
        acc += NV-1-p
        if acc >= total*(len(chunks)+1)/K or p == NV-1:
            chunks.append((start, p+1-start)); start = p+1
    for i, (a, b) in enumerate(chunks):
        rows = list(range(a, a+b))
        thms = '\n'.join(f"""set_option maxRecDepth 100000 in
theorem row{p:03d} : rowOk {p} = true := by decide +kernel""" for p in rows)
        lst = ', '.join(str(p) for p in rows)
        names = ', '.join(f'row{p:03d}' for p in rows)
        open(f'{out}/BookRamsey/{NAME}/Rows{i:02d}.lean', 'w').write(f"""import BookRamsey.{NAME}.Defs
namespace BookRamsey.{NAME}

/-! Rows {a} to {a+b-1}, each checked by the kernel in its own theorem. -/

{thms}

theorem rows{i:02d} : (List.range' {a} {b}).all rowOk = true := by
  have e : List.range' {a} {b} = [{lst}] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, {names}, Bool.and_true]

end BookRamsey.{NAME}
""")
    imports = '\n'.join(f'import BookRamsey.{NAME}.Rows{i:02d}' for i in range(len(chunks)))
    facts = '\n'.join(f'  have h{i:02d} := (List.all_eq_true.mp rows{i:02d}) p' for i in range(len(chunks)))
    cases = []
    for i, (a, b) in enumerate(chunks):
        cases.append(f'  · exact h{i:02d} (List.mem_range\'_1.mpr (by omega))' if i == len(chunks)-1 else
                     f'  by_cases c{i:02d} : p < {a+b}\n  · exact h{i:02d} (List.mem_range\'_1.mpr (by omega))')
    main = f"""{imports}
namespace BookRamsey.{NAME}

theorem rowOk_all (p : Nat) (hp : p < {NV}) : rowOk p = true := by
{facts}
""" + '\n'.join(cases) + f"""

theorem adj_symm (p q : Nat) (hp : p < {NV}) (hq : q < {NV}) : adj p q = adj q p := by
  have h := rowOk_all p hp
  simp only [rowOk, Bool.and_eq_true] at h
  have h2 := (List.all_eq_true.mp h.2) q (List.mem_range.mpr hq)
  simpa using h2

theorem adj_irrefl (p : Nat) : adj p p = false := by simp [adj]

theorem cn_symm (p q : Nat) : cn p q = cn q p := by
  simp only [cn, Bool.and_comm]

theorem cnn_symm (p q : Nat) : cnn p q = cnn q p := by
  unfold cnn
  congr 1
  funext r
  cases (r != p) <;> cases (r != q) <;> cases adj p r <;> cases adj q r <;> rfl

theorem okPair_lt (p q : Nat) (hpq : p < q) (hq : q < {NV}) : okPair p q = true := by
  have h := rowOk_all p (by omega)
  simp only [rowOk, Bool.and_eq_true] at h
  exact List.all_eq_true.mp h.1 q (List.mem_range'_1.mpr (by omega))

/-- No edge lies in {n-1} triangles: the graph has no book B_{n-1}. -/
theorem no_red_book (p q : Nat) (hp : p < {NV}) (hq : q < {NV}) (h : adj p q = true) :
    cn p q ≤ {n-2} := by
  rcases Nat.lt_trichotomy p q with hlt | heq | hgt
  · have := okPair_lt p q hlt hq
    simp only [okPair, h, ite_true, decide_eq_true_eq] at this
    exact this
  · subst heq; simp [adj_irrefl] at h
  · have h' : adj q p = true := by rw [adj_symm q p hq hp]; exact h
    have := okPair_lt q p hgt hp
    simp only [okPair, h', ite_true, decide_eq_true_eq] at this
    rw [cn_symm]; exact this

/-- No non-edge has {n} common non-neighbours: the complement has no book B_{n}. -/
theorem no_blue_book (p q : Nat) (hp : p < {NV}) (hq : q < {NV}) (hne : p ≠ q)
    (h : adj p q = false) : cnn p q ≤ {n-1} := by
  rcases Nat.lt_trichotomy p q with hlt | heq | hgt
  · have := okPair_lt p q hlt hq
    simp only [okPair, h, Bool.false_eq_true, ite_false, decide_eq_true_eq] at this
    exact this
  · exact absurd heq hne
  · have h' : adj q p = false := by rw [adj_symm q p hq hp]; exact h
    have := okPair_lt q p hgt hp
    simp only [okPair, h', Bool.false_eq_true, ite_false, decide_eq_true_eq] at this
    rw [cnn_symm]; exact this

/-- The graph on the vertices 0, ..., {NV-1} witnesses R(B_{n-1}, B_{n}) > {NV}: it is a simple graph,
    every edge lies in at most {n-2} triangles, and every pair of distinct non-adjacent vertices has
    at most {n-1} common non-neighbours. -/
theorem lower_bound :
    (∀ p q, p < {NV} → q < {NV} → adj p q = adj q p) ∧ (∀ p, adj p p = false) ∧
    (∀ p q, p < {NV} → q < {NV} → adj p q = true → cn p q ≤ {n-2}) ∧
    (∀ p q, p < {NV} → q < {NV} → p ≠ q → adj p q = false → cnn p q ≤ {n-1}) :=
  ⟨adj_symm, adj_irrefl, no_red_book, no_blue_book⟩

end BookRamsey.{NAME}
"""
    open(f'{out}/BookRamsey/{NAME}/Main.lean', 'w').write(main)
    print(NAME, 'chunks', chunks)


for f in files:
    gen(f)
ns = [int(m[1:]) for m in modules]


def value_name(n):
    return f'R(B_{{{n-1}}}, B_{{{n}}}) = {4*n-1}'


value = ('/-\n  ' + ' and '.join(value_name(n) for n in ns) + ', as statements about all graphs.\n'
         '  The lower bounds are the explicit graphs of ' + ' and '.join(f'`{m}`' for m in modules)
         + '; the upper bounds are Goodman\'s\n'
         '  count in `Upper`, with the final arithmetic evaluated by the kernel.\n-/\n'
         'import BookRamsey.Upper\n' + ''.join(f'import BookRamsey.{m}.Main\n' for m in modules)
         + '\nnamespace BookRamsey\n')
for m, n in zip(modules, ns):
    N = 4*n - 1
    value += f"""
set_option maxRecDepth 100000 in
/-- Every graph on {N} vertices contains `B_{n-1}` or has a complement containing `B_{n}`. -/
theorem upper{n} : Arrows {N} {n-1} {n} :=
  upper_of {N} {n-2} {n-1} {2*n-1} (by decide +kernel) (by decide +kernel) (by decide)

/-- The graph of `{m}` on {N-1} vertices has no `B_{n-1}`, and its complement has no `B_{n}`. -/
theorem lower{n} : ¬ Arrows {N-1} {n-1} {n} := by
  intro hA
  rcases hA {m}.adj (fun u v hu hv => {m}.adj_symm u v hu hv) with
    ⟨u, v, hu, hv, huv, he, hk⟩ | ⟨u, v, hu, hv, huv, he, hk⟩
  · have e : redBook {N-1} {m}.adj u v = {m}.cn u v := by
      unfold redBook {m}.cn
      rw [countP_range, countP_range]
      apply S_congr; intro r _
      unfold ind
      by_cases a : r = u
      · subst a; simp [{m}.adj_irrefl]
      · by_cases b : r = v
        · subst b; simp [{m}.adj_irrefl]
        · simp [a, b]
    have := {m}.no_red_book u v hu hv he
    omega
  · have := {m}.no_blue_book u v hu hv huv he
    have e : blueBook {N-1} {m}.adj u v = {m}.cnn u v := rfl
    omega

/-- `{value_name(n)}`: every graph on {N} vertices contains `B_{n-1}` or has a complement
    containing `B_{n}`, and {N} is the least such number. -/
theorem book_ramsey_{n} : IsBookRamsey {n-1} {n} {N} :=
  isBookRamsey_of {n-1} {n} {N} (by decide) upper{n} lower{n}
"""
value += '\nend BookRamsey\n'
open(f'{out}/BookRamsey/Value.lean', 'w').write(value)
open(f'{out}/BookRamsey.lean', 'w').write(''.join(f'import BookRamsey.{m}.Main\n' for m in modules)
                                          + 'import BookRamsey.Value\n')
open(f'{out}/lakefile.toml', 'w').write('name = "BookRamsey"\ndefaultTargets = ["BookRamsey"]\n\n[[lean_lib]]\nname = "BookRamsey"\n')
open(f'{out}/lean-toolchain', 'w').write('leanprover/lean4:v4.35.0\n')
check = 'import BookRamsey\n'
for m in modules:
    for t in ('no_red_book', 'no_blue_book', 'adj_symm', 'adj_irrefl', 'lower_bound'):
        check += f'#print axioms BookRamsey.{m}.{t}\n'
for n in ns:
    for t in ('upper', 'lower', 'book_ramsey_'):
        check += f'#print axioms BookRamsey.{t}{n}\n'
open(f'{out}/Check.lean', 'w').write(check)
