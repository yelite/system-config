#!/bin/sh

BG='#434C5Eff'
BLANK='#00000000'
CLEAR='#ECEFF422'
DEFAULT='#D8DEE9cc'
TEXT='#E5E9F0ee'
ACTION='#5E81ACee'
WRONG='#BF616Abb'
VERIFYING='#EBCB8Bbb'

i3lock-color \
--color=$BG                  \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$ACTION        \
--bshl-color=$ACTION         \
\
--radius=165                 \
--ring-width=10              \
--time-size=82               \
--date-size=20               \
--ind-pos="x+w/2:y+0.382*h"  \
--time-pos="ix:iy+18"        \
--date-pos="tx:ty+37"        \
--time-str="%H:%M"           \
--date-str="%F %a"                \
\
--show-failed-attempts       \
--pass-media-keys            \
--pass-screen-keys           \
--pass-power-keys            \
--pass-volume-keys           \
\
--clock                      \
