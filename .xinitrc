#!/bin/sh

if [ -f $HOME/.Xdefaults ]; then
    xrdb -merge $HOME/.Xdefaults
fi

if [ -f $HOME/.Xmodmap ]; then
    exec /usr/bin/xmodmap ~/.Xmodmap&
fi

#xscreensaver -no-splash &
gnome-settings-daemon&
gnome-power-manager&
autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork
urxvtd -f -o -q
# /usr/bin/feh --bg-seamless /home/noah/lauves.jpg

#X_SESS=dwm
#X_SESS=startkde
#X_SESS=wmii

X_SESS=gnome-session
X_SESS=awesome

echo "DISPLAY: $DISPLAY"
echo "tty: $(tty)"
echo "starting $X_SESS"
exec $X_SESS
