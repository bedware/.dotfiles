xrdb -merge $HOME/.config/X11/.Xresources
setxkbmap -layout us,ru -option grp:win_space_toggle -option caps:ctrl_modifier;xcape -e 'Caps_Lock=Escape'&
urxvtd -o -q -f
udiskie&
exec dbus-launch i3
