#!/usr/bin/env bash
# build_paper.sh -- build both papers and their submission files into dist/.
#
#   preprint58/  R(B_57, B_58) = 231   ->  dist/book-ramsey-58_final2{.pdf,-tex.zip,-arxiv.tar.gz}
#   preprint/    R(B_66, B_67) = 267   ->  dist/book-ramsey-67_final2{.pdf,-tex.zip,-arxiv.tar.gz}
#
#   NAME.pdf              the compiled paper
#   NAME-tex.zip          main.tex with the figures as PNG (and their TikZ sources)
#   NAME-arxiv.tar.gz     main.tex and the PNG figures, ready for arXiv
#
# Needs Python 3, pdflatex with amsart, tikz (shadings), booktabs, array, geometry and hyperref;
# pdftoppm (poppler) for the PNG figures; zip and tar.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/dist"
FIGS="torus slack"
mkdir -p "$DIST"

latex() { pdflatex -interaction=nonstopmode -halt-on-error "$@" > /dev/null; }

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

echo "== figures"
python3 "$ROOT/scripts/gen_figures.py"

build() {
  local PAPER="$ROOT/$1" NAME="$2"
  echo "== $1: figures as PNG"
  cd "$PAPER/figures"
  for f in $FIGS; do
    latex "$f.tex"
    pdftoppm -png -r 200 -singlefile "$f.pdf" "$f"
    rm -f "$f.aux" "$f.log" "$f.pdf"
  done

  echo "== $1: paper"
  cd "$PAPER"
  latex main.tex
  latex main.tex
  latex main.tex
  if grep -q "Overfull\|Underfull\|undefined\|Rerun to get" main.log; then
    grep "Overfull\|Underfull\|undefined\|Rerun to get" main.log
    echo "build_paper.sh: fix the warnings above in $1" >&2
    exit 1
  fi
  cp main.pdf "$DIST/$NAME.pdf"

  echo "== $1: tex.zip (figures as PNG)"
  mkdir -p "$STAGE/$NAME/figures"
  cp main.tex "$STAGE/$NAME/"
  for f in $FIGS; do cp "figures/$f.png" "figures/$f.tex" "$STAGE/$NAME/figures/"; done
  ( cd "$STAGE/$NAME" && latex main.tex && latex main.tex && rm -f main.aux main.log main.out main.pdf )
  rm -f "$DIST/$NAME-tex.zip"
  ( cd "$STAGE" && zip -qrX "$DIST/$NAME-tex.zip" "$NAME" )

  echo "== $1: arXiv tarball"
  mkdir -p "$STAGE/arxiv-$NAME/figures"
  cp main.tex "$STAGE/arxiv-$NAME/"
  for f in $FIGS; do cp "figures/$f.png" "$STAGE/arxiv-$NAME/figures/"; done
  ( cd "$STAGE/arxiv-$NAME" && latex main.tex && latex main.tex && rm -f main.aux main.log main.out main.pdf )
  tar -czf "$DIST/$NAME-arxiv.tar.gz" -C "$STAGE/arxiv-$NAME" .

  rm -f main.aux main.log main.out main.pdf
}

build preprint58 book-ramsey-58_final2
build preprint book-ramsey-67_final2
ls -l "$DIST"
