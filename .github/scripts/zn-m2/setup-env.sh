#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> 正在清理不必要的预装环境以释放磁盘空间与内存..."
sudo rm -rf /usr/share/dotnet /opt/ghc /usr/local/share/boost "$AGENT_TOOLSDIRECTORY"

echo "==> 更新系统软件源并安装 OpenWrt 编译必须的基础依赖..."
sudo apt-get update
sudo apt-get install -y \
  build-essential asciidoc binutils bcc bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python3-setuptools rsync subversion unzip zlib1g-dev libssl-dev libgmp-dev libmpc-dev libmpfr-dev file wget curl swig libelf-dev libfuse-dev upx lua5.1 liblua5.1-0-dev rename pigz clang flex bison g++-multilib

sudo apt-get autoremove -y --purge
sudo apt-get clean
sudo timedatectl set-timezone "$TZ"

git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
git config --global init.defaultBranch master

sudo mkdir -p /workdir
sudo chown "$USER:$(id -gn)" /workdir
