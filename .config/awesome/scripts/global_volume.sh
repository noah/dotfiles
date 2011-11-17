#!/bin/sh

# adjust desktop PCM and squeezebox system volume
# this is intended to be an awesome keyboard shortcut callback
#
# yes, I am lazy
# scriptable consumer electronics are sooooooooooooooooooo rad
# http://7be:9000/html/docs/cli-api.html?player=#mixer%20volume

if [[ $# -ne 1 ]]; then
  exit -1
fi

amixer -Dpulse -q -c 0 set Master 1$1
HOST=7be
PORT=9090
VOL_STEP=5
player_id="00:04:20:12:97:e5"

# Don't send commands to the squeezebox in the middle of the night,
# people might be sleeping
#
HOUR=$(date +"%H")
if [[ $HOUR -gt 07 && $HOUR -lt 02 ]]; then
  (echo "$player_id mixer volume $1${VOL_STEP}"; sleep 1)|telnet $HOST $PORT
fi
