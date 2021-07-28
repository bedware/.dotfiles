setxkbmap -option 'caps:ctrl_modifier'; xcape -e 'Caps_Lock=Escape'&
xrdb -merge $HOME/.config/X11/.Xresources
urxvtd -o -q -f
exec i3
