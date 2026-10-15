import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 40 to 48, each checked by the kernel in its own theorem. -/

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
set_option maxRecDepth 100000 in
theorem row046 : rowOk 46 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row047 : rowOk 47 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row048 : rowOk 48 = true := by decide +kernel

theorem rows05 : (List.range' 40 9).all rowOk = true := by
  have e : List.range' 40 9 = [40, 41, 42, 43, 44, 45, 46, 47, 48] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row040, row041, row042, row043, row044, row045, row046, row047, row048, Bool.and_true]

end BookRamsey.N58
