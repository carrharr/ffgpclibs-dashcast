#!/bin/bash

#Remove any existing packages:
sudo apt-get -y remove ffmpeg x264 libav-tools libvpx-dev libx264-dev gpac

# Get the dependencies:
sudo apt-get update
sudo apt-get -y install build-essential checkinstall git vim libfaac-dev libgpac-dev \
  libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev librtmp-dev libtheora-dev \
    libvorbis-dev pkg-config texi2html yasm zlib1g-dev libswscale-dev libavresample-dev \
	libxv-dev libavdevice-dev

# Install x264
sudo apt-get -y install libx264-dev
cd
git clone git://git.videolan.org/git/x264.git x264
cd x264
./configure --enable-static 
make 
sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
	awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
	--fstrans=no --default

# Install AAC audio decoder
cd
wget http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.0.tar.gz
tar xzvf fdk-aac-0.1.0.tar.gz
cd fdk-aac-0.1.0
./configure
make 
sudo make install

# Add lavf support to x264
cd ~/x264
make distclean
./configure --enable-static
make
sudo make install

# Installing FFmpeg
cd
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
./configure --enable-shared --enable-pic --enable-libfaac --enable-gpl \
	--enable-librtmp --enable-libmp3lame --enable-libfdk-aac \
	--enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora \
	--enable-libvorbis --enable-libx264 --enable-nonfree \
	--enable-version3 --enable-avresample
make 
sudo make install
hash ffmpeg

# Optional: install qt-faststart
# This is a useful tool if you're showing your H.264 in MP4 videos on the web. It relocates some data in the video to allow playback to begin before the file is completely downloaded. Usage: qt-faststart input.mp4 output.mp4.
cd ~/ffmpeg
make tools/qt-faststart
sudo make install

# Installing gpac from git repository
cd ~/
sudo rm -rf ~/.gpac ~/gpac/
git clone https://github.com/gpac/gpac.git
cd gpac
sed -i -e 's|if\ (!audio_data_conf)|//if\ (!audio_data_conf)|g' applications/dashcast/controller.c
./configure --disable-ffmpeg-versions
make
sudo make install
sudo make install-lib
echo "done"
