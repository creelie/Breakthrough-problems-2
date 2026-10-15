import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 15 to 22, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row015 : rowOk 15 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row016 : rowOk 16 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row017 : rowOk 17 = true := by decide +kernel
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

theorem rows02 : (List.range' 15 8).all rowOk = true := by
  have e : List.range' 15 8 = [15, 16, 17, 18, 19, 20, 21, 22] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row015, row016, row017, row018, row019, row020, row021, row022, Bool.and_true]

end BookRamsey.N58
