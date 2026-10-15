import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 102 to 114, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row102 : rowOk 102 = true := by decide +kernel
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

theorem rows11 : (List.range' 102 13).all rowOk = true := by
  have e : List.range' 102 13 = [102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row102, row103, row104, row105, row106, row107, row108, row109, row110, row111, row112, row113, row114, Bool.and_true]

end BookRamsey.N58
