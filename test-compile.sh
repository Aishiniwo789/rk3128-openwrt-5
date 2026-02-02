#!/bin/bash

# 测试编译的最小配置
TEST_CONFIG=".config.test"

echo "创建测试配置..."
cat > ${TEST_CONFIG} << 'EOF'
CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_rk3128=y
CONFIG_TARGET_rockchip_rk3128_DEVICE_tlink_r1=y
CONFIG_TARGET_ROOTFS_SQUASHFS=y
CONFIG_TARGET_ROOTFS_PARTSIZE=32
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb-printer=y
CONFIG_PACKAGE_p910nd=y
CONFIG_CCACHE=y
EOF

echo "使用测试配置编译内核..."
if [ -d "openwrt-source" ]; then
    cd openwrt-source
    cp ../${TEST_CONFIG} .config
    make defconfig
    echo "编译内核..."
    make target/linux/{clean,prepare} V=s -j1
    if [ $? -eq 0 ]; then
        echo "内核编译成功！"
    else
        echo "内核编译失败"
        exit 1
    fi
else
    echo "错误: openwrt-source 目录不存在"
    exit 1
fi
