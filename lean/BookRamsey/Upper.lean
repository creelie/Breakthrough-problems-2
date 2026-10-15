/-
  The upper bound of Rousseau and Sheehan, R(B_{n-1}, B_n) ≤ 4n - 1, by Goodman's count.

  A graph on the vertices 0, ..., N-1 is a symmetric map G : Nat → Nat → Bool (its values on the
  diagonal play no role). Suppose every edge lies in at most a triangles and every non-edge has at
  most b common non-neighbours. Counting the ordered triples of distinct vertices by the colours
  of their three pairs gives, with d(w) the degree of w and D(w) = N - 1 - d(w),

      N (N-1) (N-2) ≤ Σ_w (3 d(w) D(w) + a d(w) + b D(w)).

  For N = 4n - 1, a = n - 2, b = n - 1 every term on the right is at most (N-1)(N-2), with
  equality only at d(w) = 2n - 1; then the degrees add up to the odd number N (2n - 1),
  which is impossible. The last step is checked by evaluation for the values of n used here.
-/
import BookRamsey.Sums

namespace BookRamsey

/-- Number of vertices `r ≠ u, v` adjacent to both `u` and `v`. -/
def redBook (N : Nat) (G : Nat → Nat → Bool) (u v : Nat) : Nat :=
  (List.range N).countP (fun r => r != u && r != v && G u r && G v r)

/-- Number of vertices `r ≠ u, v` adjacent to neither `u` nor `v`. -/
def blueBook (N : Nat) (G : Nat → Nat → Bool) (u v : Nat) : Nat :=
  (List.range N).countP (fun r => r != u && r != v && !G u r && !G v r)

/-- `G` is symmetric on the vertices `0, ..., N-1`. -/
def Symm (N : Nat) (G : Nat → Nat → Bool) : Prop := ∀ u v, u < N → v < N → G u v = G v u

/-- `G` contains the book `B_k`: an edge whose ends have at least `k` common neighbours. -/
def HasRedBook (N k : Nat) (G : Nat → Nat → Bool) : Prop :=
  ∃ u v, u < N ∧ v < N ∧ u ≠ v ∧ G u v = true ∧ k ≤ redBook N G u v

/-- The complement of `G` contains `B_k`: a non-edge with at least `k` common non-neighbours. -/
def HasBlueBook (N k : Nat) (G : Nat → Nat → Bool) : Prop :=
  ∃ u v, u < N ∧ v < N ∧ u ≠ v ∧ G u v = false ∧ k ≤ blueBook N G u v

section Count

variable (N : Nat) (G : Nat → Nat → Bool)

/-- Degree of `w`. -/
def deg (w : Nat) : Nat := S N (fun u => ind (u != w && G u w))

/-- Number of vertices other than `w` not adjacent to `w`. -/
def codeg (w : Nat) : Nat := S N (fun u => ind (u != w && !G u w))

/-- Triple sum over `u, v, w < N`. -/
def T (f : Nat → Nat → Nat → Nat) : Nat := S N (fun u => S N (fun v => S N (fun w => f u v w)))

def dist3 (u v w : Nat) : Bool := u != v && v != w && u != w

theorem dist3_rot (u v w : Nat) : dist3 v w u = dist3 u v w := by
  unfold dist3
  rw [bne_comm (a := w) (b := u), bne_comm (a := v) (b := u)]
  cases (u != v) <;> cases (v != w) <;> cases (u != w) <;> rfl

/-- The pairs `uw`, `vw` have different colours. -/
def Mo (u v w : Nat) : Nat := ind (dist3 u v w && G u w != G v w)

/-- The pairs `uw`, `vw` have the same colour, different from that of `uv`. -/
def Op (u v w : Nat) : Nat := ind (dist3 u v w && G u w == G v w && G u v != G u w)

/-- The triangle `uvw` is monochromatic. -/
def Sa (u v w : Nat) : Nat := ind (dist3 u v w && G u w == G v w && G u v == G u w)

