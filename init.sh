#!/bin/bash

echo "=========================================="
echo "RK3128 打印机服务器编译配置初始化"
echo "=========================================="

# 创建必要目录
mkdir -p .github/workflows patches

# 检查并创建配置文件
if [ ! -f ".config" ]; then
    echo "创建 OpenWrt 配置文件..."
    # 这里应该是完整的 .config 内容
    echo "请将 .config 文件内容复制到此处"
else
    echo ".config 文件已存在"
fi

# 创建工作流文件
if [ ! -f ".github/workflows/build-openwrt.yml" ]; then
    echo "创建 GitHub Actions 工作流..."
    # 这里应该是完整的工作流内容
    echo "请将 build-openwrt.yml 内容复制到此处"
else
    echo "工作流文件已存在"
fi

# 创建 feeds 配置
if [ ! -f "feeds.conf.default" ]; then
    echo "创建 feeds.conf.default..."
    cat > feeds.conf.default << 'EOF'
src-git packages https://git.openwrt.org/feed/packages.git;openwrt-21.02.7
src-git luci https://git.openwrt.org/project/luci.git;openwrt-21.02.7
src-git routing https://git.openwrt.org/feed/routing.git;openwrt-21.02.7
src-git telephony https://git.openwrt.org/feed/telephony.git;openwrt-21.02.7
EOF
fi

# 创建 patch 文件
if [ ! -f "patches/001-rk3128-tlink-r1.patch" ]; then
    echo "创建设备树补丁..."
    mkdir -p patches
    cat > patches/001-rk3128-tlink-r1.patch << 'EOF'
From: RK3128 Printer Server Build
Date: $(date)
Subject: Fix RK3128 tlink_r1 device tree

--- a/target/linux/rockchip/image/tlink_r1.mk
+++ b/target/linux/rockchip/image/tlink_r1.mk
@@ -1,5 +1,5 @@
 define Device/tlink_r1
-  DEVICE_VENDOR := T-Link
+  DEVICE_VENDOR := TP-9038
   DEVICE_MODEL := R1
   SOC := rk3128
   UBOOT_DEVICE_NAME := tlink-r1
@@ -7,7 +7,9 @@
   IMAGE/sysupgrade.img.gz := boot-combined | pad-to 128k | gzip | append-metadata
   DEVICE_PACKAGES := kmod-rtl8xxxu kmod-rtl8192cu kmod-usb-storage
   SUPPORTED_DEVICES := tlink,r1
-  DEVICE_DTS := rk3128-tlink-r1
+  DEVICE_DTS := rockchip/rk3128-tlink-r1
+  IMAGE_SIZE := 256m
+  KERNEL := kernel-bin | gzip | uImage gzip
 endef
 TARGET_DEVICES += tlink_r1
EOF
fi

echo "=========================================="
echo "初始化完成！"
echo "下一步操作："
echo "1. 将上述配置文件内容复制到对应文件中"
echo "2. 执行：git add ."
echo "3. 执行：git commit -m 'Add RK3128 printer server config'"
echo "4. 执行：git push origin main"
echo "5. 在 GitHub 仓库的 Actions 页面手动触发编译"
echo "=========================================="
