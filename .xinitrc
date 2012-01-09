#!/bin/sh

xrdb -merge $HOME/.Xdefaults

#xscreensaver -no-splash &
#gnome-power-manager&

gnome-settings-daemon&
autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork

urxvtd -q -f -o
#exec wmii
#exec startkde
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode DVI-D-1 "1920x1080_60.00"
#xrandr --output DVI-D-1 --mode 1920x1080_60.00
# eeepc
xrandr -s 1920x1080
exec awesome
#exec gnome-session
#exec subtle
