import BookRamsey.Defs
namespace BookRamsey.N67

/-! Rows 18 to 26, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row018 : rowOk 18 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row019 : rowOk 19 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row020 : rowOk 20 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row021 : rowOk 21 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row022 : rowOk 22 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row023 : rowOk 23 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row024 : rowOk 24 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row025 : rowOk 25 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row026 : rowOk 26 = true := by decide +kernel

theorem rows02 : (List.range' 18 9).all rowOk = true := by
  have e : List.range' 18 9 = [18, 19, 20, 21, 22, 23, 24, 25, 26] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row018, row019, row020, row021, row022, row023, row024, row025, row026, Bool.and_true]

end BookRamsey.N67
