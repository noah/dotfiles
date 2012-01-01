#!/bin/sh

# adjust playback of squeezebox server or cmus, depending upon which one
# is currently playing =)  this is intended to be an awesome keyboard
# shortcut callback
#
# I am soooooo lazy

if [[ $# -ne 1 ]]; then
  exit 1
fi

cmus-remote -Q > /dev/null
if [[ $? -eq 0 ]]; then
  echo player-$1 | cmus-remote
else
  # scriptable consumer electronics are sooooooooooooooooooo rad
  # http://7be:9000/html/docs/cli-api.html?player=#mixer%20volume
  HOST=7be
  PORT=9090
  player_id="00:04:20:12:97:e5"

  case $1 in 
    "next")
      (echo "$player_id playlist index +1"; sleep 1)|telnet $HOST $PORT
      ;;
    "prev")
      (echo "$player_id playlist index -1"; sleep 1)|telnet $HOST $PORT
      ;;
    "pause")
      (echo "$player_id pause"; sleep 1)|telnet $HOST $PORT
      ;;
    *)
      exit 1
      ;;
  esac
fi
