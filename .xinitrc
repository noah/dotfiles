/usr/bin/autocutsel -selection CLIPBOARD -fork
/usr/bin/autocutsel -selection PRIMARY -fork
gnome-settings-daemon &
gnome-power-manager &

XSESS=awesome
# XSESS=gnome-session

exec $XSESS
