# 兆能 M2 (ZN-M2) OpenWrt 云编译项目

[![Build Status](https://img.shields.io/github/actions/workflow/status/你的用户名/你的仓库名/zn-m2.yml?label=ZN-M2%20Build&style=flat-square)](../../actions/workflows/zn-m2.yml)
[![Latest Release](https://img.shields.io/github/v/release/你的用户名/你的仓库名?label=OpenClash%20Release&style=flat-square)](../../releases)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-21.02%20(IPQ6000)-blue?style=flat-square)](https://github.com/openwrt-fork/sdf8057-ipq6000)

本项目基于 GitHub Actions 自动化云编译 **兆能 M2 (ZN-M2 / IPQ6000)** 专属 OpenWrt 固件，深度集成最新主线版 **OpenClash**、高通 **QCA NSS 硬件加速** 以及常用网络运维工具，支持每日定时自动追踪上游更新并发布至 GitHub Releases。

---

## 目录

- [核心特性](#核心特性)
- [仓库目录结构](#仓库目录结构)
- [预装插件与内核特性](#预装插件与内核特性)
- [自动化编译流程说明](#自动化编译流程说明)
- [如何部署到自己的仓库 (Fork 指南)](#如何部署到自己的仓库-fork-指南)
- [固件下载与刷机教程](#固件下载与刷机教程)
- [二次开发与自定义配置](#二次开发与自定义配置)
- [上游源码与致谢](#上游源码与致谢)

---

## 核心特性

1. **完整高通 NSS 硬件加速**：
   - 基于 `sdf8057-ipq6000` (OpenWrt 21.02 / Linux 4.4.60 内核) 源码树，完整编译并启用 `kmod-qca-nss-drv`、`kmod-qca-nss-ecm` 与 `kmod-qca-nss-crypto`，充分发挥 IPQ6000 芯片的硬件转发与加解密性能。
2. **深度定制最新 OpenClash**：
   - 自动拉取 `vernesong/OpenClash` 的 `master` 主线分支，并自动将编译环境中的 Golang 替换升级为 `22.x`，彻底解决旧版源码树无法编译最新 Clash/Mihomo 内核依赖的问题。
   - 针对 Linux 4.4.60 (`fw3`) 防火墙完整集成透明代理所需全部底层模块（`iptables-mod-tproxy`、`iptables-mod-socket`、`kmod-tun`、`chinadns-ng` 等），开箱即用。
   - 编译阶段自动清理源码与版本号中的 `-beta` 尾缀，生成的 GitHub Release Tag 自动与当前集成的 OpenClash 版本号保持一致。
3. **冷启动 / 重启网络握手修复**：
   - 内置自启动守护服务 `/etc/init.d/network_fix`，在系统启动完成后延迟 5 秒执行 `ifup lan`，解决 IPQ6000 平台冷启动或重启时网口 PHY 握手较慢导致客户端偶尔无法通过 DHCP 获取 IP 的痛点。
4. **精细化云编译优化**：
   - 自动清理 GitHub Actions 宿主机冗余组件以释放磁盘空间，避免爆盘失败。
   - 配置动态 `ccache` 缓存键隔离机制，兼顾编译速度与最新源码纯净度。
   - 发布成功后自动清理 3 天前的历史 Workflow 构建记录。

---

## 仓库目录结构

```text
.
├── .github/
│   ├── workflows/
│   │   └── zn-m2.yml               # GitHub Actions 自动化编译与 Release 发布工作流
│   └── scripts/zn-m2/
│       ├── check-upstream.sh       # 上游 OpenClash 仓库最新 Commit 检查脚本
│       ├── setup-env.sh            # Ubuntu 22.04 编译宿主机空间清理与全量依赖安装
│       ├── organize-firmware.sh    # 清理无关产物、过滤 *-basic* 固件并整理发布目录
│       └── generate-release.sh     # 解析 manifest 提取 OpenClash 版本并生成 Release 说明
├── config/
│   └── zn-m2.config                # 兆能 M2 硬件驱动、内核模块与软件包精简配置文件 (.config)
├── scripts/zn-m2/
│   ├── diy-part1.sh                # feeds update 前执行：锁定 OpenClash master 源并清理旧缓存
│   ├── diy-part2.sh                # feeds install 时执行：升级 Go 22.x 并解决包冲突
│   └── diy-part3.sh                # 配置加载后执行：修改系统版本标识、去 beta 后缀、注入网络修复脚本
└── feeds.conf.default              # 自定义 OpenWrt 软件源列表 (packages/luci/routing/telephony/openclash)
```

---

## 预装插件与内核特性

| 分类 | 包含组件 / 功能说明 |
| :--- | :--- |
| **硬件加速** | `kmod-qca-nss-drv`、`kmod-qca-nss-ecm`、`kmod-qca-nss-crypto` |
| **科学上网** | `luci-app-openclash` (Master 主线)、`chinadns-ng`、完整 `iptables` TPROXY / TUN 内核模块 |
| **网络功能** | 动态域名解析 `luci-app-ddns`（含阿里云、DNSPod 插件）、`luci-app-upnp`、链路聚合 `luci-proto-bonding`、网络唤醒 `etherwake`、ARP 绑定 `luci-app-arpbind` |
| **系统工具** | ZRAM 内存压缩 `zram-swap`、网页文件传输 `luci-app-filetransfer`、`bash`、`curl`、`wget-ssl`、`htop`、`tcping`、`screen`、`nano`、`unzip` |
| **外观主题** | `luci-theme-argon`、`luci-theme-design`（已将 Design 主题顶部快捷代理入口默认重定向至 OpenClash） |

---

## 如何部署到自己的仓库 (Fork 指南)

如果你希望使用自己的 GitHub 账号托管并自动编译此固件：

1. 点击本仓库右上角的 **Fork** 将项目复刻到你的账号下（或新建仓库上传上述全部文件）。
2. 进入你仓库的 **Settings -> Actions -> General**：
   - 在 **Workflow permissions** 栏勾选 **Read and write permissions**，点击 **Save**（否则编译完成后无法自动创建 Release）。
3. 进入仓库顶部的 **Actions** 选项卡：
   - 启用 Workflows（如果是 Fork 的仓库需手动点击绿色启用按钮）。
   - 在左侧列表中选择 **zn-m2 build**，点击右侧的 **Run workflow** 即可立即开始首次云编译（全程约需 40~70 分钟）。

---

## 固件下载与刷机教程

### 1. 获取固件
前往本仓库右侧的 **[Releases](../../releases)** 页面，下载最新版本中的固件文件（通常为 `*-squashfs-nand-sysupgrade.bin` 或 `*-squashfs-nand-factory.bin`）。

### 2. 刷写方式
- **情况 A：路由器已刷入第三方 U-Boot（推荐）**
  1. 拔掉路由器电源，按住机身 `Reset` 键不放再插上电源，等待约 5~8 秒指示灯闪烁后松开。
  2. 电脑网线连接路由器任意 LAN 口，浏览器访问 U-Boot 后台（常见为 `192.168.1.1`）。
  3. 上传下载好的 `*-sysupgrade.bin` 或 `*-factory.bin` 固件，点击更新并等待设备自动重启完成。
- **情况 B：路由器当前已是 OpenWrt 系统**
  1. 登录 OpenWrt 后台，进入 **系统 -> 备份/升级**。
  2. 在“刷写新的固件”处上传 `*-sysupgrade.bin`。
  3. **强烈建议取消勾选“保留配置”**，避免不同源码分支之间的配置残留导致网络异常。

### 3. 默认后台信息
- **默认管理 IP**：`192.168.1.1`（具体以源码默认配置或你自定义的 `files/` 为准）
- **默认用户名**：`root`
- **默认密码**：`password`（若无法登录请尝试留空直接回车，首次进入后台后请及时修改密码）

---

## 上游源码与致谢

- **OpenWrt IPQ6000 源码**：[openwrt-fork/sdf8057-ipq6000](https://github.com/openwrt-fork/sdf8057-ipq6000)
- **OpenClash 插件**：[vernesong/OpenClash](https://github.com/vernesong/OpenClash)
- **Golang 依赖维护**：[sbwml/packages_lang_golang](https://github.com/sbwml/packages_lang_golang)
- **Workflow 清理工具**：[ophub/delete-releases-workflows](https://github.com/ophub/delete-releases-workflows)

---

> **免责声明**：本项目仅供个人学习、研究与网络技术交流使用，请严格遵守当地法律法规，切勿用于任何非法用途。刷机存在一定风险，操作前请做好原厂固件与重要数据备份。
