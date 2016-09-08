#!/bin/bash

#Remove any existing packages:
sudo apt-get -y remove ffmpeg x264 libav-tools libvpx-dev libx264-dev gpac

# Get the dependencies:
sudo apt-get update
sudo apt-get -y install build-essential checkinstall git libfaac-dev libgpac-dev \
  libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libtheora-dev \
    libvorbis-dev pkg-config texi2html yasm zlib1g-dev libswscale-dev libavresample-dev \
	libxv-dev libavdevice-dev

# Install x264
sudo apt-get -y install libx264-dev
cd
git clone git://git.videolan.org/git/x264.git x264
cd x264
./configure --enable-shared --disable-cli --enable-strip --disable-avs --disable-swscale --disable-lavf --disable-ffms --disable-gpac --disable-opencl
make -j
sudo make install

# Install AAC audio decoder
cd
wget http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.0.tar.gz
tar xzvf fdk-aac-0.1.0.tar.gz
cd fdk-aac-0.1.0
./configure
make -j
sudo checkinstall --pkgname=fdk-aac --pkgversion="0.1.0" --backup=no \
  --deldoc=yes --fstrans=no --default

# Install VP8 video encoder and decoder.
cd
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx
cd libvpx
./configure
make -j
sudo checkinstall --pkgname=libvpx --pkgversion="1:$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default

# Installing FFmpeg
cd
git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure --enable-shared --enable-pic --enable-gpl \
	--enable-libfaac --enable-libmp3lame --enable-libvpx --enable-libfdk-aac \
  --enable-libx264 --enable-nonfree --enable-version3 --enable-avresample
make -j
sudo make install
hash x264 ffmpeg ffplay ffprobe

# Optional: install qt-faststart
# This is a useful tool if you're showing your H.264 in MP4 videos on the web. It relocates some data in the video to allow playback to begin before the file is completely downloaded. Usage: qt-faststart input.mp4 output.mp4.
cd ~/ffmpeg
make tools/qt-faststart
sudo make install

# Installing gpac from git repository
cd ~/
sudo rm -rf ~/.gpac ~/gpac/
git clone https://github.com/gpac/gpac.git
cd gpac/applications/dashcast
vim controler.c
make
cd ../../
./configure --disable-ffmpeg-versions
make
sudo make install
sudo make install-lib
echo "done"
