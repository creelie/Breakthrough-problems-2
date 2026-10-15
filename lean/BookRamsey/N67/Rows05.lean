import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 46 to 55, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row046 : rowOk 46 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row047 : rowOk 47 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row048 : rowOk 48 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row049 : rowOk 49 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row050 : rowOk 50 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row051 : rowOk 51 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row052 : rowOk 52 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row053 : rowOk 53 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row054 : rowOk 54 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row055 : rowOk 55 = true := by decide +kernel

theorem rows05 : (List.range' 46 10).all rowOk = true := by
  have e : List.range' 46 10 = [46, 47, 48, 49, 50, 51, 52, 53, 54, 55] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row046, row047, row048, row049, row050, row051, row052, row053, row054, row055, Bool.and_true]

end BookRamsey.N67
