#!/usr/bin/env bash
# run_all.sh -- every check outside Lean, for both graphs; outputs go to build/.
#   C:      check_book.c rebuilds each graph from data/n58.json and data/n67.json and counts common
#           neighbours and common non-neighbours of all pairs of vertices (26,335 and 35,245), and the
#           slack of the reduced inequality at every d
#   Python: verify_book.py does the same count independently; check_paper58.py and check_paper.py
#           recompute every number printed in preprint58/main.tex and preprint/main.tex;
#           open_values.py recomputes the list of values n <= 100 that stay open (footnote 1 of
#           both papers); station_isomorphism.py checks that the n = 67 graph is the certificate of
#           Chung, Du and Wesley up to relabelling (by its published SHA-256 digest)
#   Search: orbit_search.py reruns the CP-SAT search for n = 67 with H = cube roots of unity (only if
#           OR-Tools is installed) and checks the set it finds
#   Lean:   gen_lean.py must reproduce the files in lean/ exactly
# Needs a C compiler and Python 3 (OR-Tools optional).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
B="$ROOT/build"
PY="$ROOT/verification/python"
mkdir -p "$B"
cd "$ROOT"

echo "== C: all pairs of both graphs"
cc -O2 -Wall -Wextra -Werror -o "$B/check_book" verification/c/check_book.c
for n in 58 67; do
  "$B/check_book" "data/n$n.json" | tee "$B/check_book_n$n.txt"
done

echo "== Python: all pairs of both graphs"
for n in 58 67; do
  python3 -I "$PY/verify_book.py" "data/n$n.json" | tee "$B/verify_book_n$n.txt"
done

echo "== Python: every number in the papers"
python3 -I "$PY/check_paper58.py" preprint58/main.tex | tee "$B/check_paper58.txt"
python3 -I "$PY/check_paper.py" preprint/main.tex | tee "$B/check_paper.txt"
python3 -I "$PY/open_values.py" | tee "$B/open_values.txt"
python3 -I "$PY/station_isomorphism.py" | tee "$B/station_isomorphism.txt"

if python3 -c "import ortools" 2>/dev/null; then
  echo "== Search: CP-SAT over unions of orbits of the cube roots of unity (n = 67)"
  python3 -I search/orbit_search.py 67 --workers 1 --seed 1 --out "$B/search_n67.json" | tee "$B/search_n67.txt"
else
  echo "== Search: skipped (OR-Tools not installed)"
fi

echo "== the Lean files are the generator's output"
rm -rf "$B/lean-gen" && mkdir -p "$B/lean-gen"
python3 -I scripts/gen_lean.py "$B/lean-gen" > /dev/null
# Sums.lean and Upper.lean (Goodman's count) are written by hand; every other file is generated
gen_files() { find BookRamsey -name '*.lean' ! -path BookRamsey/Sums.lean ! -path BookRamsey/Upper.lean | sort; }
for f in BookRamsey.lean Check.lean lakefile.toml lean-toolchain $(cd lean && gen_files); do
  cmp "lean/$f" "$B/lean-gen/$f"
done
diff <(cd "$B/lean-gen" && gen_files) <(cd lean && gen_files)
test -f lean/BookRamsey/Sums.lean && test -f lean/BookRamsey/Upper.lean
echo "all checks passed"
