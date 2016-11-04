#!/bin/sh

set -o errexit
set -o verbose

# Install the required libraries that are available as debs.
sudo apt-get update
sudo apt-get install --reinstall -y \
    cmake \
    g++ \
    git \
    google-mock \
    libboost-all-dev \
    libcairo2-dev \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libprotobuf-dev \
    libsuitesparse-dev \
    libwebp-dev \
    ninja-build \
    protobuf-compiler \
    python-sphinx

mkdir cartographer/build
cd cartographer/build
cmake ..
make -j4 -l4
sudo make install
cd ../..

mkdir ceres_solver/build
cd ceres_solver/build
cmake ..
make -j4 -l4
cd ../..

