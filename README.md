# RK3128 打印机服务器 OpenWrt 编译项目

## 项目说明
为索信 TP-9038 (RK3128芯片) 电视盒子编译 OpenWrt 固件，集成打印机服务器功能。

## 设备信息
- 型号：索信 TP-9038
- 芯片：Rockchip RK3128
- 内存：1GB
- 存储：8GB eMMC
- 接口：2×USB, HDMI, 网口, AV, 无线

## 包含功能
1. **打印机服务器**
   - CUPS 完整打印系统
   - p910nd 轻量级打印服务
   - USB 打印机自动检测
   - 网络打印机支持

2. **网络功能**
   - 有线网络 (RTL8169)
   - 无线网络 (RTL8188/8192)
   - DHCP 服务器
   - 防火墙基础功能

3. **管理界面**
   - LuCI 中文管理界面
   - CUPS 网页管理
   - 打印机状态监控

## 使用方法

### 1. 设置仓库
```bash
# 克隆或创建新仓库
git clone https://github.com/你的用户名/RK3128-Printer-Server.git
cd RK3128-Printer-Server

# 运行验证脚本
chmod +x verify.sh
./verify.sh