end Count

theorem T_congr (N : Nat) (f g : Nat → Nat → Nat → Nat)
    (h : ∀ u v w, u < N → v < N → w < N → f u v w = g u v w) : T N f = T N g := by
  unfold T
  apply S_congr; intro u hu
  apply S_congr; intro v hv
  apply S_congr; intro w hw
  exact h u v w hu hv hw

theorem T_add (N : Nat) (f g : Nat → Nat → Nat → Nat) :
    T N (fun u v w => f u v w + g u v w) = T N f + T N g := by
  unfold T
  have : ∀ u, u < N → S N (fun v => S N (fun w => f u v w + g u v w)) =
      S N (fun v => S N (fun w => f u v w)) + S N (fun v => S N (fun w => g u v w)) := by
    intro u _
    have : ∀ v, v < N → S N (fun w => f u v w + g u v w) =
        S N (fun w => f u v w) + S N (fun w => g u v w) := fun v _ => S_add N _ _
    rw [S_congr N _ _ this, S_add]
  rw [S_congr N _ _ this, S_add]

theorem T_mul (N c : Nat) (f : Nat → Nat → Nat → Nat) :
    T N (fun u v w => c * f u v w) = c * T N f := by
  unfold T
  have : ∀ u, u < N → S N (fun v => S N (fun w => c * f u v w)) =
      c * S N (fun v => S N (fun w => f u v w)) := by
    intro u _
    have : ∀ v, v < N → S N (fun w => c * f u v w) = c * S N (fun w => f u v w) :=
      fun v _ => S_mul_left N c _
    rw [S_congr N _ _ this, S_mul_left]
  rw [S_congr N _ _ this, S_mul_left]

/-- A triple sum is unchanged by a cyclic shift of the variables. -/
theorem T_rot (N : Nat) (f : Nat → Nat → Nat → Nat) : T N (fun u v w => f v w u) = T N f := by
  unfold T
  rw [S_swap N N (fun u v => S N (fun w => f v w u))]
  apply S_congr; intro v _
  exact S_swap N N (fun u w => f v w u)

theorem S_one (N u : Nat) (hu : u < N) : S N (fun v => ind (v != u)) = N - 1 := by
  have key : ∀ k, S k (fun v => ind (v != u)) + (if u < k then 1 else 0) = k := by
    intro k
    induction k with
    | zero => simp [S_zero]
    | succ k ih =>
      rw [S_succ, ite_lt_succ u k]
      have hi : ind (k != u) + (if k = u then 1 else 0) = 1 := by
        unfold ind; by_cases a : k = u <;> simp [a]
      omega
  have h := key N
  simp [hu] at h
  omega

section Facts

variable (N : Nat) (G : Nat → Nat → Bool) (hG : Symm N G)
include hG

omit hG in
theorem deg_add_codeg (w : Nat) (hw : w < N) : deg N G w + codeg N G w = N - 1 := by
  unfold deg codeg
  rw [← S_add, ← S_one N w hw]
  apply S_congr; intro u _
  unfold ind
  cases G u w <;> by_cases a : u = w <;> simp [a]

/-- The cyclic identity behind Goodman's count: in each triangle the mixed angles are twice the
    angles opposite an edge of the other colour. -/
theorem mo_op (u v w : Nat) (hu : u < N) (hv : v < N) (hw : w < N) :
    Mo G u v w + Mo G v w u + Mo G w u v = 2 * (Op G u v w + Op G v w u + Op G w u v) := by
  unfold Mo Op
  rw [hG v u hv hu, hG w u hw hu, hG w v hw hv, dist3_rot u v w, dist3_rot v w u, dist3_rot u v w]
  cases dist3 u v w <;> cases G u v <;> cases G v w <;> cases G u w <;> rfl

