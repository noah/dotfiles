#!/bin/sh

xrdb -merge $HOME/.Xdefaults
autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork
xmodmap ~/.Xmodmap
# enable Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp
/usr/lib/gnome-settings-daemon/gnome-settings-daemon&
nm-applet&
#pidgin&
urxvtd -q -f -o
start-pulseaudio-x11
sudo /etc/cron.hourly/ntpupdate&
urxvtd -q -o -f
awsetbg -u feh -a -f /home/noah/background

#exec ck-launch-session dbus-launch gnome-session --session awesome "$@" > ~/logs/startx-wm.log 2>&1
exec ck-launch-session dbus-launch awesome > ~/logs/startx-wm.log 2>&1

