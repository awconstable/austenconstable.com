---
author: awconstable
comments: true
date: 2008-08-06 12:13:00+00:00
layout: post
slug: 2008-08-06-howto-compile-ffmpeg-centos4
title: 'HOWTO: Compiling the latest FFmpeg & x264 on CentOS 4'
categories:
- HOWTO
- Linux
tags:
- FLV
- CentOS
- Video
- Nokia N95
- x264
---
## Introduction

FFmpeg is a superb video processing tool used to encode and transcode video files. In this particular project I needed to build "youtube" style video upload which would transcode into FLV, specifically catering for video files from the Nokia N95.

I spent quite a long time messing about with the stock version of ffmpeg on CentOS 4/Ubuntu trying to make it work, but it turned out not to be new enough/have all the right support compiled in.

This howto was written because I couldn't find anything that fitted the bill for CentOS/RHEL (And being a Ubuntu man, found it a pain to get it compiled and working under CentOS). It's based on the excellent tutorial by FakeOutdoorsman over on the [Ubuntu forums](http://ubuntuforums.org/showthread.php?t=786095). So big thanks to them.

These instructions have been tested on a fresh minimal install of CentOS 4.6 running in a VirtualBox VM.
### Preparation

1. Ensure that you have the rpmforge repo's added to yum. See [here](http://dag.wieers.com/rpm/FAQ.php#B1)for instructions.
2. Update the install

```bash
yum update
```

3. (If you are *not* installing onto a fresh minimal install) Remove ffmpeg, x264 and faad2 to avoid confusion.

```bash
yum remove ffmpeg x264 faad2 faad2-devel
```

4. Install the necessary build tools

```bash
yum install gcc gcc-c++ automake autoconf libtool yasm git subversion
```

5. Install the necessary libraries

```bash
yum install zlib-devel libmad-devel libvorbis-devel libtheora-devel lame-devel faac-devel a52dec-devel xvidcore-devel freetype-devel
```

### Compile supporting libraries

1. Compile & Install [faad2](http://www.audiocoding.com/faad2.html) (for some reason I couldn't get it to compile against the standard rpm version)

```bash
cd ~
wget http://downloads.sourceforge.net/faac/faad2-2.6.1.tar.gz
tar xzvf faad2-2.6.1.tar.gz
cd faad2
autoreconf -vif
./configure
make
make install
```

2. Compile & Install [GPAC](http://gpac.sourceforge.net/)

```bash
cd ~
wget http://downloads.sourceforge.net/gpac/gpac-0.4.4.tar.gz
tar -xzvf gpac-0.4.4.tar.gz
cd gpac
./configure
make
make install
make install-lib
```

Note: if the compile fails with a osmozilla related error, please see [here](http://sourceforge.net/forum/forum.php?thread_id=1950227&amp;forum_id=287546). I had to remove mozilla support to get it to compile.

3. Update the links to the shared libs

```bash
echo '/usr/local/lib/' > /etc/ld.so.conf.d/gapc-1386.conf
ldconfig
```

4. Compile & Install [x264](http://www.videolan.org/developers/x264.html)

```bash
cd ~
git clone git://git.videolan.org/x264.git
cd x264
./configure  --enable-pthread --enable-mp4-output --enable-shared
make
make install
```

5. Update the links to the shared libs...again

```bash
    ldconfig
```

### Install ffmpeg

1. Install ffmpeg

```bash
cd ~
svn export svn://svn.mplayerhq.hu/ffmpeg/trunk ffmpeg
cd ffmpeg
./configure --prefix=/usr/local --disable-debug --enable-shared --enable-gpl --enable-nonfree --enable-postproc --enable-swscale --enable-pthreads --enable-x11grab --enable-liba52 --enable-libx264 --enable-libxvid --enable-libvorbis --enable-libfaac --enable-libfaad --enable-libmp3lame
make
make install
```

2. If ffmpeg has problems finding shared libraries, set the LD_LIBRARY_PATH

```bash
echo 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib; export LD_LIBRARY_PATH' >> /etc/ld.so.conf
ldconfig
```

I'm not convinced that this is the [correct thing](http://xahlee.org/UnixResource_dir/_/ldpath.html) to do, or the correct way to do it...but it seems to work...

3. All done

## Additional resources

[http://www.tuxmachines.org/node/17063](http://www.tuxmachines.org/node/17063)
