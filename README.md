# RK3128 OpenWRT Printer Server

为RK3128电视盒子定制的OpenWRT打印机服务器固件。

## 特性
- 完整的CUPS打印机服务器
- Avahi mDNS/DNS-SD服务发现
- LuCI Web管理界面
- 优化的USB打印机支持
- 针对2GB内存优化

## 使用方法

### GitHub Actions云编译
1. Fork这个仓库
2. 进入 `Actions` 标签页
3. 选择 `Build OpenWRT for RK3128 Printer Server`
4. 点击 `Run workflow`，选择21.02.3版本
5. 等待60-90分钟
6. 在 `Artifacts` 中下载固件

### 刷写步骤
1. 进入MaskROM模式：短接闪存CLK和GND引脚
2. 使用RKDevTool刷写固件
3. 首次启动访问：http://192.168.1.1
4. 打印机管理：http://192.168.1.1:631

## 支持的打印机
- 所有USB接口打印机
- 网络打印机（IPP协议）
- 大多数主流品牌打印机
