#!/bin/bash

cd ~
git clone https://github.com/sunnyworm/snapshot_with_ffmpeg

# note:
# x264 commit 3f5ed56d4105f68c01b86f94f41bb9bbefa3433b
# ffmpeg 18f687f73709a3ad5bb6b6fbbdbbce6dc8a91036
# ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree --extra-libs=-ldl --enable-libfreetype --enable-mmal

wget http://cslab.im.ncnu.edu.tw/ffmpeg.tar.gz

tar zxvf ffmpeg.tar.gz
sudo mv ./ffmpeg /usr/local/bin/
sudo mv ./ffprobe /usr/local/bin/
sudo mv ./ffserver /usr/local/bin/
rm ffmpeg.tar.gz

# for drawtext filter in ffmpeg
sudo apt -y install ttf-wqy-microhei

sudo cp /home/pi/snapshot_with_ffmpeg/snapshot.sh /opt/

echo "Type sudo crontab -e and add entries like this:"
echo "@reboot sleep 15; cd /dev/shm && /usr/bin/screen -dmS snapshot bash -c 'sudo /opt/snapshot.sh; exec bash'"
echo "and this will run after rpi has booted"
