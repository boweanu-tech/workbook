#!/bin/bash
set -e

ORIG_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

export TEXINPUTS="$SCRIPT_DIR//:${TEXINPUTS:-}"

convert_svg_in_dir() {
  local target_dir="$1"

  if [ ! -d "$target_dir" ]; then
    return 0
  fi

  if [ ! -d "$target_dir/fig" ]; then
    return 0
  fi

  (
    cd "$target_dir"

    find ./fig -name '*.svg' -print0 2>/dev/null | while IFS= read -r -d '' svg; do
      pdf="${svg%.svg}.pdf"

      if [ ! -f "$pdf" ] || [ "$svg" -nt "$pdf" ]; then
        echo "convert: $(pwd)/$svg -> $(pwd)/$pdf"
        inkscape "$svg" --export-type=pdf --export-filename="$pdf"
      fi
    done
  )
}

if ! command -v inkscape >/dev/null 2>&1; then
  echo "Error: inkscape command not found."
  exit 1
fi

# 実行ディレクトリ自身に fig/ がある場合に備えて変換する。
convert_svg_in_dir "$ORIG_DIR"

# PDF出力用texの \Use{../path/to/test}{01} から、参照先フォルダを拾って変換する。
tmp_dirs="$(mktemp)"
trap 'rm -f "$tmp_dirs"' EXIT

find ./ -maxdepth 1 -name '*.tex' -print0 | while IFS= read -r -d '' tex; do
  sed -n 's/.*\\Use{\([^}]*\)}{[^}]*}.*/\1/p' "$tex" | while IFS= read -r use_base; do
    dirname "$use_base"
  done
done >> "$tmp_dirs"

if [ -s "$tmp_dirs" ]; then
  sort -u "$tmp_dirs" | while IFS= read -r target_dir; do
    convert_svg_in_dir "$ORIG_DIR/$target_dir"
  done
fi

cd "$ORIG_DIR"

for file in $(find ./ -maxdepth 1 -name '*.tex'); do
  cp "$file" "/home/keisuke/LOTUS/005_backup/tex/$(basename "$file")"
  platex "$file"
done

for file in $(find ./ -maxdepth 1 -name '*.dvi'); do
  dvipdfmx "$file"
done

rm -f *.dvi
rm -f *.aux
rm -f *.log
