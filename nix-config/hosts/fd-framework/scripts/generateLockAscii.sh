#!/usr/bin/env bash

function read_nixos_version () {
  local current_generation=$(nixos-rebuild list-generations --json | jq '. - map(select(.current != true)) | .[]')
  eval $(echo "$current_generation" | jq -r 'to_entries[] | "export \(.key)=\(.value | @sh)"')
}

read_nixos_version

LARGE="FLOPPYOS"
printf -v EXTRA "FloppyOS version %d (%s)" $generation $nixosVersion

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