theorem T_mo : T N (Mo G) = 2 * T N (Op G) := by
  have h3 : T N (Mo G) + T N (Mo G) + T N (Mo G) = 2 * (T N (Op G) + T N (Op G) + T N (Op G)) := by
    have r1 : T N (fun u v w => Mo G v w u) = T N (Mo G) := T_rot N (Mo G)
    have r2 : T N (fun u v w => Mo G w u v) = T N (Mo G) := by
      rw [← T_rot N (fun u v w => Mo G w u v)]
    have s1 : T N (fun u v w => Op G v w u) = T N (Op G) := T_rot N (Op G)
    have s2 : T N (fun u v w => Op G w u v) = T N (Op G) := by
      rw [← T_rot N (fun u v w => Op G w u v)]
    have lhs : T N (Mo G) + T N (fun u v w => Mo G v w u) + T N (fun u v w => Mo G w u v) =
        T N (fun u v w => Mo G u v w + Mo G v w u + Mo G w u v) := by
      rw [T_add, T_add]
    have rhs : T N (fun u v w => 2 * (Op G u v w + Op G v w u + Op G w u v)) =
        2 * (T N (Op G) + T N (fun u v w => Op G v w u) + T N (fun u v w => Op G w u v)) := by
      rw [T_mul, T_add, T_add]
    have mid := T_congr N _ _ (fun u v w hu hv hw => mo_op N G hG u v w hu hv hw)
    rw [r1, r2] at lhs
    rw [s1, s2] at rhs
    rw [lhs, mid, rhs]
  omega

omit hG in
/-- Angles at `w` with legs of different colours. -/
theorem mo_at (w : Nat) (hw : w < N) :
    S N (fun u => S N (fun v => Mo G u v w)) = 2 * (deg N G w * codeg N G w) := by
  have inner : ∀ u, u < N → S N (fun v => Mo G u v w) =
      ind (u != w && G u w) * codeg N G w + ind (u != w && !G u w) * deg N G w := by
    intro u _
    unfold codeg deg
    by_cases a : u = w
    · subst a
      have : ∀ v, v < N → Mo G u v u = 0 := by
        intro v _; unfold Mo dist3 ind; simp
      rw [S_congr N _ (fun _ => 0) this, S_const]
      unfold ind; simp
    · cases h : G u w
      · have : ∀ v, v < N → Mo G u v w = ind (v != w && G v w) := by
          intro v _
          unfold Mo dist3 ind
          by_cases b : u = v
          · subst b; simp [h]
          · by_cases c : v = w <;> cases G v w <;> simp [a, b, c, h]
        rw [S_congr N _ _ this]
        unfold ind; simp [a]
      · have : ∀ v, v < N → Mo G u v w = ind (v != w && !G v w) := by
          intro v _
          unfold Mo dist3 ind
          by_cases b : u = v
          · subst b; simp [h]
          · by_cases c : v = w <;> cases G v w <;> simp [a, b, c, h]
        rw [S_congr N _ _ this]
        unfold ind; simp [a]
  rw [S_congr N _ _ inner, S_add, S_mul_right, S_mul_right]
  unfold deg codeg
  rw [Nat.mul_comm (S N fun u => ind (u != w && !G u w))]
  omega

omit hG in
theorem T_mo_deg : T N (Mo G) = S N (fun w => 2 * (deg N G w * codeg N G w)) := by
  have : T N (Mo G) = T N (fun w u v => Mo G u v w) :=
    (T_rot N (fun u v w => Mo G w u v)).trans (T_rot N (fun w u v => Mo G u v w))
  rw [this]
  unfold T
  apply S_congr; intro w hw
  exact mo_at N G w hw

