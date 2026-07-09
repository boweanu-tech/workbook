#!/usr/bin/env bash
set -euo pipefail

REMOTE="origin"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

if [ "$BRANCH" = "HEAD" ]; then
  echo "ERROR: detached HEAD なので中止します。"
  exit 1
fi

echo "WARNING: ローカルの変更を破棄して、${REMOTE}/${BRANCH} の内容で上書きします。"
echo "Branch: ${BRANCH}"
sleep 2

git fetch --prune "$REMOTE"
git reset --hard "$REMOTE/$BRANCH"

# 未追跡ファイルも消す場合は有効化
# 例: 手元だけの .tex, .pdf, 一時ファイルなども消えます
# git clean -fd

git status --short
echo "Done: ${REMOTE}/${BRANCH} に強制同期しました。"
