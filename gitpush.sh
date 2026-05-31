#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

git add .
git commit -m "workbook update: $(date '+%Y-%m-%d %H:%M:%S')" || true
git push
