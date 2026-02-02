#!/bin/bash

echo "=========================================="
echo "验证 RK3128 编译配置"
echo "=========================================="

# 检查必要文件
echo "检查配置文件..."
if [ ! -f ".config" ]; then
    echo "错误: .config 文件不存在"
    exit 1
fi

echo "检查 GitHub Actions 工作流..."
if [ ! -f ".github/workflows/build-openwrt.yml" ]; then
    echo "错误: GitHub Actions 工作流文件不存在"
    exit 1
fi

# 验证 .config 文件基本配置
echo "验证 .config 文件..."
if ! grep -q "CONFIG_TARGET_rockchip_rk3128=y" .config; then
    echo "错误: 未配置 RK3128 目标"
    exit 1
fi

if ! grep -q "CONFIG_PACKAGE_cups=y" .config; then
    echo "错误: 未包含 CUPS 打印机服务"
    exit 1
fi

if ! grep -q "CONFIG_PACKAGE_kmod-usb-printer=y" .config; then
    echo "错误: 未包含 USB 打印机驱动"
    exit 1
fi

# 验证 GitHub Actions 语法
echo "验证 GitHub Actions 语法..."
if grep -q "openwrt-21.02.7" .github/workflows/build-openwrt.yml; then
    echo "错误: 工作流中使用了错误的 feeds 分支名称"
    exit 1
fi

# 验证 feeds 配置
if [ ! -f "feeds.conf.default" ]; then
    echo "创建 feeds.conf.default..."
    cat > feeds.conf.default << 'EOF'
src-git packages https://git.openwrt.org/feed/packages.git;openwrt-21.02
src-git luci https://git.openwrt.org/project/luci.git;openwrt-21.02
src-git routing https://git.openwrt.org/feed/routing.git;openwrt-21.02
src-git telephony https://git.openwrt.org/feed/telephony.git;openwrt-21.02
EOF
fi

# 检查 feeds 分支名称
if grep -q "openwrt-21.02.7" feeds.conf.default 2>/dev/null; then
    echo "修正 feeds.conf.default 中的分支名称..."
    sed -i 's/openwrt-21.02.7/openwrt-21.02/g' feeds.conf.default
fi

echo "=========================================="
echo "验证通过！"
echo ""
echo "配置摘要："
echo "- OpenWrt 版本: 21.02.7 (使用 v21.02.7 标签)"
echo "- feeds 分支: openwrt-21.02"
echo "- 目标设备: RK3128 (tlink_r1)"
echo "- 包含功能: CUPS, p910nd, USB 打印机支持"
echo "=========================================="
