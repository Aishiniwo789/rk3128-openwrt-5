#!/bin/bash

echo "=========================================="
echo "检查编译环境"
echo "=========================================="

echo "1. 系统信息:"
lsb_release -a
echo ""

echo "2. 内存信息:"
free -h
echo ""

echo "3. 磁盘空间:"
df -h
echo ""

echo "4. 检查 Git 标签:"
if [ -d "openwrt-source" ]; then
    cd openwrt-source
    echo "当前目录: $(pwd)"
    echo "Git 版本: $(git --version)"
    echo "当前分支: $(git branch --show-current)"
    echo "可用标签 (21.02 相关):"
    git tag -l | grep -E "21\.02" | head -10
    echo "最近的提交:"
    git log --oneline -5
    cd ..
else
    echo "测试 OpenWrt 官方仓库标签:"
    git ls-remote --tags https://github.com/openwrt/openwrt.git | grep -E "21\.02\.7|openwrt-21" | head -10
fi

echo ""
echo "5. 检查编译工具链:"
which gcc
gcc --version | head -1
echo ""

which make
make --version | head -1
echo ""

echo "6. 检查配置文件:"
if [ -f ".config" ]; then
    echo "配置摘要:"
    grep -E "CONFIG_TARGET|CONFIG_KERNEL|CONFIG_PACKAGE.*(cups|printer)" .config | head -20
else
    echo "错误: .config 文件不存在"
    exit 1
fi
