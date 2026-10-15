import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 36 to 45, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row036 : rowOk 36 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row037 : rowOk 37 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row038 : rowOk 38 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row039 : rowOk 39 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row040 : rowOk 40 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row041 : rowOk 41 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row042 : rowOk 42 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row043 : rowOk 43 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row044 : rowOk 44 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row045 : rowOk 45 = true := by decide +kernel

theorem rows04 : (List.range' 36 10).all rowOk = true := by
  have e : List.range' 36 10 = [36, 37, 38, 39, 40, 41, 42, 43, 44, 45] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row036, row037, row038, row039, row040, row041, row042, row043, row044, row045, Bool.and_true]

end BookRamsey.N67
