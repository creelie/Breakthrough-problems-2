import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 56 to 66, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row056 : rowOk 56 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row057 : rowOk 57 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row058 : rowOk 58 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row059 : rowOk 59 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row060 : rowOk 60 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row061 : rowOk 61 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row062 : rowOk 62 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row063 : rowOk 63 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row064 : rowOk 64 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row065 : rowOk 65 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row066 : rowOk 66 = true := by decide +kernel

theorem rows06 : (List.range' 56 11).all rowOk = true := by
  have e : List.range' 56 11 = [56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row056, row057, row058, row059, row060, row061, row062, row063, row064, row065, row066, Bool.and_true]

end BookRamsey.N67
