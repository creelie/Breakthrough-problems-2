import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 90 to 102, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row090 : rowOk 90 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row091 : rowOk 91 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row092 : rowOk 92 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row093 : rowOk 93 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row094 : rowOk 94 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row095 : rowOk 95 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row096 : rowOk 96 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row097 : rowOk 97 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row098 : rowOk 98 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row099 : rowOk 99 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row100 : rowOk 100 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row101 : rowOk 101 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row102 : rowOk 102 = true := by decide +kernel

theorem rows09 : (List.range' 90 13).all rowOk = true := by
  have e : List.range' 90 13 = [90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row090, row091, row092, row093, row094, row095, row096, row097, row098, row099, row100, row101, row102, Bool.and_true]

end BookRamsey.N67
