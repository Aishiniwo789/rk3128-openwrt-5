#!/bin/bash

echo "=========================================="
echo "OpenWrt 编译调试脚本"
echo "=========================================="

# 检查环境
echo "1. 检查系统架构..."
uname -a
echo ""

echo "2. 检查可用内存..."
free -h
echo ""

echo "3. 检查磁盘空间..."
df -h
echo ""

echo "4. 检查编译工具链..."
which gcc
gcc --version
echo ""

which make
make --version
echo ""

echo "5. 检查 OpenWrt 配置..."
if [ -f ".config" ]; then
    echo "找到 .config 文件"
    grep "CONFIG_TARGET" .config | head -10
else
    echo "错误: 未找到 .config 文件"
    exit 1
fi

echo ""
echo "6. 检查 feeds 配置..."
if [ -f "feeds.conf.default" ]; then
    echo "找到 feeds.conf.default 文件"
    cat feeds.conf.default
else
    echo "错误: 未找到 feeds.conf.default 文件"
    exit 1
fi

echo ""
echo "7. 检查 RK3128 设备支持..."
if [ -d "target/linux/rockchip" ]; then
    echo "找到 rockchip 目标平台"
    find target/linux/rockchip -name "*.mk" | grep -i rk3128
else
    echo "警告: 未找到 rockchip 目标平台目录"
fi

echo ""
echo "=========================================="
echo "调试信息收集完成"
echo "=========================================="
