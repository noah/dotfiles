/usr/bin/autocutsel -selection CLIPBOARD -fork
/usr/bin/autocutsel -selection PRIMARY -fork
gnome-settings-daemon &
gnome-power-manager &

urxvtd -q -o -f

XSESS=awesome
#XSESS=gnome-session

exec $XSESS
