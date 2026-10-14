import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 27 to 35, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row027 : rowOk 27 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row028 : rowOk 28 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row029 : rowOk 29 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row030 : rowOk 30 = true := by decide +kernel
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

theorem rows03 : (List.range' 27 9).all rowOk = true := by
  have e : List.range' 27 9 = [27, 28, 29, 30, 31, 32, 33, 34, 35] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row027, row028, row029, row030, row031, row032, row033, row034, row035, Bool.and_true]

end BookRamsey.N67
