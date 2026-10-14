import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 118 to 132, each checked by the kernel in its own theorem. -/

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
set_option maxRecDepth 100000 in
theorem row131 : rowOk 131 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row132 : rowOk 132 = true := by decide +kernel

theorem rows11 : (List.range' 118 15).all rowOk = true := by
  have e : List.range' 118 15 = [118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row118, row119, row120, row121, row122, row123, row124, row125, row126, row127, row128, row129, row130, row131, row132, Bool.and_true]

end BookRamsey.N67
