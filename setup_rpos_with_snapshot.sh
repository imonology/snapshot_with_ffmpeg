#!/bin/bash
sudo apt update
sudo apt -y install git build-essential vim

cd /home/pi
git clone https://github.com/sunnyworm/snapshot_with_ffmpeg
git clone https://github.com/BreeeZe/rpos.git
git clone https://github.com/tj/n.git

cd n && sudo make install && cd /home/pi && sudo /usr/local/bin/n lts && sudo /usr/local/bin/npm install tsc -g
cd rpos && /usr/local/bin/npm install && /usr/local/bin/tsc rpos.ts && sudo chmod +x setup_v4l2rtspserver.sh && ./setup_v4l2rtspserver.sh 

# note:
# x264 commit 3f5ed56d4105f68c01b86f94f41bb9bbefa3433b
# ffmpeg 18f687f73709a3ad5bb6b6fbbdbbce6dc8a91036
# ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree --extra-libs=-ldl --enable-libfreetype --enable-mmal

cd /home/pi
wget http://cslab.im.ncnu.edu.tw/ffmpeg.tar.gz

tar zxvf ffmpeg.tar.gz
sudo mv ./ffmpeg /usr/local/bin/
sudo mv ./ffprobe /usr/local/bin/
sudo mv ./ffserver /usr/local/bin/
rm ffmpeg.tar.gz

# for drawtext filter in ffmpeg
sudo apt -y install ttf-wqy-microhei screen

sudo cp /home/pi/snapshot_with_ffmpeg/snapshot.sh /opt/
sudo cp /home/pi/snapshot_with_ffmpeg/start_rpos.sh /opt/
sudo chmod +x /opt/snapshot.sh
sudo chmod +x /opt/start_rpos.sh

rm -rf /home/pi/n

sudo crontab -l | { cat; echo "@reboot sleep 5; /usr/bin/screen -dmS rpos bash -c 'sudo /opt/start_rpos.sh; exec bash'"; } | sudo crontab -
sudo crontab -l | { cat; echo "@reboot sleep 15; cd /dev/shm && /usr/bin/screen -dmS snapshot bash -c 'sudo /opt/snapshot.sh; exec bash'"; } | sudo crontab -

echo "remember to change RTSPServer from default(1) to V4L2 RTSP Server by mpromonet(2) in /home/pi/rpos/rposConfig.json"
