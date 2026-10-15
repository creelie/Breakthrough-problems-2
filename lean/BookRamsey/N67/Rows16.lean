import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 265 to 265, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row265 : rowOk 265 = true := by decide +kernel

theorem rows16 : (List.range' 265 1).all rowOk = true := by
  have e : List.range' 265 1 = [265] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row265, Bool.and_true]

end BookRamsey.N67
