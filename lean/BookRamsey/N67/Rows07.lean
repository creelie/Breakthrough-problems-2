import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 67 to 77, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row067 : rowOk 67 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row068 : rowOk 68 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row069 : rowOk 69 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row070 : rowOk 70 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row071 : rowOk 71 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row072 : rowOk 72 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row073 : rowOk 73 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row074 : rowOk 74 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row075 : rowOk 75 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row076 : rowOk 76 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row077 : rowOk 77 = true := by decide +kernel

theorem rows07 : (List.range' 67 11).all rowOk = true := by
  have e : List.range' 67 11 = [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row067, row068, row069, row070, row071, row072, row073, row074, row075, row076, row077, Bool.and_true]

end BookRamsey.N67
