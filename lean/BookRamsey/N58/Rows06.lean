import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 49 to 57, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row049 : rowOk 49 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row050 : rowOk 50 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row051 : rowOk 51 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row052 : rowOk 52 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row053 : rowOk 53 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row054 : rowOk 54 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row055 : rowOk 55 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row056 : rowOk 56 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row057 : rowOk 57 = true := by decide +kernel

theorem rows06 : (List.range' 49 9).all rowOk = true := by
  have e : List.range' 49 9 = [49, 50, 51, 52, 53, 54, 55, 56, 57] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row049, row050, row051, row052, row053, row054, row055, row056, row057, Bool.and_true]

end BookRamsey.N58
