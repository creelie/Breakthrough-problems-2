import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 31 to 39, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row031 : rowOk 31 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row032 : rowOk 32 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row033 : rowOk 33 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row034 : rowOk 34 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row035 : rowOk 35 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row036 : rowOk 36 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row037 : rowOk 37 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row038 : rowOk 38 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row039 : rowOk 39 = true := by decide +kernel

theorem rows04 : (List.range' 31 9).all rowOk = true := by
  have e : List.range' 31 9 = [31, 32, 33, 34, 35, 36, 37, 38, 39] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row031, row032, row033, row034, row035, row036, row037, row038, row039, Bool.and_true]

end BookRamsey.N58
