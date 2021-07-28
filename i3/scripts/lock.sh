#!/bin/sh

img=/tmp/i3lock.png

scrot -o $img

# Pixel-like
# convert $img -scale 10% -scale 1000% $img
# Gaussian-like
convert $img -blur 0x6 $img

i3lock -u -i $img

