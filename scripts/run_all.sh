#!/usr/bin/env bash
# run_all.sh -- every check outside Lean; outputs go to build/.
#   C:      check_book.c rebuilds the graph from data/n67.json and counts common neighbours and common
#           non-neighbours of all 35,245 pairs of vertices, and the slack of (*) at every d
#   Python: verify_n67.py does the same count independently; check_paper.py recomputes every number
#           printed in preprint/main.tex (H, the orbits, A, B, Table 1, footnotes, captions, remarks);
#           open_values.py recomputes the list of values n <= 100 that stay open;
#           station_isomorphism.py checks that the graph is the n = 67 certificate of Chung, Du and
#           Wesley up to relabelling (by its published SHA-256 digest)
#   Search: orbit_search.py reruns the CP-SAT search with H = cube roots of unity (only if OR-Tools
#           is installed) and checks the set it finds
#   Lean:   gen_lean.py must reproduce the files in lean/ exactly
# Needs a C compiler and Python 3 (OR-Tools optional).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
B="$ROOT/build"
PY="$ROOT/verification/python"
mkdir -p "$B"
cd "$ROOT"

echo "== C: all pairs of the graph"
cc -O2 -Wall -Wextra -Werror -o "$B/check_book" verification/c/check_book.c
"$B/check_book" data/n67.json | tee "$B/check_book.txt"

echo "== Python: all pairs of the graph"
python3 -I "$PY/verify_n67.py" data/n67.json | tee "$B/verify_n67.txt"

echo "== Python: every number in the paper"
python3 -I "$PY/check_paper.py" preprint/main.tex | tee "$B/check_paper.txt"
python3 -I "$PY/open_values.py" | tee "$B/open_values.txt"
python3 -I "$PY/station_isomorphism.py" | tee "$B/station_isomorphism.txt"

if python3 -c "import ortools" 2>/dev/null; then
  echo "== Search: CP-SAT over unions of orbits of the cube roots of unity"
  python3 -I search/orbit_search.py 67 --workers 1 --seed 1 --out "$B/search_n67.json" | tee "$B/search_n67.txt"
else
  echo "== Search: skipped (OR-Tools not installed)"
fi

echo "== the Lean files are the generator's output"
rm -rf "$B/lean-gen" && mkdir -p "$B/lean-gen"
python3 -I scripts/gen_lean.py data/n67.json "$B/lean-gen" > /dev/null
for f in BookRamsey.lean Check.lean lakefile.toml lean-toolchain $(cd lean && ls BookRamsey/*.lean); do
  cmp "lean/$f" "$B/lean-gen/$f"
done
( cd "$B/lean-gen" && ls BookRamsey ) | diff - <(ls lean/BookRamsey)
echo "all checks passed"
