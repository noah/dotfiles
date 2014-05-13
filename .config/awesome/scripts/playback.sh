#!/bin/sh

# adjust playback of squeezebox server or cmus, depending upon which one
# is currently playing =)  this is intended to be an awesome-wm keyboard
# shortcut callback
#
# I am soooooo lazy

if [[ $# -ne 1 ]]; then
  exit 1
fi

cmus_status=$(cmus-remote -Q)

# cmus is playing
if [[ $? -eq 0 ]]; then
  cmus_status_stream=$(echo "$cmus_status" | grep "^file http:\/\/")
  # cmus is streaming riddim server
  if [[ -n "$cmus_status_stream" ]]; then
    ~/bin/riddim -n 2>&1 > /dev/null &
  else
   case $1 in
      "rew")
          cmus-remote -k -5
          ;;
      "ffwd")
          cmus-remote -k +5
          ;;
      *)
      echo player-$1 | cmus-remote &
      ;;
    esac
  fi
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
