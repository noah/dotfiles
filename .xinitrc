#!/bin/sh

# no beep
xset -b

# natural scroll
# xinput set-button-map 11 1 2 3 5 4 6 7
# xmodmap ~/.Xmodmap

# set natural scroll.  get id-only param from $ xinput list
_mid=$(xinput list --id-only "Logitech M325") 
xinput set-prop --type=int --format=32 $_mid "Evdev Scrolling Distance" -1 -1 -1
# see http://forums.fedoraforum.org/showthread.php?t=298702


# fix blue flash tint
export VDPAU_NVIDIA_NO_OVERLAY=1

xrdb -merge $HOME/.Xdefaults

xscreensaver -no-splash &


urxvtd -q -o -f

/usr/lib/gnome-settings-daemon/gnome-settings-daemon-localeexec&

nm-applet&

autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork

# enable Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp

# disable beep
setterm -blength 0

# xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &
compton -c&

redshift-gtk&

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK


xrandr --output DisplayPort-2 --left-of LVDS-0

#pidgin &

exec awesome 2>&1 >> ~/logs/startx.log
