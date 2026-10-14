import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 0 to 8, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row000 : rowOk 0 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row001 : rowOk 1 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row002 : rowOk 2 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row003 : rowOk 3 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row004 : rowOk 4 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row005 : rowOk 5 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row006 : rowOk 6 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row007 : rowOk 7 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row008 : rowOk 8 = true := by decide +kernel

theorem rows00 : (List.range' 0 9).all rowOk = true := by
  have e : List.range' 0 9 = [0, 1, 2, 3, 4, 5, 6, 7, 8] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row000, row001, row002, row003, row004, row005, row006, row007, row008, Bool.and_true]

end BookRamsey.N67
