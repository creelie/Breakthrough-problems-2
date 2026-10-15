import BookRamsey.N67.Defs
namespace BookRamsey.N67

/-! Rows 172 to 199, each checked by the kernel in its own theorem. -/

set_option maxRecDepth 100000 in
theorem row172 : rowOk 172 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row173 : rowOk 173 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row174 : rowOk 174 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row175 : rowOk 175 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row176 : rowOk 176 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row177 : rowOk 177 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row178 : rowOk 178 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row179 : rowOk 179 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row180 : rowOk 180 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row181 : rowOk 181 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row182 : rowOk 182 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row183 : rowOk 183 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row184 : rowOk 184 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row185 : rowOk 185 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row186 : rowOk 186 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row187 : rowOk 187 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row188 : rowOk 188 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row189 : rowOk 189 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row190 : rowOk 190 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row191 : rowOk 191 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row192 : rowOk 192 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row193 : rowOk 193 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row194 : rowOk 194 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row195 : rowOk 195 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row196 : rowOk 196 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row197 : rowOk 197 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row198 : rowOk 198 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row199 : rowOk 199 = true := by decide +kernel

theorem rows14 : (List.range' 172 28).all rowOk = true := by
  have e : List.range' 172 28 = [172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row172, row173, row174, row175, row176, row177, row178, row179, row180, row181, row182, row183, row184, row185, row186, row187, row188, row189, row190, row191, row192, row193, row194, row195, row196, row197, row198, row199, Bool.and_true]

end BookRamsey.N67
