/-
  Finite sums over {0, ..., N-1}, with the few facts needed for double counting:
  linearity, monotonicity, exchange of two sums and the count of a list as a sum.
-/
namespace BookRamsey

/-- `S N f = f 0 + f 1 + ... + f (N-1)`. -/
def S : Nat → (Nat → Nat) → Nat
  | 0, _ => 0
  | n + 1, f => S n f + f n

/-- `ind b` is `1` if `b` holds and `0` otherwise. -/
def ind (b : Bool) : Nat := if b then 1 else 0

theorem S_zero (f : Nat → Nat) : S 0 f = 0 := rfl

theorem S_succ (n : Nat) (f : Nat → Nat) : S (n + 1) f = S n f + f n := rfl

theorem S_congr (n : Nat) (f g : Nat → Nat) (h : ∀ x, x < n → f x = g x) : S n f = S n g := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [S_succ, S_succ, ih (fun x hx => h x (by omega)), h n (by omega)]

theorem S_add (n : Nat) (f g : Nat → Nat) : S n (fun x => f x + g x) = S n f + S n g := by
  induction n with
  | zero => rfl
  | succ n ih => rw [S_succ, S_succ, S_succ, ih]; omega

theorem S_mul_left (n c : Nat) (f : Nat → Nat) : S n (fun x => c * f x) = c * S n f := by
  induction n with
  | zero => simp [S_zero]
  | succ n ih => rw [S_succ, S_succ, ih, Nat.mul_add]

theorem S_mul_right (n c : Nat) (f : Nat → Nat) : S n (fun x => f x * c) = S n f * c := by
  induction n with
  | zero => simp [S_zero]
  | succ n ih => rw [S_succ, S_succ, ih, Nat.add_mul]

theorem S_const (n c : Nat) : S n (fun _ => c) = n * c := by
  induction n with
  | zero => simp [S_zero]
  | succ n ih => rw [S_succ, ih, Nat.succ_mul]

theorem S_le (n : Nat) (f g : Nat → Nat) (h : ∀ x, x < n → f x ≤ g x) : S n f ≤ S n g := by
  induction n with
  | zero => exact Nat.le_refl _
  | succ n ih =>
    rw [S_succ, S_succ]
    exact Nat.add_le_add (ih (fun x hx => h x (by omega))) (h n (by omega))

/-- If `f ≤ g` termwise and the sums agree the other way, then `f = g` termwise. -/
theorem S_eq_of_le (n : Nat) (f g : Nat → Nat) (h : ∀ x, x < n → f x ≤ g x)
    (hs : S n g ≤ S n f) : ∀ x, x < n → f x = g x := by
  induction n with
  | zero => intro x hx; omega
  | succ n ih =>
    rw [S_succ, S_succ] at hs
    have h1 : S n f ≤ S n g := S_le n f g (fun x hx => h x (by omega))
    have h2 : f n ≤ g n := h n (by omega)
    have e1 : S n g ≤ S n f := by omega
    have e2 : f n = g n := by omega
    intro x hx
    by_cases hxn : x = n
    · subst hxn; exact e2
    · exact ih (fun y hy => h y (by omega)) e1 x (by omega)

/-- Exchange of two finite sums. -/
theorem S_swap (n m : Nat) (f : Nat → Nat → Nat) :
    S n (fun x => S m (fun y => f x y)) = S m (fun y => S n (fun x => f x y)) := by
  induction n with
  | zero =>
    rw [S_zero]
    have : ∀ y, y < m → S 0 (fun x => f x y) = 0 := fun _ _ => rfl
    rw [S_congr m _ (fun _ => 0) this, S_const, Nat.mul_zero]
  | succ n ih =>
    rw [S_succ, ih]
    have : ∀ y, y < m → S (n + 1) (fun x => f x y) = S n (fun x => f x y) + f n y :=
      fun _ _ => rfl
    rw [S_congr m _ _ this, S_add]

/-- A sum of `c` over the `x < n` with `p x`. -/
theorem S_ind_mul (n c : Nat) (p : Nat → Bool) :
    S n (fun x => if p x then c else 0) = c * S n (fun x => ind (p x)) := by
  rw [← S_mul_left]
  apply S_congr
  intro x _
  unfold ind
  cases p x <;> simp

/-- The count of a list `range n` is the sum of the indicators. -/
theorem countP_range (n : Nat) (p : Nat → Bool) :
    (List.range n).countP p = S n (fun x => ind (p x)) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [List.range_succ, List.countP_append, ih, S_succ]
    unfold ind
    cases h : p n <;> simp [h]

theorem ite_lt_succ (u k : Nat) :
    (if u < k + 1 then 1 else 0) = (if u < k then 1 else 0) + (if k = u then 1 else 0) := by
  by_cases a : u < k
  · have : k ≠ u := by omega
    simp [a, this]; omega
  · by_cases b : k = u
    · subst b; simp
    · have : ¬ u < k + 1 := by omega
      simp [a, b, this]

/-- Exactly two of `0, ..., n-1` are `u` or `v` when `u ≠ v` both lie below `n`. -/
theorem S_two (n u v : Nat) (hu : u < n) (hv : v < n) (huv : u ≠ v) :
    S n (fun w => ind (w != u && w != v)) = n - 2 := by
  have key : ∀ k, S k (fun w => ind (w != u && w != v)) + (if u < k then 1 else 0)
      + (if v < k then 1 else 0) = k := by
    intro k
    induction k with
    | zero => simp [S_zero]
    | succ k ih =>
      rw [S_succ, ite_lt_succ u k, ite_lt_succ v k]
      have hi : ind (k != u && k != v) + (if k = u then 1 else 0) + (if k = v then 1 else 0) = 1 := by
        unfold ind
        by_cases a : k = u
        · have b : k ≠ v := by omega
          simp only [a] <;> simp <;> omega
        · by_cases b : k = v
          · simp only [b] <;> simp <;> omega
          · simp [a, b]
      omega
  have h1 := key n
  simp [hu, hv] at h1
  omega

end BookRamsey
