import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 103 to 117, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row103 : rowOk 103 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row104 : rowOk 104 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row105 : rowOk 105 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row106 : rowOk 106 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row107 : rowOk 107 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row108 : rowOk 108 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row109 : rowOk 109 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row110 : rowOk 110 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row111 : rowOk 111 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row112 : rowOk 112 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row113 : rowOk 113 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row114 : rowOk 114 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row115 : rowOk 115 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row116 : rowOk 116 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row117 : rowOk 117 = true := by decide +kernel

theorem rows10 : (List.range' 103 15).all rowOk = true := by
  have e : List.range' 103 15 = [103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row103, row104, row105, row106, row107, row108, row109, row110, row111, row112, row113, row114, row115, row116, row117, Bool.and_true]

end BookRamsey.N67
