#!/bin/sh

PRIMARY="#dc2626ff"
SECONDARY="#b91c1cff"
TERTIARY="#450a0aff"

i3lock \
    --blur 5 \
    --inside-color=$TERTIARY \
    --insidever-color=$TERTIARY \
    --insidewrong-color=$TERTIARY \
    --ring-color=$TERTIARY \
    --ringver-color=$SECONDARY \
    --ringwrong-color=$SECONDARY \
    --separator-color=$TERTIARY \
    --line-color=$PRIMARY \
    --keyhl-color=$PRIMARY \
    --bshl-color=$SECONDARY \
    --ring-width=4 \
    --radius=32 \
    --time-color=A89984FF \
    --time-pos='ix-180:iy+12' \
    --time-pos='ix-r-50:iy+12' \
    --time-str='%H:%M:%S' \
    --time-font='monospace' \
    --time-align=2 \
    --time-size=32 \
    --date-color=A89984FF \
    --date-pos='ix+180:iy+12' \
    --date-pos='ix+r+50:iy+12' \
    --date-str='%d.%m.%y' \
    --date-font='monospace' \
    --date-align=1 \
    --date-size=32 \
    --greeter-pos='x+100:iy+12' \
    --verif-color=00000000 \
    --wrong-color=00000000 \
    --modif-color=00000000 \
    --layout-color=00000000 \
    --greeter-color=00000000 \
    --verif-text='' \
    --wrong-text='' \
    --noinput-text='' \
    --lock-text='' \
    --lockfailed-text='' \
    --greeter-text='' \
    --ignore-empty-password \
    --pass-media-keys \
    --pass-screen-keys \
    --indicator \
    --clock
