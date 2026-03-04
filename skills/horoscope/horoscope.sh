#!/bin/bash
# 星座运势查询命令行工具
# 用法: ./horoscope.sh [星座名称]
# 例如: ./horoscope.sh 白羊

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/horoscope.py"

if [ ! -f "$PYTHON_SCRIPT" ]; then
    echo "错误: 找不到 horoscope.py 脚本"
    exit 1
fi

# 检查 Python 和依赖
if ! command -v python3 &> /dev/null; then
    echo "错误: 需要安装 Python 3"
    exit 1
fi

if ! python3 -c "import requests" 2>/dev/null; then
    echo "正在安装依赖..."
    pip install requests
fi

# 执行查询
if [ -z "$1" ]; then
    # 无参数时显示所有星座
    python3 "$PYTHON_SCRIPT"
else
    python3 "$PYTHON_SCRIPT" "$1"
fi
