#!/bin/bash
set -e

export TEXINPUTS="../999_GPTbox//:${TEXINPUTS:-}"

# figフォルダ内のSVGを、必要な場合だけPDFへ変換する
if command -v inkscape >/dev/null 2>&1; then
  find ./fig -name '*.svg' -print0 2>/dev/null | while IFS= read -r -d '' svg; do
    pdf="${svg%.svg}.pdf"

    if [ ! -f "$pdf" ] || [ "$svg" -nt "$pdf" ]; then
      echo "convert: $svg -> $pdf"
      inkscape "$svg" --export-type=pdf --export-filename="$pdf"
    fi
  done
else
  echo "Error: inkscape command not found."
  exit 1
fi

for file in `\find ./ -maxdepth 1 -name '*.tex'`; do
  cp $file "/home/keisuke/LOTUS/005_backup/tex/"$file
  platex $file
done

for file in `\find ./ -maxdepth 1 -name '*.dvi'`; do
  dvipdfmx $file
done

rm *.dvi
rm *.aux
rm *.log
