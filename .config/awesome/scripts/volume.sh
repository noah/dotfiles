#!/bin/sh


# Adjust desktop PCM and squeezebox system volume
# this is intended to be an awesome keyboard shortcut callback
#
# Usage:
#   ./volume.sh [+|-]

have_pulse="$(pgrep -u $(whoami) pulse)"

if [[ -n $have_pulse ]]; then 
  # pulse is running.  do stuff

  # The following convoluted ugliness brought to you courtesy of the
  # creators of pulseaudio.

  # current volume in hex, strip '0x' prefix
  vol_max=65536
  vol_dec=$(echo "ibase=16; $(pacmd dump|grep set-sink-volume|cut -d' ' -f 3|sed -e 's:^0x::'|tr '[a-f]' '[A-F]')"|bc|head -1)

  # need fp division
  vol_pct=$(echo "scale=2;($vol_dec/$vol_max.0)*100" | bc)

  if [[ $# -ne 1 ]]; then
    # print the volume level and die
    #echo -n "$(cut -d '[' -f 2 <<<"$(amixer get Master | tail -n 1)" | sed 's/%.*//g')%"
    # strip fp
    echo -n "$vol_pct" | sed 's:\.[[:digit:]]*::'
    exit 0
  fi

  # plugging in a webcam might break this line
  # amixer -Dpulse -q -c 0 set Master 1$1
  # So, this is not the right way to do it anymore. (F*CKing pulseaudio)
  increment=1000 # this corresponds to a roughly 2% increase in volume
  dec_new_vol="$(echo "$vol_dec$1$increment"|bc)"
  #
  # ...
  #
  #
  # "Volumes commonly span between muted (0%), and normal (100%). It is
  # possible to set volumes to higher than 100%, but clipping might
  # occur."
  # -- http://freedesktop.org/software/pulseaudio/doxygen/volume.html
  #
  # ...
  # 
  # Fact:  PulseAudio was designed by monkeys.
  # 
  if [[ $dec_new_vol -gt $vol_max ]]; then
    dec_new_vol="$vol_max"
  fi
  hex_new_vol="$(echo "ibase=10; obase=16; $dec_new_vol"|bc)"
  pacmd set-sink-volume 0 "0x$hex_new_vol" > /dev/null
  #        the sink idx ^ is still hard-coded here ...
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
