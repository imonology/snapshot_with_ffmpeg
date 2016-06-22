cd ~

# Compiling FFmpeg with
# ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-nonfree --extra-libs=-ldl --enable-libfreetype --enable-mmal
wget http://163.22.32.59/ffmpeg.tar.gz
tar zxvf ffmpeg.tar.gz
sudo mv ./ffmpeg /usr/local/bin/
sudo mv ./ffprobe /usr/local/bin/
sudo mv ./ffserver /usr/local/bin/
rm ffmpeg.tar.gz

sudo apt install ttf-wqy-microhei

