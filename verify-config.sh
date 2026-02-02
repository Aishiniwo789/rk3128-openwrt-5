#!/bin/bash

echo "验证配置文件..."
echo ""

# 检查 .config 文件
if [ ! -f ".config" ]; then
    echo "错误: .config 文件不存在"
    exit 1
fi

echo "✓ .config 文件存在"
echo ""

# 检查关键配置
echo "检查关键配置项:"
echo "------------------------"

check_config() {
    local config=$1
    local description=$2
    if grep -q "^${config}=y$" .config; then
        echo "✓ $description"
        return 0
    else
        echo "✗ $description"
        return 1
    fi
}

check_config "CONFIG_TARGET_rockchip" "Rockchip 目标平台"
check_config "CONFIG_TARGET_rockchip_rk3128" "RK3128 子平台"
check_config "CONFIG_TARGET_rockchip_rk3128_DEVICE_tlink_r1" "tlink_r1 设备"
check_config "CONFIG_PACKAGE_cups" "CUPS 打印服务"
check_config "CONFIG_PACKAGE_kmod-usb-printer" "USB 打印机驱动"
check_config "CONFIG_PACKAGE_luci" "LuCI 管理界面"
check_config "CONFIG_PACKAGE_luci-app-cups" "CUPS LuCI 界面"

echo ""
echo "配置文件验证完成"
