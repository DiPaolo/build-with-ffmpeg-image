FROM ubuntu:20.04

# RUN apk add --no-cache python2 g++ make

# to avoid questions about geo-location
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install \
        build-essential \
        cmake \
        clang-format-12 \
        openssl libssl-dev \
        wget # see below


# we need CMake v3.20+, but even ubuntu 21.10 has older version, so build it by itself
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz && \
    tar xzvf cmake-3.22.1.tar.gz && \
    cd cmake-3.22.1 && \
    ./bootstrap && make && make install && \
    # clean-up
    cd .. && \
    rm -rf cmake-3.22.1 && \
    rm cmake-3.22.1.tar.gz

# WORKDIR /app

# CMD ["node", "src/index.js"]
