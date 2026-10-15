import BookRamsey.N67.Rows00
import BookRamsey.N67.Rows01
import BookRamsey.N67.Rows02
import BookRamsey.N67.Rows03
import BookRamsey.N67.Rows04
import BookRamsey.N67.Rows05
import BookRamsey.N67.Rows06
import BookRamsey.N67.Rows07
import BookRamsey.N67.Rows08
import BookRamsey.N67.Rows09
import BookRamsey.N67.Rows10
import BookRamsey.N67.Rows11
import BookRamsey.N67.Rows12
import BookRamsey.N67.Rows13
import BookRamsey.N67.Rows14
import BookRamsey.N67.Rows15
import BookRamsey.N67.Rows16
namespace BookRamsey.N67

theorem rowOk_all (p : Nat) (hp : p < 266) : rowOk p = true := by
  have h00 := (List.all_eq_true.mp rows00) p
  have h01 := (List.all_eq_true.mp rows01) p
  have h02 := (List.all_eq_true.mp rows02) p
  have h03 := (List.all_eq_true.mp rows03) p
  have h04 := (List.all_eq_true.mp rows04) p
  have h05 := (List.all_eq_true.mp rows05) p
  have h06 := (List.all_eq_true.mp rows06) p
  have h07 := (List.all_eq_true.mp rows07) p
  have h08 := (List.all_eq_true.mp rows08) p
  have h09 := (List.all_eq_true.mp rows09) p
  have h10 := (List.all_eq_true.mp rows10) p
  have h11 := (List.all_eq_true.mp rows11) p
  have h12 := (List.all_eq_true.mp rows12) p
  have h13 := (List.all_eq_true.mp rows13) p
  have h14 := (List.all_eq_true.mp rows14) p
  have h15 := (List.all_eq_true.mp rows15) p
  have h16 := (List.all_eq_true.mp rows16) p
  by_cases c00 : p < 9
  · exact h00 (List.mem_range'_1.mpr (by omega))
  by_cases c01 : p < 18
  · exact h01 (List.mem_range'_1.mpr (by omega))
  by_cases c02 : p < 27
  · exact h02 (List.mem_range'_1.mpr (by omega))
  by_cases c03 : p < 36
  · exact h03 (List.mem_range'_1.mpr (by omega))
  by_cases c04 : p < 46
  · exact h04 (List.mem_range'_1.mpr (by omega))
  by_cases c05 : p < 56
  · exact h05 (List.mem_range'_1.mpr (by omega))
  by_cases c06 : p < 67
  · exact h06 (List.mem_range'_1.mpr (by omega))
  by_cases c07 : p < 78
  · exact h07 (List.mem_range'_1.mpr (by omega))
  by_cases c08 : p < 90
  · exact h08 (List.mem_range'_1.mpr (by omega))
  by_cases c09 : p < 103
  · exact h09 (List.mem_range'_1.mpr (by omega))
  by_cases c10 : p < 118
  · exact h10 (List.mem_range'_1.mpr (by omega))
  by_cases c11 : p < 133
  · exact h11 (List.mem_range'_1.mpr (by omega))
  by_cases c12 : p < 151
  · exact h12 (List.mem_range'_1.mpr (by omega))
  by_cases c13 : p < 172
  · exact h13 (List.mem_range'_1.mpr (by omega))
  by_cases c14 : p < 200
  · exact h14 (List.mem_range'_1.mpr (by omega))
  by_cases c15 : p < 265
  · exact h15 (List.mem_range'_1.mpr (by omega))
  · exact h16 (List.mem_range'_1.mpr (by omega))

theorem adj_symm (p q : Nat) (hp : p < 266) (hq : q < 266) : adj p q = adj q p := by
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

theorem okPair_lt (p q : Nat) (hpq : p < q) (hq : q < 266) : okPair p q = true := by
  have h := rowOk_all p (by omega)
  simp only [rowOk, Bool.and_eq_true] at h
  exact List.all_eq_true.mp h.1 q (List.mem_range'_1.mpr (by omega))

/-- No edge lies in 66 triangles: the graph has no book B_66. -/
theorem no_red_book (p q : Nat) (hp : p < 266) (hq : q < 266) (h : adj p q = true) :
    cn p q ≤ 65 := by
  rcases Nat.lt_trichotomy p q with hlt | heq | hgt
  · have := okPair_lt p q hlt hq
    simp only [okPair, h, ite_true, decide_eq_true_eq] at this
    exact this
  · subst heq; simp [adj_irrefl] at h
  · have h' : adj q p = true := by rw [adj_symm q p hq hp]; exact h
    have := okPair_lt q p hgt hp
    simp only [okPair, h', ite_true, decide_eq_true_eq] at this
    rw [cn_symm]; exact this

/-- No non-edge has 67 common non-neighbours: the complement has no book B_67. -/
theorem no_blue_book (p q : Nat) (hp : p < 266) (hq : q < 266) (hne : p ≠ q)
    (h : adj p q = false) : cnn p q ≤ 66 := by
  rcases Nat.lt_trichotomy p q with hlt | heq | hgt
  · have := okPair_lt p q hlt hq
    simp only [okPair, h, Bool.false_eq_true, ite_false, decide_eq_true_eq] at this
    exact this
  · exact absurd heq hne
  · have h' : adj q p = false := by rw [adj_symm q p hq hp]; exact h
    have := okPair_lt q p hgt hp
    simp only [okPair, h', Bool.false_eq_true, ite_false, decide_eq_true_eq] at this
    rw [cnn_symm]; exact this

/-- The graph on the vertices 0, ..., 265 witnesses R(B_66, B_67) > 266: it is a simple graph,
    every edge lies in at most 65 triangles, and every pair of distinct non-adjacent vertices has
    at most 66 common non-neighbours. -/
theorem lower_bound :
    (∀ p q, p < 266 → q < 266 → adj p q = adj q p) ∧ (∀ p, adj p p = false) ∧
    (∀ p q, p < 266 → q < 266 → adj p q = true → cn p q ≤ 65) ∧
    (∀ p q, p < 266 → q < 266 → p ≠ q → adj p q = false → cnn p q ≤ 66) :=
  ⟨adj_symm, adj_irrefl, no_red_book, no_blue_book⟩

end BookRamsey.N67
