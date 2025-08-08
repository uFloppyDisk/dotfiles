#!/usr/bin/env bash

LARGE="FLOPPYOS"
EXTRA="FloppyOS version 37.1111_1101"

RANDOM_SEED=$$$(date +%s)
FONT_POOL=(
  "3-d"
  "alligator"
  "alligator2"
  "banner3-D"
  "banner4"
  "basic"
  "block"
  "catwalk"
  "colossal"
  "cosmic"
  "cosmike"
  "lean"
  "marquee"
  "nipples"
  "o8"
  "peaks"
  "roman"
  "slant"
  "speed"
)
FONT=${FONT_POOL[$RANDOM_SEED % ${#FONT_POOL[@]}]}

FIG="$(figlet -w 240 -f ${FONT} ${LARGE} | sed -nE 's/^\s*//gmp')"
FIG="${FIG}\\n${EXTRA}"

echo -ne "$FIG"
exit
