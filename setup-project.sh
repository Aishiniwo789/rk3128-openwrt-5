#!/bin/bash

echo "=========================================="
echo "RK3128 打印机服务器项目初始化"
echo "=========================================="

# 创建目录结构
mkdir -p .github/workflows

# 创建 .config 文件
cat > .config << 'EOF'
# RK3128 TP-9038 打印机服务器配置 (OpenWrt 19.07)
CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_armv8=y
CONFIG_TARGET_rockchip_armv8_DEVICE_tlink_r1=y
CONFIG_TARGET_ROOTFS_PARTSIZE=64
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_PACKAGE_p910nd=y
CONFIG_PACKAGE_cups=y
CONFIG_PACKAGE_cups-filters=y
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_kmod-r8169=y
CONFIG_PACKAGE_dnsmasq-full=y
CONFIG_PACKAGE_kmod-rtl8xxxu=y
CONFIG_PACKAGE_kmod-rtl8192cu=y
CONFIG_PACKAGE_wpad-basic=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-base=y
CONFIG_PACKAGE_luci-app-cups=y
CONFIG_PACKAGE_luci-app-p910nd=y
CONFIG_PACKAGE_luci-i18n-cups-zh-cn=y
CONFIG_PACKAGE_luci-i18n-p910nd-zh-cn=y
CONFIG_PACKAGE_nano=y
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_dropbear=y
CONFIG_CCACHE=y
EOF

# 创建 GitHub Actions 工作流
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
      run: |
        sudo apt-get update
        sudo apt-get install -y build-essential ccache file g++ gawk gettext git libncurses5-dev libssl-dev python3 python3-distutils rsync unzip wget
    
    - name: Clone OpenWrt 19.07.10
      run: |
        git clone --depth=1 --branch v19.07.10 https://github.com/openwrt/openwrt.git openwrt
    
    - name: Setup Feeds
      run: |
        cd openwrt
        echo "src-git packages https://git.openwrt.org/feed/packages.git;openwrt-19.07" > feeds.conf.default
        echo "src-git luci https://git.openwrt.org/project/luci.git;openwrt-19.07" >> feeds.conf.default
        cp ../.config .
        ./scripts/feeds update -a
        ./scripts/feeds install -a
    
    - name: Configure Build
      run: |
        cd openwrt
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
        path: openwrt/bin/targets/rockchip/armv8/
    
    - name: Upload Logs on Failure
      if: failure()
      uses: actions/upload-artifact@v4
      with:
        name: build-logs
        path: |
          openwrt/build.log
          openwrt/.config
EOF

# 创建 README 文件
cat > README.md << 'EOF'
# RK3128 打印机服务器固件编译

## 项目说明
为索信 TP-9038 (RK3128芯片) 电视盒子编译 OpenWrt 19.07.10 固件，集成打印机服务器功能。

## 设备信息
- 芯片: Rockchip RK3128 (ARM Cortex-A7)
- 内存: 1GB
- 存储: 8GB eMMC
- 接口: 2×USB, HDMI, 网口, AV, 无线

## 包含功能
1. **CUPS 打印服务器** - 支持 USB 和网络打印机
2. **p910nd 打印服务** - 轻量级打印服务器
3. **USB 打印机自动识别**
4. **LuCI 中文管理界面**
5. **无线网络支持** (RTL8188/8192系列)
6. **基础网络功能**

## 使用方法

### 1. 编译固件
1. 推送代码到 GitHub 仓库
2. 进入仓库的 Actions 页面
3. 运行 "Build OpenWrt for RK3128 Printer Server" 工作流
4. 等待编译完成 (约60-90分钟)
5. 在 Artifacts 中下载固件

### 2. 刷机步骤
1. 拆开电视盒子，找到 Flash 芯片
2. 短接 CLK 和 GND 引脚（进入 MaskROM 模式）
3. 使用 Rockchip 刷机工具加载固件
4. 执行刷机操作
5. 移除短接，重启设备

### 3. 首次使用
1. 连接网线或连接无线网络 OpenWrt
2. 访问 http://192.168.1.1
3. 用户名: root
4. 密码: password
5. 在 "服务" 菜单中配置打印机

## 文件说明
- `.config` - OpenWrt 编译配置文件
- `.github/workflows/build-openwrt.yml` - GitHub Actions 工作流
- `README.md` - 本说明文件

## 技术支持
如遇到编译问题，请检查：
1. GitHub Actions 的详细日志
2. 确保使用正确的 RK3128 配置
3. 确认网络连接正常
EOF

echo "=========================================="
echo "项目初始化完成！"
echo ""
echo "下一步："
echo "1. 将文件推送到 GitHub 仓库"
echo "2. 进入 Actions 页面运行工作流"
echo "3. 等待编译完成后下载固件"
echo "=========================================="

# 设置脚本权限
chmod +x setup-project.sh
