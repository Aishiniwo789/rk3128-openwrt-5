#!/bin/bash

# 修复标签问题

echo "修复 OpenWrt 标签问题..."

# 方法1: 使用分支代替标签
echo "方法1: 使用 openwrt-21.02 分支"
if [ -d "openwrt-source" ]; then
    rm -rf openwrt-source
fi

git clone --depth=1 --branch openwrt-21.02 https://github.com/openwrt/openwrt.git openwrt-source

# 验证
cd openwrt-source
echo "当前分支: $(git branch --show-current)"
echo "最新提交: $(git log --oneline -1)"
echo "标签: $(git describe --tags 2>/dev/null || echo '无标签')"

# 创建正确的 feeds.conf
cat > feeds.conf.default << 'EOF'
src-git packages https://git.openwrt.org/feed/packages.git;openwrt-21.02
src-git luci https://git.openwrt.org/project/luci.git;openwrt-21.02
src-git routing https://git.openwrt.org/feed/routing.git;openwrt-21.02
src-git telephony https://git.openwrt.org/feed/telephony.git;openwrt-21.02
EOF

echo "修复完成"
