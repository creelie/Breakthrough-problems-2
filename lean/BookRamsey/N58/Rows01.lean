import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 8 to 14, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row008 : rowOk 8 = true := by decide +kernel
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

theorem rows01 : (List.range' 8 7).all rowOk = true := by
  have e : List.range' 8 7 = [8, 9, 10, 11, 12, 13, 14] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row008, row009, row010, row011, row012, row013, row014, Bool.and_true]

end BookRamsey.N58
