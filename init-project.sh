#!/bin/bash

echo "=========================================="
echo "RK3128 打印机服务器项目初始化"
echo "=========================================="

# 创建项目目录
if [ ! -d ".github/workflows" ]; then
    mkdir -p .github/workflows
    echo "创建 .github/workflows 目录"
fi

# 创建配置文件
if [ ! -f ".config" ]; then
    echo "创建 .config 文件..."
    cat > .config << 'EOF'
# RK3128 打印机服务器配置
CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_rk3128=y
CONFIG_TARGET_rockchip_rk3128_DEVICE_tlink_r1=y
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_ROOTFS_PARTSIZE=64

# 打印机服务
CONFIG_PACKAGE_p910nd=y
CONFIG_PACKAGE_cups=y
CONFIG_PACKAGE_cups-filters=y
CONFIG_PACKAGE_ghostscript=y

# USB 支持
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-printer=y

# 网络
CONFIG_PACKAGE_kmod-r8169=y
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_iptables=y

# 无线
CONFIG_PACKAGE_kmod-rtl8xxxu=y
CONFIG_PACKAGE_wpad-basic-wolfssl=y

# 管理界面
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-app-cups=y
CONFIG_PACKAGE_luci-app-p910nd=y

# 工具
CONFIG_PACKAGE_nano=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_dropbear=y

# 优化
CONFIG_CCACHE=y
EOF
    echo ".config 文件已创建"
fi

# 创建 GitHub Actions 工作流
if [ ! -f ".github/workflows/build-openwrt.yml" ]; then
    echo "创建 GitHub Actions 工作流..."
    cat > .github/workflows/build-openwrt.yml << 'EOF'
name: Build OpenWrt for RK3128 Printer Server

on: [workflow_dispatch, push]

jobs:
  build:
    runs-on: ubuntu-22.04
    timeout-minutes: 120
    
    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4
    
    - name: Install Dependencies
      run: sudo apt-get update && sudo apt-get install -y build-essential ccache file g++ gawk gettext git libncurses5-dev libssl-dev python3 python3-distutils rsync unzip wget
    
    - name: Clone OpenWrt 21.02.7
      run: git clone --depth=1 https://github.com/openwrt/openwrt.git openwrt && cd openwrt && git checkout 21.02.7
    
    - name: Setup Feeds
      run: |
        cd openwrt
        echo "src-git packages https://git.openwrt.org/feed/packages.git;openwrt-21.02" > feeds.conf.default
        echo "src-git luci https://git.openwrt.org/project/luci.git;openwrt-21.02" >> feeds.conf.default
        cp ../.config .
        ./scripts/feeds update -a
        ./scripts/feeds install -a
        make defconfig
    
    - name: Download Sources
      run: |
        cd openwrt
        make -j$(nproc) download
    
    - name: Build Firmware
      run: |
        cd openwrt
        make -j$(($(nproc)+1))
    
    - name: Upload Firmware
      if: success()
      uses: actions/upload-artifact@v4
      with:
        name: rk3128-firmware
        path: openwrt/bin/targets/rockchip/rk3128/
    
    - name: Upload Logs on Failure
      if: failure()
      uses: actions/upload-artifact@v4
      with:
        name: build-logs
        path: |
          openwrt/build.log
          openwrt/.config
EOF
    echo "GitHub Actions 工作流已创建"
fi

echo ""
echo "=========================================="
echo "项目初始化完成！"
echo ""
echo "下一步操作："
echo "1. 将项目推送到 GitHub:"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial commit'"
echo "   git remote add origin https://github.com/Aishiniwo789/rk3128-openwrt-5.git"
echo "   git push -u origin main"
echo ""
echo "2. 在 GitHub 上："
echo "   - 进入仓库的 Actions 页面"
echo "   - 启用工作流"
echo "   - 点击 'Run workflow' 开始编译"
echo ""
echo "3. 编译完成后："
echo "   - 在 Artifacts 中下载固件"
echo "   - 使用 Rockchip 工具刷机"
echo "=========================================="
