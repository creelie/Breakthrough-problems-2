import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 9 to 17, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row009 : rowOk 9 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row010 : rowOk 10 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row011 : rowOk 11 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row012 : rowOk 12 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row013 : rowOk 13 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row014 : rowOk 14 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row015 : rowOk 15 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row016 : rowOk 16 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row017 : rowOk 17 = true := by decide +kernel

theorem rows01 : (List.range' 9 9).all rowOk = true := by
  have e : List.range' 9 9 = [9, 10, 11, 12, 13, 14, 15, 16, 17] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row009, row010, row011, row012, row013, row014, row015, row016, row017, Bool.and_true]

end BookRamsey.N67
