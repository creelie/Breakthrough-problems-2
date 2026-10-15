import BookRamsey.N58.Defs
namespace BookRamsey.N58

/-! Rows 173 to 228, each checked by the kernel in its own theorem. -/

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
set_option maxRecDepth 100000 in
theorem row200 : rowOk 200 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row201 : rowOk 201 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row202 : rowOk 202 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row203 : rowOk 203 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row204 : rowOk 204 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row205 : rowOk 205 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row206 : rowOk 206 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row207 : rowOk 207 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row208 : rowOk 208 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row209 : rowOk 209 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row210 : rowOk 210 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row211 : rowOk 211 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row212 : rowOk 212 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row213 : rowOk 213 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row214 : rowOk 214 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row215 : rowOk 215 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row216 : rowOk 216 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row217 : rowOk 217 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row218 : rowOk 218 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row219 : rowOk 219 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row220 : rowOk 220 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row221 : rowOk 221 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row222 : rowOk 222 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row223 : rowOk 223 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row224 : rowOk 224 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row225 : rowOk 225 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row226 : rowOk 226 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row227 : rowOk 227 = true := by decide +kernel
set_option maxRecDepth 100000 in
theorem row228 : rowOk 228 = true := by decide +kernel

theorem rows15 : (List.range' 173 56).all rowOk = true := by
  have e : List.range' 173 56 = [173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228] := by decide
  rw [e]
  simp only [List.all_cons, List.all_nil, row173, row174, row175, row176, row177, row178, row179, row180, row181, row182, row183, row184, row185, row186, row187, row188, row189, row190, row191, row192, row193, row194, row195, row196, row197, row198, row199, row200, row201, row202, row203, row204, row205, row206, row207, row208, row209, row210, row211, row212, row213, row214, row215, row216, row217, row218, row219, row220, row221, row222, row223, row224, row225, row226, row227, row228, Bool.and_true]

end BookRamsey.N58
