import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 229 to 229, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row229 : rowOk 229 = true := by decide +kernel

theorem rows16 : (List.range' 229 1).all rowOk = true := by
  have e : List.range' 229 1 = [229] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row229, Bool.and_true]

end BookRamsey.N58
