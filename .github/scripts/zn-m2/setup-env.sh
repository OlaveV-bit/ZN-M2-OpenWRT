#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> 正在清理不必要的预装环境以释放磁盘空间与内存..."
sudo rm -rf /usr/share/dotnet /opt/ghc /usr/local/share/boost "$AGENT_TOOLSDIRECTORY"

echo "==> 更新系统软件源并安装 OpenWrt 编译必须的基础依赖..."
sudo apt-get update
sudo apt-get install -y \
  build-essential clang flex bison g++ gawk gcc-multilib g++-multilib \
  gettext git libncurses5-dev libssl-dev python3-distutils rsync unzip zlib1g-dev \
  file wget swig libelf-dev libfuse-dev upx subversion lua5.1 liblua5.1-0-dev rename pigz

sudo apt-get autoremove -y --purge
sudo apt-get clean
sudo timedatectl set-timezone "$TZ"

git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
git config --global init.defaultBranch master

sudo mkdir -p /workdir
sudo chown "$USER:$(id -gn)" /workdir