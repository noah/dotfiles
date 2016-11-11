#!/bin/sh

# fix blue flash tint
export VDPAU_NVIDIA_NO_OVERLAY=1

xrdb -merge $HOME/.Xdefaults

xscreensaver -no-splash &
#gnome-power-manager&

autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork
xmodmap ~/.Xmodmap

# enable Ctrl+Alt+Backspace
setxkbmap -option terminate:ctrl_alt_bksp

# disable beep
setterm -blength 0

# xcompmgr -cF&
compton -c &

pulseaudio --start

# /home/noah/bin/gnome-settings-daemon&
/usr/lib/gnome-settings-daemon/gnome-settings-daemon&

sudo /etc/cron.hourly/ntpupdate &

urxvtd -q -f -o

nm-applet&

redshift-gtk&

# 
# N.B.: Fn+F7 on esq toggles external monitor
#if [[ $HOST -eq "esq" ]]; then
#	disper -S &
#elif [[ $HOST -eq "noahtlx" ]]; then
#	touch ~/yes
#disper -t left -e 1920x1080,1680x1050
#	sleep 3
#fi

# eeepc
# xrandr -s 1920x1080

#pidgin &

#gnome-keyring-daemon -s --components=pkcs11,secrets,ssh &
#exec ck-launch-session dbus-launch gnome-session --session awesome "$@" 2>&1 > ~/startx-wm.log
exec dbus-launch awesome 2>&1 > ~/logs/startx-wm.log
#export KDEWM=awesome
#exec ck-launch-session dbus-launch startkde > ~/logs/start-wm.log 2>&1
#exec gnome-session 2>&1 > ~/logs/startx-wm.log
