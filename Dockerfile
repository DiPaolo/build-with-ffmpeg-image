﻿FROM ubuntu:21.04

# to avoid questions about geo-location
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install \
        # general purpose packets
        build-essential \
        cmake \
        clang-format \
        git \
        wget \
        # for CMake building
        openssl libssl-dev \
        # for FFmpeg building
        nasm \
        yasm \
        # for documentation
        doxygen \
        # for libuv building
        automake \
        libtool

# we need CMake v3.20+, but even ubuntu 21.10 has older version, so build it by itself
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz && \
    tar xzvf cmake-3.22.1.tar.gz && \
    cd cmake-3.22.1 && \
    ./bootstrap && make && make install && \
    # clean-up
    cd .. && \
    rm -rf cmake-3.22.1 && \
    rm cmake-3.22.1.tar.gz

# build & install libuv
RUN mkdir -p ~/temp && \
    cd ~/temp && \
    git clone https://github.com/libuv/libuv.git && \
    cd libuv && \
    git checkout tags/v1.42.0 -b v1.42.0 && \
    ./autogen.sh && \
    ./configure --prefix=/root/sdks/libuv/1.42.0 && \
    make && \
    # do not run tests becauase they cannot be ran from root:
    # "The libuv test suite cannot be run as root."
    # make check && \
    make install && \
    # clean-up
    cd / && \
    rm -rf ~/temp

# build & install FFmpeg
RUN mkdir -p ~/temp && \
    cd ~/temp && \
    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg && \
    cd ffmpeg && \
    git checkout tags/n4.4.1 -b v4.4.1 && \
    ./configure --prefix=/root/sdks/ffmpeg/4.4.1 --enable-shared --enable-rpath --disable-debug && \
    make && \
    make install && \
    # clean-up
    cd / && \
    rm -rf ~/temp
