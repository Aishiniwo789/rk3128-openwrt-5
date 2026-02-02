#!/bin/bash

echo "=========================================="
echo "RK3128 打印机服务器一键配置脚本"
echo "=========================================="

# 创建目录结构
mkdir -p .github/workflows patches

# 创建 .config 文件
cat > .config << 'EOF'
CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_rk3128=y
CONFIG_TARGET_rockchip_rk3128_DEVICE_tlink_r1=y
CONFIG_TARGET_ROOTFS_PARTSIZE=256
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_PACKAGE_p910nd=y
CONFIG_PACKAGE_cups=y
CONFIG_PACKAGE_cups-filters=y
CONFIG_PACKAGE_ghostscript=y
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_kmod-r8169=y
CONFIG_PACKAGE_dnsmasq=y
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_kmod-rtl8xxxu=y
CONFIG_PACKAGE_kmod-rtl8192cu=y
CONFIG_PACKAGE_wpad-basic-wolfssl=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-app-cups=y
CONFIG_PACKAGE_luci-app-p910nd=y
CONFIG_PACKAGE_luci-i18n-cups-zh-cn=y
CONFIG_PACKAGE_luci-i18n-p910nd-zh-cn=y
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_nano=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_openssh-server=y
CONFIG_PACKAGE_dropbear=y
CONFIG_CCACHE=y
EOF

# 创建 GitHub Actions 工作流
cat > .github/workflows/build-openwrt.yml << 'EOF'
name: Build OpenWrt for RK3128 Printer Server

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'OpenWrt version'
        required: false
        default: '21.02.7'
  push:
    branches: [ main, master ]

env:
  OPENWRT_VERSION: "21.02.7"

jobs:
  build:
    runs-on: ubuntu-22.04
    timeout-minutes: 120
    
    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4
    
    - name: Setup Build Environment
      run: |
        sudo apt-get update
        sudo apt-get install -y build-essential ccache file g++ gawk gettext git libncurses5-dev libssl-dev python3 python3-distutils rsync unzip wget
    
    - name: Clone OpenWrt Source
      run: |
        git clone --depth=1 --branch v${{ env.OPENWRT_VERSION }} https://github.com/openwrt/openwrt.git openwrt-source
        cd openwrt-source
        echo "src-git packages https://git.openwrt.org/feed/packages.git;openwrt-${{ env.OPENWRT_VERSION }}" > feeds.conf.default
        echo "src-git luci https://git.openwrt.org/project/luci.git;openwrt-${{ env.OPENWRT_VERSION }}" >> feeds.conf.default
    
    - name: Copy Configuration
      run: cp .config openwrt-source/
    
    - name: Update and Install Feeds
      run: |
        cd openwrt-source
        ./scripts/feeds update -a
        ./scripts/feeds install -a
    
    - name: Apply Configuration
      run: |
        cd openwrt-source
        make defconfig
    
    - name: Download Sources
      run: |
        cd openwrt-source
        make -j$(nproc) download
    
    - name: Compile Firmware
      run: |
        cd openwrt-source
        make -j$(nproc) V=s
    
    - name: Upload Firmware Artifacts
      uses: actions/upload-artifact@v4
      with:
        name: rk3128-printer-server-${{ github.sha }}
        path: openwrt-source/bin/targets/rockchip/rk3128/*
        retention-days: 30
EOF

# 创建 README 文件
cat > README.md << 'EOF'
# RK3128 打印机服务器 OpenWrt 编译

## 使用方法

1. 将此仓库 fork 到你的 GitHub 账户
2. 在 Actions 页面启用工作流
3. 点击 "Run workflow" 开始编译
4. 等待编译完成（约 60-90 分钟）
5. 在 Artifacts 中下载固件

## 设备信息
- 型号：索信 TP-9038
- 芯片：RK3128
- 内存：1GB
- 存储：8GB eMMC

## 包含功能
- CUPS 打印服务器
- p910nd 打印服务
- LuCI 中文管理界面
- USB 打印机支持
- 有线/无线网络

## 刷机说明
1. 使用 Rockchip 刷机工具
2. 进入 MaskROM 模式（短接 Flash）
3. 选择下载的固件文件
4. 执行刷机

## 默认登录
- IP: DHCP 自动获取
- 用户名: root
- 密码: password
EOF

# 设置执行权限
chmod +x setup-repo.sh

echo "=========================================="
echo "配置完成！"
echo "请执行以下步骤："
echo ""
echo "1. 上传所有文件到 GitHub 仓库"
echo "2. 进入仓库的 Actions 页面"
echo "3. 点击 'Run workflow' 开始编译"
echo "4. 等待完成后下载固件"
echo "=========================================="
