#!/bin/bash

# 修复编译依赖问题

echo "安装编译 RK3128 所需的额外依赖..."
sudo apt-get update

# 基础编译工具
sudo apt-get install -y \
    build-essential \
    ccache \
    ecj \
    fastjar \
    file \
    g++ \
    gawk \
    gettext \
    git \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    python3 \
    python3-distutils \
    python3-setuptools \
    python3-dev \
    rsync \
    unzip \
    wget \
    zlib1g-dev

# 特定于架构的依赖
sudo apt-get install -y \
    gcc-arm-linux-gnueabi \
    binutils-arm-linux-gnueabi \
    libc6-dev-armel-cross

# OpenWrt 特定工具
sudo apt-get install -y \
    subversion \
    swig \
    time \
    python3-pyelftools \
    libelf-dev \
    libxml2-dev \
    lib32z1-dev

echo "依赖安装完成"
