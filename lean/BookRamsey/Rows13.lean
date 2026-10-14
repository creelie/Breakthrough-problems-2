import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 151 to 171, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row151 : rowOk 151 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row152 : rowOk 152 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row153 : rowOk 153 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row154 : rowOk 154 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row155 : rowOk 155 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row156 : rowOk 156 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row157 : rowOk 157 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row158 : rowOk 158 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row159 : rowOk 159 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row160 : rowOk 160 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row161 : rowOk 161 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row162 : rowOk 162 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row163 : rowOk 163 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row164 : rowOk 164 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row165 : rowOk 165 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row166 : rowOk 166 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row167 : rowOk 167 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row168 : rowOk 168 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row169 : rowOk 169 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row170 : rowOk 170 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row171 : rowOk 171 = true := by decide +kernel

theorem rows13 : (List.range' 151 21).all rowOk = true := by
  have e : List.range' 151 21 = [151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row151, row152, row153, row154, row155, row156, row157, row158, row159, row160, row161, row162, row163, row164, row165, row166, row167, row168, row169, row170, row171, Bool.and_true]

end BookRamsey.N67
