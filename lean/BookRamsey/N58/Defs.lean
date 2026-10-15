/-
  Book Ramsey lower bound for n = 58: an explicit graph on 4n-2 = 230 vertices
  with no book B_{57} whose complement has no book B_{58}.
  Vertices are 0, ..., 229; vertex p lies in block p / 115 at position p % 115.
  Two vertices of block 0 are adjacent when their difference lies in A,
  two vertices of block 1 when it lies in the nonzero residues outside A,
  and (x, 0), (y, 1) are adjacent when y - x lies in B (residues mod 115).
-/
namespace BookRamsey.N58

/-- Bit mask of the symmetric set A of residues mod 115 (58 elements). -/
def Amask : Nat := 5256501352784118757172390970870792
/-- Bit mask of the cross set B of residues mod 115 (57 elements). -/
def Bmask : Nat := 25602914103240767551374966970814181

def inA (d : Nat) : Bool := Amask.testBit d
def inB (d : Nat) : Bool := Bmask.testBit d
def inC (d : Nat) : Bool := d != 0 && !(Amask.testBit d)

/-- Residue of (q - p) mod 115, computed from the positions of p and q. -/
def diff (p q : Nat) : Nat := (q % 115 + 115 - p % 115) % 115

/-- Adjacency of the graph on the vertices 0, ..., 229. -/
def adj (p q : Nat) : Bool :=
  if p == q then false
  else if p < 115 then
    (if q < 115 then inA (diff p q) else inB (diff p q))
  else
    (if q < 115 then inB (diff q p) else inC (diff p q))

/-- Number of common neighbours of p and q. -/
def cn (p q : Nat) : Nat := (List.range 230).countP (fun r => adj p r && adj q r)

/-- Number of vertices other than p, q adjacent to neither. -/
def cnn (p q : Nat) : Nat :=
  (List.range 230).countP (fun r => r != p && r != q && !(adj p r) && !(adj q r))

/-- The condition for one pair: an edge has at most 56 common neighbours,
    a non-edge at most 57 common non-neighbours. -/
def okPair (p q : Nat) : Bool :=
  if adj p q then decide (cn p q ≤ 56) else decide (cnn p q ≤ 57)

/-- Row p: every pair (p, q) with p < q < 230 satisfies the condition, and adj p q = adj q p
    for every q < 230. -/
def rowOk (p : Nat) : Bool :=
  (List.range' (p+1) (229 - p)).all (fun q => okPair p q) &&
    (List.range 230).all (fun q => adj p q == adj q p)

end BookRamsey.N58
