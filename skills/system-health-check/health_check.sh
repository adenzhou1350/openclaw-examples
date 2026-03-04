#!/bin/bash
# =============================================================================
# 🏥 System Health Check Script
# =============================================================================
# 监控系统关键指标并生成健康报告
# 作者: OpenClaw
# 版本: 1.0.0
# =============================================================================

set -e

# 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.sh"

# 默认阈值
WARN_CPU=70
CRIT_CPU=90
WARN_MEM=80
CRIT_MEM=95
WARN_DISK=75
CRIT_DISK=90

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 加载配置（如果存在）
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# 显示帮助
show_help() {
    cat << EOF
🏥 系统健康检查工具

用法: $(basename $0) [选项]

选项:
    --cpu       仅检查 CPU
    --memory    仅检查内存
    --disk      仅检查磁盘
    --quiet     静默模式（仅返回状态码）
    --json      JSON 格式输出
    --help      显示帮助

示例:
    $(basename $0)              # 完整检查
    $(basename $0) --quiet      # 静默模式
    $(basename $0) --cpu        # 仅 CPU
    $(basename $0) --json       # JSON 输出
EOF
    exit 0
}

# 获取 CPU 使用率
check_cpu() {
    local cpu_usage
    if command -v top &> /dev/null; then
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')
    elif command -v mpstat &> /dev/null; then
        cpu_usage=$(mpstat 1 1 | awk '/Average/ {print 100-$NF}')
    else
        # 备用方法：读取 /proc/stat
        local cpu_line=$(head -1 /proc/stat)
        local cpu_values=($cpu_line)
        local total=0
        local idle=0
        for i in {1..7}; do
            total=$((total + ${cpu_values[$i]}))
        done
        idle=${cpu_values[4]}
        cpu_usage=$((100 - idle * 100 / total))
    fi
    echo ${cpu_usage:-0}
}

# 获取内存使用率
check_memory() {
    local mem_usage
    if command -v free &> /dev/null; then
        local total=$(free -m | awk '/^Mem:/{print $2}')
        local used=$(free -m | awk '/^Mem:/{print $3}')
        mem_usage=$((used * 100 / total))
    else
        mem_usage=0
    fi
    echo ${mem_usage:-0}
}

# 获取磁盘使用率
check_disk() {
    local disk_usage
    disk_usage=$(df -h / | awk 'NR==2 {print int($5)}')
    echo ${disk_usage:-0}
}

# 获取运行进程数
check_processes() {
    local processes
    processes=$(ps aux | wc -l)
    echo $((processes - 1))
}

# 获取系统负载
check_load() {
    local load
    load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')
    echo ${load:-0}
}

# 检查单指标并返回状态
check_metric() {
    local value=$1
    local warn=$2
    local crit=$3
    local name=$4
    
    if [ "$value" -ge "$crit" ]; then
        echo -e "${RED}[❌]${NC} $name: ${value}% (严重)"
        return 2
    elif [ "$value" -ge "$warn" ]; then
        echo -e "${YELLOW}[⚠️]${NC} $name: ${value}% (警告)"
        return 1
    else
        echo -e "${GREEN}[✓]${NC} $name: ${value}%"
        return 0
    fi
}

# 完整健康检查
run_health_check() {
    local cpu=$(check_cpu)
    local mem=$(check_memory)
    local disk=$(check_disk)
    local procs=$(check_processes)
    local load=$(check_load)
    
    echo "========================================"
    echo "🏥 系统健康检查报告"
    echo "========================================"
    echo "检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "主机: $(hostname)"
    echo ""
    
    # 检查各项指标
    local cpu_status=0
    local mem_status=0
    local disk_status=0
    
    check_metric "$cpu" "$WARN_CPU" "$CRIT_CPU" "CPU 使用率" || cpu_status=$?
    check_metric "$mem" "$WARN_MEM" "$CRIT_MEM" "内存使用率" || mem_status=$?
    check_metric "$disk" "$WARN_DISK" "$CRIT_DISK" "磁盘使用率" || disk_status=$?
    
    echo ""
    echo "📊 进程信息:"
    echo "   运行进程: $procs"
    echo "   系统负载: $load"
    echo ""
    echo "========================================"
    
    # 总体状态
    local total_status=$((cpu_status + mem_status + disk_status))
    if [ $total_status -eq 0 ]; then
        echo -e "总体状态: ${GREEN}✅ 健康${NC}"
        return 0
    elif [ $total_status -le 2 ]; then
        echo -e "总体状态: ${YELLOW}⚠️ 需要关注${NC}"
        return 1
    else
        echo -e "总体状态: ${RED}❌ 异常${NC}"
        return 2
    fi
}

# JSON 格式输出
json_output() {
    local cpu=$(check_cpu)
    local mem=$(check_memory)
    local disk=$(check_disk)
    local procs=$(check_processes)
    local load=$(check_load)
    
    cat << EOF
{
    "timestamp": "$(date -Iseconds)",
    "hostname": "$(hostname)",
    "cpu": $cpu,
    "memory": $mem,
    "disk": $disk,
    "processes": $procs,
    "load": $load,
    "status": "healthy"
}
EOF
}

# 主程序
main() {
    local quiet=false
    local json=false
    local check_type="all"
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --cpu)
                check_type="cpu"
                shift
                ;;
            --memory)
                check_type="memory"
                shift
                ;;
            --disk)
                check_type="disk"
                shift
                ;;
            --quiet)
                quiet=true
                shift
                ;;
            --json)
                json=true
                shift
                ;;
            --help|-h)
                show_help
                ;;
            *)
                echo "未知选项: $1"
                show_help
                ;;
        esac
    done
    
    if [ "$json" = true ]; then
        json_output
        exit 0
    fi
    
    if [ "$quiet" = true ]; then
        local cpu=$(check_cpu)
        local mem=$(check_memory)
        local disk=$(check_disk)
        
        if [ "$cpu" -ge "$CRIT_CPU" ] || [ "$mem" -ge "$CRIT_MEM" ] || [ "$disk" -ge "$CRIT_DISK" ]; then
            exit 2
        elif [ "$cpu" -ge "$WARN_CPU" ] || [ "$mem" -ge "$WARN_MEM" ] || [ "$disk" -ge "$WARN_DISK" ]; then
            exit 1
        fi
        exit 0
    fi
    
    run_health_check
}

main "$@"
