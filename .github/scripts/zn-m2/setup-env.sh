#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> 正在清理不必要的预装环境以释放磁盘空间与内存..."
sudo rm -rf /usr/share/dotnet /opt/ghc /usr/local/share/boost "$AGENT_TOOLSDIRECTORY"

echo "==> 更新系统软件源并安装 OpenWrt 编译完整依赖..."
sudo apt-get update
sudo apt-get install -y \
  ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
  bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext \
  git git-core python3 python3-pip python3-ply python3-docutils python3-setuptools \
  haveged libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev \
  libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz mkisofs msmtp nano \
  ninja-build p7zip p7zip-full patch pkgconf python3-git python3-ply rsync \
  scons squashfs-tools subversion swig texinfo u-boot-tools upx-ucl unzip vim wget \
  xmlto zlib1g-dev rename pigz clang libfuse-dev lua5.1 liblua5.1-0-dev g++-multilib

sudo apt-get autoremove -y --purge
sudo apt-get clean
sudo timedatectl set-timezone "$TZ"

git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global user.name "$GITHUB_ACTOR"
git config --global init.defaultBranch master

sudo mkdir -p /workdir
sudo chown "$USER:$(id -gn)" /workdir
