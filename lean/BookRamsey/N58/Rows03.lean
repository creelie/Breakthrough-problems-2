import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 23 to 30, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row023 : rowOk 23 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row024 : rowOk 24 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row025 : rowOk 25 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row026 : rowOk 26 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row027 : rowOk 27 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row028 : rowOk 28 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row029 : rowOk 29 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row030 : rowOk 30 = true := by decide +kernel

theorem rows03 : (List.range' 23 8).all rowOk = true := by
  have e : List.range' 23 8 = [23, 24, 25, 26, 27, 28, 29, 30] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row023, row024, row025, row026, row027, row028, row029, row030, Bool.and_true]

end BookRamsey.N58
