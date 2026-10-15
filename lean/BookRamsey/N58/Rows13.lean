import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 131 to 148, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row131 : rowOk 131 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row132 : rowOk 132 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row133 : rowOk 133 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row134 : rowOk 134 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row135 : rowOk 135 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row136 : rowOk 136 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row137 : rowOk 137 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row138 : rowOk 138 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row139 : rowOk 139 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row140 : rowOk 140 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row141 : rowOk 141 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row142 : rowOk 142 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row143 : rowOk 143 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row144 : rowOk 144 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row145 : rowOk 145 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row146 : rowOk 146 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row147 : rowOk 147 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row148 : rowOk 148 = true := by decide +kernel

theorem rows13 : (List.range' 131 18).all rowOk = true := by
  have e : List.range' 131 18 = [131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row131, row132, row133, row134, row135, row136, row137, row138, row139, row140, row141, row142, row143, row144, row145, row146, row147, row148, Bool.and_true]

end BookRamsey.N58
