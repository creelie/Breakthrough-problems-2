/-
  R(B_{66}, B_{67}) = 267 and R(B_{57}, B_{58}) = 231, as statements about all graphs.
  The lower bounds are the explicit graphs of `N67` and `N58`; the upper bounds are Goodman's
  count in `Upper`, with the final arithmetic evaluated by the kernel.
-/
import BookRamsey.Upper
import BookRamsey.N67.Main
import BookRamsey.N58.Main

namespace BookRamsey

set_option maxRecDepth 100000 in
/-- Every graph on 267 vertices contains `B_66` or has a complement containing `B_67`. -/
theorem upper67 : Arrows 267 66 67 :=
  upper_of 267 65 66 133 (by decide +kernel) (by decide +kernel) (by decide)

/-- The graph of `N67` on 266 vertices has no `B_66`, and its complement has no `B_67`. -/
theorem lower67 : ¬ Arrows 266 66 67 := by
  intro hA
  rcases hA N67.adj (fun u v hu hv => N67.adj_symm u v hu hv) with
    ⟨u, v, hu, hv, huv, he, hk⟩ | ⟨u, v, hu, hv, huv, he, hk⟩
  · have e : redBook 266 N67.adj u v = N67.cn u v := by
      unfold redBook N67.cn
      rw [countP_range, countP_range]
      apply S_congr; intro r _
      unfold ind
      by_cases a : r = u
      · subst a; simp [N67.adj_irrefl]
      · by_cases b : r = v
        · subst b; simp [N67.adj_irrefl]
        · simp [a, b]
    have := N67.no_red_book u v hu hv he
    omega
  · have := N67.no_blue_book u v hu hv huv he
    have e : blueBook 266 N67.adj u v = N67.cnn u v := rfl
    omega

/-- `R(B_{66}, B_{67}) = 267`: every graph on 267 vertices contains `B_66` or has a complement
    containing `B_67`, and 267 is the least such number. -/
theorem book_ramsey_67 : IsBookRamsey 66 67 267 :=
  isBookRamsey_of 66 67 267 (by decide) upper67 lower67

set_option maxRecDepth 100000 in
/-- Every graph on 231 vertices contains `B_57` or has a complement containing `B_58`. -/
theorem upper58 : Arrows 231 57 58 :=
  upper_of 231 56 57 115 (by decide +kernel) (by decide +kernel) (by decide)

/-- The graph of `N58` on 230 vertices has no `B_57`, and its complement has no `B_58`. -/
theorem lower58 : ¬ Arrows 230 57 58 := by
  intro hA
  rcases hA N58.adj (fun u v hu hv => N58.adj_symm u v hu hv) with
    ⟨u, v, hu, hv, huv, he, hk⟩ | ⟨u, v, hu, hv, huv, he, hk⟩
  · have e : redBook 230 N58.adj u v = N58.cn u v := by
      unfold redBook N58.cn
      rw [countP_range, countP_range]
      apply S_congr; intro r _
      unfold ind
      by_cases a : r = u
      · subst a; simp [N58.adj_irrefl]
      · by_cases b : r = v
        · subst b; simp [N58.adj_irrefl]
        · simp [a, b]
    have := N58.no_red_book u v hu hv he
    omega
  · have := N58.no_blue_book u v hu hv huv he
    have e : blueBook 230 N58.adj u v = N58.cnn u v := rfl
    omega

/-- `R(B_{57}, B_{58}) = 231`: every graph on 231 vertices contains `B_57` or has a complement
    containing `B_58`, and 231 is the least such number. -/
theorem book_ramsey_58 : IsBookRamsey 57 58 231 :=
  isBookRamsey_of 57 58 231 (by decide) upper58 lower58

end BookRamsey
