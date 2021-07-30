xrdb -merge $HOME/.config/X11/.Xresources
xcape -e 'Caps_Lock=Escape'&
urxvtd -o -q -f
udiskie&
exec i3
