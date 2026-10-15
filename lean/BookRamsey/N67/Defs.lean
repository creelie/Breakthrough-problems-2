/-
  Book Ramsey lower bound for n = 67: an explicit graph on 4n-2 = 266 vertices
  with no book B_{66} whose complement has no book B_{67}.
  Vertices are 0, ..., 265; vertex p lies in block p / 133 at position p % 133.
  Two vertices of block 0 are adjacent when their difference lies in A,
  two vertices of block 1 when it lies in the nonzero residues outside A,
  and (x, 0), (y, 1) are adjacent when y - x lies in B (residues mod 133).
-/
namespace BookRamsey.N67

/-- Bit mask of the symmetric set A of residues mod 133 (66 elements). -/
def Amask : Nat := 7528255861839116960895973426150842138138
/-- Bit mask of the cross set B of residues mod 133 (66 elements). -/
def Bmask : Nat := 9256904612754647540348261068888098632996

def inA (d : Nat) : Bool := Amask.testBit d
def inB (d : Nat) : Bool := Bmask.testBit d
def inC (d : Nat) : Bool := d != 0 && !(Amask.testBit d)

/-- Residue of (q - p) mod 133, computed from the positions of p and q. -/
def diff (p q : Nat) : Nat := (q % 133 + 133 - p % 133) % 133

/-- Adjacency of the graph on the vertices 0, ..., 265. -/
def adj (p q : Nat) : Bool :=
  if p == q then false
  else if p < 133 then
    (if q < 133 then inA (diff p q) else inB (diff p q))
  else
    (if q < 133 then inB (diff q p) else inC (diff p q))

/-- Number of common neighbours of p and q. -/
def cn (p q : Nat) : Nat := (List.range 266).countP (fun r => adj p r && adj q r)

/-- Number of vertices other than p, q adjacent to neither. -/
def cnn (p q : Nat) : Nat :=
  (List.range 266).countP (fun r => r != p && r != q && !(adj p r) && !(adj q r))

/-- The condition for one pair: an edge has at most 65 common neighbours,
    a non-edge at most 66 common non-neighbours. -/
def okPair (p q : Nat) : Bool :=
  if adj p q then decide (cn p q ≤ 65) else decide (cnn p q ≤ 66)

/-- Row p: every pair (p, q) with p < q < 266 satisfies the condition, and adj p q = adj q p
    for every q < 266. -/
def rowOk (p : Nat) : Bool :=
  (List.range' (p+1) (265 - p)).all (fun q => okPair p q) &&
    (List.range 266).all (fun q => adj p q == adj q p)

end BookRamsey.N67
