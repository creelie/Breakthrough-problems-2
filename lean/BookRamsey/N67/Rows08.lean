import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 78 to 89, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row078 : rowOk 78 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row079 : rowOk 79 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row080 : rowOk 80 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row081 : rowOk 81 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row082 : rowOk 82 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row083 : rowOk 83 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row084 : rowOk 84 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row085 : rowOk 85 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row086 : rowOk 86 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row087 : rowOk 87 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row088 : rowOk 88 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row089 : rowOk 89 = true := by decide +kernel

theorem rows08 : (List.range' 78 12).all rowOk = true := by
  have e : List.range' 78 12 = [78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row078, row079, row080, row081, row082, row083, row084, row085, row086, row087, row088, row089, Bool.and_true]

end BookRamsey.N67
