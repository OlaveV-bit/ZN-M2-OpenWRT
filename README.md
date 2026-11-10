# OpenWrt ZN-M2 (IPQ6000) 自动编译流程

本项目基于 GitHub Actions 实现兆能 ZN-M2 (Qualcomm IPQ6000 平台) OpenWrt 固件的定时与手动自动化编译，集成了最新的 OpenClash 核心与相关网络增强组件。

---

## 🌟 项目特性

- **自动追踪上游**：每日定时检查 [OpenClash 官方 Release](https://github.com/vernesong/OpenClash) 更新，仅在检测到新版本时触发编译，节省编译资源。
- **高性能组件**：内置 NSS 硬件加速驱动（`kmod-qca-nss-ecm` 等），适配 IPQ6000 转发加速。
- **全新 Golang 环境**：自动替换构建环境中的 Golang 至 `22.x` 分支，保障 OpenClash 及其依赖无缝编译。
- **网络连接增强**：预置开机延迟触发 LAN 口刷新脚本，解决冷启动/重启时交换机端口握手慢导致的无法获取 IP 问题。
- **现代化 UI**：内置 Argon 与 Design 主题，并自动优化菜单导航。

---

## 📂 项目目录结构

```text
.
├── .github/
│   └── workflows/
│       └── zn-m2.yml             # GitHub Actions 工作流配置文件
├── .github/scripts/zn-m2/
│   ├── check-upstream.sh         # 上游 OpenClash 版本比对脚本
│   ├── setup-env.sh              # 编译环境基础依赖安装
│   ├── organize-firmware.sh      # 固件打包与文件整理脚本
│   └── generate-release.sh       # 发布信息与 Tag 自动生成脚本
├── config/
│   └── zn-m2.config              # OpenWrt 编译配置文件 (.config)
├── scripts/zn-m2/
│   ├── diy-part1.sh              # Update feeds 前的自定义脚本
│   ├── diy-part2.sh              # Update/Install feeds 过程中的自定义脚本
│   └── diy-part3.sh              # 配置加载后的源码修正与补丁脚本
└── feeds.conf.default            # 自定义 Feeds 源设置
```

---

## 🚀 使用说明

### 1. 自动触发编译
工作流配置了每日定时任务（Cron: `23 19 * * *`，即北京时间每日 03:23）：
- 当检测到 OpenClash 有新版本时，自动启动固件编译。
- 编译完成后，会自动清理旧的 Workflow 记录，并在仓库的 **Releases** 页面发布最新固件。

### 2. 手动触发编译
1. 打开你的 GitHub 仓库页面。
2. 依次点击 **Actions** -> **zn-m2 build**。
3. 点击右侧的 **Run workflow** 按钮即可手动触发编译（手动触发将忽略上游版本检测，直接进行完整构建）。

---

## 📜 许可与致谢

- 源码上游：[openwrt-fork/sdf8057-ipq6000](https://github.com/openwrt-fork/sdf8057-ipq6000)
- 代理插件：[vernesong/OpenClash](https://github.com/vernesong/OpenClash)
- Golang 支持环境：[sbwml/packages_lang_golang](https://github.com/sbwml/packages_lang_golang)
- 脚本参考：[P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