omit hG in
theorem sa_pair (u v : Nat) (hu : u < N) (hv : v < N) :
    S N (fun w => Sa G u v w) =
      if u = v then 0 else if G u v then redBook N G u v else blueBook N G u v := by
  unfold redBook blueBook
  rw [countP_range, countP_range]
  by_cases a : u = v
  · subst a
    have : ∀ w, w < N → Sa G u u w = 0 := by intro w _; unfold Sa dist3 ind; simp
    rw [S_congr N _ _ this, S_congr N (fun _ => 0) (fun _ => 0) (fun _ _ => rfl), S_const]
    simp
  · simp only [a, ite_false]
    apply Eq.symm
    cases h : G u v
    · simp only [Bool.false_eq_true, ite_false]
      apply S_congr; intro w _
      unfold Sa dist3 ind
      by_cases b : w = u <;> by_cases c : w = v
      · subst b; exact absurd c a
      · subst b; simp [h]
      · subst c; simp [h]
      · have b' : u ≠ w := fun e => b e.symm
        have c' : v ≠ w := fun e => c e.symm
        cases G u w <;> cases G v w <;> simp [a, b, c, b', c', h]
    · simp only [ite_true]
      apply S_congr; intro w _
      unfold Sa dist3 ind
      by_cases b : w = u <;> by_cases c : w = v
      · subst b; exact absurd c a
      · subst b; simp [h]
      · subst c; simp [h]
      · have b' : u ≠ w := fun e => b e.symm
        have c' : v ≠ w := fun e => c e.symm
        cases G u w <;> cases G v w <;> simp [a, b, c, b', c', h]

