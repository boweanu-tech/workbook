#!/bin/bash

export TEXINPUTS="../999_GPTbox//:${TEXINPUTS:-}"

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
