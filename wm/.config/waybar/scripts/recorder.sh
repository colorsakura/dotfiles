#!/bin/env bash

if killall -s SIGINT wf-recorder;then
  notify-send "Recorder Finish"
else
  echo 100 > $WOBSOCK 
  wf-recorder -f ~/$(date +%y-%m-%d-%k%M).mp4 -c hevc_vaapi -d /dev/dri/renderD128
fi
