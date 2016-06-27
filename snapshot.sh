#!/bin/sh
v4l2-ctl --set-ctrl video_bitrate=25000000
cd /dev/shm &&
/usr/local/bin/node /home/pi/snapshot_with_ffmpeg/snapshot.js
