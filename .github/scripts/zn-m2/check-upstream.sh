#!/bin/bash
set -euo pipefail
SHOULD_BUILD=false

# 获取 vernesong/OpenClash 仓库 master 分支的最新 Commit SHA
LATEST_COMMIT=$(git ls-remote https://github.com/vernesong/OpenClash.git master | awk '{print $1}')

# 获取你本地记录的上一次编译时的 commit（可以保存在一个 file 里，或者通过 API 比对）
# 这里简化：如果你希望只要上游有新提交就编译，或者通过 Github Actions 缓存比对：
echo "Upstream OpenClash master commit: $LATEST_COMMIT"

# 如果你想简单粗暴每次定时/手动触发都保持最新，也可以直接标记为 true
SHOULD_BUILD=true

echo "should_build=$SHOULD_BUILD" >> "$GITHUB_OUTPUT"
echo "LATEST_COMMIT=$LATEST_COMMIT" >> "$GITHUB_ENV"
