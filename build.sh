#!/bin/bash
set -e

echo "=== Building OpenWRT for RK3128 Printer Server ==="

# 安装依赖
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y build-essential ccache file g++ gawk gettext git libncurses5-dev libssl-dev python3 python3-distutils python3-setuptools rsync unzip wget

# 克隆源码
echo "Downloading OpenWRT source..."
if [ ! -d "openwrt" ]; then
    git clone --depth=1 https://github.com/openwrt/openwrt.git
    cd openwrt
    git checkout v21.02.3
    cd ..
fi

# 更新feeds
echo "Updating feeds..."
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a

# 应用配置
echo "Applying configurations..."
cp ../configs/rk3128.config .config
cat ../configs/printer-server.config >> .config

# 复制自定义文件
echo "Copying custom files..."
mkdir -p files/etc/config files/etc/init.d files/usr/lib/cups/backend
cp -r ../files/* .

# 设置权限
chmod +x files/etc/init.d/cups files/usr/lib/cups/backend/usb files/etc/rc.local

# 配置
echo "Configuring build..."
make defconfig

# 下载
echo "Downloading packages..."
make download -j$(nproc)

# 构建
echo "Building OpenWRT (this will take a while)..."
make -j$(($(nproc) + 1))

echo "=== Build complete! ==="
echo "Firmware location: $(pwd)/bin/targets/rockchip/armv8/"
ls -lh bin/targets/rockchip/armv8/*.img.gz
