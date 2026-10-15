import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 115 to 130, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row115 : rowOk 115 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row116 : rowOk 116 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row117 : rowOk 117 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row118 : rowOk 118 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row119 : rowOk 119 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row120 : rowOk 120 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row121 : rowOk 121 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row122 : rowOk 122 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row123 : rowOk 123 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row124 : rowOk 124 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row125 : rowOk 125 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row126 : rowOk 126 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row127 : rowOk 127 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row128 : rowOk 128 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row129 : rowOk 129 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row130 : rowOk 130 = true := by decide +kernel

theorem rows12 : (List.range' 115 16).all rowOk = true := by
  have e : List.range' 115 16 = [115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row115, row116, row117, row118, row119, row120, row121, row122, row123, row124, row125, row126, row127, row128, row129, row130, Bool.and_true]

end BookRamsey.N58
