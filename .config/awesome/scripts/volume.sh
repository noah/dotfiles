#!/bin/sh


# Adjust desktop PCM and squeezebox system volume
# this is intended to be an awesome keyboard shortcut callback
#
# Usage:
#   ./volume.sh [+|-|]

have_pulse="$(pgrep -u $(whoami) pulse)"

if [[ -n $have_pulse ]]; then 
  # pulse is running.  do stuff

  if [[ $# -ne 1 ]]; then
    # print the volume level and die
    echo -n "$(cut -d '[' -f 2 <<<"$(amixer get Master | tail -n 1)" | sed 's/%.*//g')%"
    exit 0
  fi

  # plugging in a webcam might break this line
  amixer -Dpulse -q -c 1 set Master 1$1
else
  echo -n "0% (no pulse)"

fi

###
# Squeezebox
# yes, I am lazy
# scriptable consumer electronics are sooooooooooooooooooo rad
# http://7be:9000/html/docs/cli-api.html?player=#mixer%20volume

# HOST=localhost
# PORT=9090
# VOL_STEP=5
# player_id="00:04:20:12:97:e5"
# 
# # Don't send commands to the squeezebox in the middle of the night,
# # people might be sleeping
# #
# HOUR=$(date +"%H")
# if [[ $HOUR -gt 07 && $HOUR -lt 02 ]]; then
#   (echo "$player_id mixer volume $1${VOL_STEP}"; sleep 1)|telnet $HOST $PORT
# fi
