#!/usr/bin/env bash
# 启动已编译并安装好的 FreeCADCT（基于 pixi/conda 环境）
#   ./run-freecad.sh            启动图形界面
#   ./run-freecad.sh 文件.FCStd 用 FreeCADCT 打开文件
#   FREECAD_BIN=FreeCADCmd ./run-freecad.sh 脚本.py   无界面执行脚本
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_DIR="$ROOT/.pixi/envs/default"
BIN="${FREECAD_BIN:-FreeCAD}"

if [[ ! -x "$ENV_DIR/bin/$BIN" ]]; then
  echo "找不到 $ENV_DIR/bin/$BIN" >&2
  echo "请先构建：pixi run configure-release && pixi run build-release && pixi run install-release" >&2
  exit 1
fi

exec "$ENV_DIR/bin/$BIN" "$@"
