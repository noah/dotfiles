#!/bin/sh

xrdb -merge $HOME/.Xdefaults

#xscreensaver -no-splash &
#gnome-power-manager&

autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork
xmodmap ~/.Xmodmap

/home/noah/bin/gnome-settings-daemon&

urxvtd -q -f -o

# 
if [[ $HOST -eq "esq" ]]; then
  disper -S &
fi

#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode DVI-D-1 "1920x1080_60.00"
#xrandr --output DVI-D-1 --mode 1920x1080_60.00
#exec wmii
#exec startkde
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode DVI-D-1 "1920x1080_60.00"
#xrandr --output DVI-D-1 --mode 1920x1080_60.00
# eeepc
# xrandr -s 1920x1080

exec awesome
#exec gnome-session
#exec subtle