omit hG in
theorem T_dist :
    T N (fun u v w => ind (dist3 u v w)) = S N (fun _ => (N - 1) * (N - 2)) := by
  unfold T
  apply S_congr; intro u hu
  have : ∀ v, v < N → S N (fun w => ind (dist3 u v w)) = ind (v != u) * (N - 2) := by
    intro v hv
    by_cases a : v = u
    · subst a
      have : ∀ w, w < N → ind (dist3 v v w) = 0 := by intro w _; unfold dist3 ind; simp
      rw [S_congr N _ _ this, S_congr N (fun _ => 0) (fun _ => 0) (fun _ _ => rfl), S_const]
      unfold ind; simp
    · have a' : u ≠ v := fun e => a e.symm
      rw [← S_two N u v hu hv a']
      have : ∀ w, w < N → ind (dist3 u v w) = ind (w != u && w != v) := by
        intro w _
        unfold dist3 ind
        by_cases b : w = u <;> by_cases c : w = v
        · subst b; exact absurd c a'
        · subst b; simp
        · subst c; simp
        · have b' : u ≠ w := fun e => b e.symm
          have c' : v ≠ w := fun e => c e.symm
          simp [a', b, c, b', c']
      rw [S_congr N _ _ this]
      unfold ind; simp [a]
  rw [S_congr N _ _ this, S_mul_right, S_one N u hu]

/-- Goodman's count, in the form used by Rousseau and Sheehan. -/
theorem goodman (a b : Nat)
    (hr : ∀ u v, u < N → v < N → u ≠ v → G u v = true → redBook N G u v ≤ a)
    (hb : ∀ u v, u < N → v < N → u ≠ v → G u v = false → blueBook N G u v ≤ b) :
    S N (fun _ => (N - 1) * (N - 2)) ≤
      S N (fun w => 3 * (deg N G w * codeg N G w) + a * deg N G w + b * codeg N G w) := by
  have split : T N (fun u v w => ind (dist3 u v w)) = T N (Mo G) + T N (Op G) + T N (Sa G) := by
    rw [← T_add, ← T_add]
    apply T_congr; intro u v w _ _ _
    unfold Mo Op Sa ind
    cases dist3 u v w <;> cases G u w <;> cases G v w <;> cases G u v <;> simp
  have hmo := T_mo N G hG
  have hdeg := T_mo_deg N G
  have hsa : T N (Sa G) ≤ S N (fun u => a * deg N G u + b * codeg N G u) := by
    unfold T
    apply S_le; intro u hu
    have : ∀ v, v < N → S N (fun w => Sa G u v w) ≤
        a * ind (v != u && G v u) + b * ind (v != u && !G v u) := by
      intro v hv
      rw [sa_pair N G u v hu hv, hG v u hv hu]
      by_cases e : u = v
      · subst e; simp [ind]
      · have e' : v ≠ u := fun h => e h.symm
        cases h : G u v
        · simp [e, e', ind, hb u v hu hv e h]
        · simp [e, e', ind, hr u v hu hv e h]
    refine Nat.le_trans (S_le N _ _ this) ?_
    rw [S_add, S_mul_left, S_mul_left]
    exact Nat.le_refl _
  rw [← T_dist N, split]
  have e3 : S N (fun w => 3 * (deg N G w * codeg N G w) + a * deg N G w + b * codeg N G w) =
      3 * S N (fun w => deg N G w * codeg N G w) + S N (fun u => a * deg N G u + b * codeg N G u) := by
    rw [← S_mul_left, ← S_add]
    apply S_congr; intro w _; omega
  have e2 : S N (fun w => 2 * (deg N G w * codeg N G w)) = 2 * S N (fun w => deg N G w * codeg N G w) :=
    S_mul_left _ _ _
  rw [e3]
  omega

/-- The degrees add up to an even number. -/
theorem deg_even : S N (fun w => deg N G w) % 2 = 0 := by
  unfold deg
  rw [S_swap]
  -- h u w = ind (u != w && G u w) is symmetric with zero diagonal
  let h : Nat → Nat → Nat := fun u w => ind (u != w && G u w)
  have split : ∀ u, u < N → S N (fun w => h u w) =
      S N (fun w => if w < u then h u w else 0) + S N (fun w => if u < w then h u w else 0) := by
    intro u _
    rw [← S_add]
    apply S_congr; intro w _
    by_cases a : w < u
    · have : ¬ u < w := by omega
      simp [a, this]
    · by_cases b : u < w
      · simp [a, b]
      · have : u = w := by omega
        subst this; simp [h, ind]
  have eq : S N (fun u => S N (fun w => if u < w then h u w else 0)) =
      S N (fun u => S N (fun w => if w < u then h u w else 0)) := by
    rw [S_swap]
    apply S_congr; intro w hw
    apply S_congr; intro u hu
    by_cases a : u < w
    · simp only [a, ite_true]
      show ind (u != w && G u w) = ind (w != u && G w u)
      rw [hG u w hu hw, bne_comm (a := u) (b := w)]
    · simp [a]
  show S N (fun u => S N (fun w => h u w)) % 2 = 0
  rw [S_congr N _ _ split, S_add, eq]
  omega

end Facts

/-- If a graph on `N` vertices has no red `B_{a+1}` and no blue `B_{b+1}`, Goodman's count bounds
    each vertex; the hypotheses `hφ`, `heq`, `hodd` say that this forces every degree to be `d0`
    and that `N d0` is odd, which is impossible. -/
theorem upper_of (N a b d0 : Nat)
    (hφ : ∀ d, d < N → 3 * (d * (N - 1 - d)) + a * d + b * (N - 1 - d) ≤ (N - 1) * (N - 2))
    (heq : ∀ d, d < N → 3 * (d * (N - 1 - d)) + a * d + b * (N - 1 - d) = (N - 1) * (N - 2) →
      d = d0)
    (hodd : N * d0 % 2 = 1)
    (G : Nat → Nat → Bool) (hG : Symm N G) : HasRedBook N (a + 1) G ∨ HasBlueBook N (b + 1) G := by
  apply Classical.byContradiction
  intro hno
  have hr : ∀ u v, u < N → v < N → u ≠ v → G u v = true → redBook N G u v ≤ a := by
    intro u v hu hv huv h
    apply Classical.byContradiction; intro c
    exact hno (Or.inl ⟨u, v, hu, hv, huv, h, by omega⟩)
  have hb : ∀ u v, u < N → v < N → u ≠ v → G u v = false → blueBook N G u v ≤ b := by
    intro u v hu hv huv h
    apply Classical.byContradiction; intro c
    exact hno (Or.inr ⟨u, v, hu, hv, huv, h, by omega⟩)
  have hgood := goodman N G hG a b hr hb
  have hcod : ∀ w, w < N → codeg N G w = N - 1 - deg N G w := by
    intro w hw; have := deg_add_codeg N G w hw; omega
  have hlt : ∀ w, w < N → deg N G w < N := by
    intro w hw; have := deg_add_codeg N G w hw; omega
  let φ : Nat → Nat := fun w => 3 * (deg N G w * codeg N G w) + a * deg N G w + b * codeg N G w
  have hle : ∀ w, w < N → φ w ≤ (N - 1) * (N - 2) := by
    intro w hw
    show 3 * (deg N G w * codeg N G w) + a * deg N G w + b * codeg N G w ≤ _
    rw [hcod w hw]
    exact hφ _ (hlt w hw)
  have hall := S_eq_of_le N φ (fun _ => (N - 1) * (N - 2)) hle hgood
  have hd : ∀ w, w < N → deg N G w = d0 := by
    intro w hw
    have e := hall w hw
    have e' : 3 * (deg N G w * (N - 1 - deg N G w)) + a * deg N G w + b * (N - 1 - deg N G w) =
        (N - 1) * (N - 2) := by
      have : φ w = 3 * (deg N G w * (N - 1 - deg N G w)) + a * deg N G w
          + b * (N - 1 - deg N G w) := by
        show 3 * (deg N G w * codeg N G w) + a * deg N G w + b * codeg N G w = _
        rw [hcod w hw]
      rw [← this]; exact e
    exact heq _ (hlt w hw) e'
  have hsum : S N (fun w => deg N G w) = N * d0 := by
    rw [S_congr N _ (fun _ => d0) hd, S_const]
  have hev := deg_even N G hG
  rw [hsum] at hev
  omega

/-- Every graph on `N` vertices contains `B_m` or has a complement containing `B_n`. -/
def Arrows (N m n : Nat) : Prop := ∀ G : Nat → Nat → Bool, Symm N G → HasRedBook N m G ∨ HasBlueBook N n G

theorem S_le_len (f : Nat → Nat) (N M : Nat) (h : N ≤ M) : S N f ≤ S M f := by
  induction M with
  | zero => have : N = 0 := by omega
            subst this; exact Nat.le_refl _
  | succ M ih =>
    by_cases e : N = M + 1
    · subst e; exact Nat.le_refl _
    · rw [S_succ]; have := ih (by omega); omega

theorem countP_range_le (p : Nat → Bool) (N M : Nat) (h : N ≤ M) :
    (List.range N).countP p ≤ (List.range M).countP p := by
  rw [countP_range, countP_range]; exact S_le_len _ N M h

/-- If every graph on `N` vertices arrows, so does every graph on `M ≥ N` vertices. -/
theorem Arrows_mono (N M m n : Nat) (h : N ≤ M) (hA : Arrows N m n) : Arrows M m n := by
  intro G hG
  have hG' : Symm N G := fun u v hu hv => hG u v (by omega) (by omega)
  rcases hA G hG' with ⟨u, v, hu, hv, huv, he, hk⟩ | ⟨u, v, hu, hv, huv, he, hk⟩
  · exact Or.inl ⟨u, v, by omega, by omega, huv, he,
      Nat.le_trans hk (countP_range_le _ N M h)⟩
  · exact Or.inr ⟨u, v, by omega, by omega, huv, he,
      Nat.le_trans hk (countP_range_le _ N M h)⟩

/-- `R(B_m, B_n) = R`: every graph on `R` vertices arrows and no smaller number does. -/
def IsBookRamsey (m n R : Nat) : Prop := Arrows R m n ∧ ∀ N, N < R → ¬ Arrows N m n

theorem isBookRamsey_of (m n R : Nat) (hR : 0 < R) (hup : Arrows R m n)
    (hlow : ¬ Arrows (R - 1) m n) : IsBookRamsey m n R :=
  ⟨hup, fun N hN hA => hlow (Arrows_mono N (R - 1) m n (by omega) hA)⟩

end BookRamsey
