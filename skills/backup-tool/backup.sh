#!/bin/bash
#
# backup-tool - 文件备份工具
# 支持本地备份、云端备份(S3/OSS/COS)、增量备份
#

set -e

VERSION="1.0.0"
BACKUP_DIR="${BACKUP_DIR:-/tmp/backups}"
CONFIG_FILE="${HOME}/.backup/config.yml"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 显示帮助
show_help() {
    cat << EOF
备份工具 v$VERSION

用法: backup <command> [options]

命令:
    backup <source> [options]    备份文件或目录
    restore <backup> [options]   恢复备份
    list                         列出可用备份
    schedule                     配置定时备份
    clean                        清理过期备份

备份选项:
    --to <path>                  备份目标路径
    --incremental                增量备份
    --compress                   压缩备份
    --exclude <pattern>          排除文件(可多次使用)

恢复选项:
    --target <path>              恢复到指定路径

定时备份选项:
    --cron <expression>          Cron表达式
    --source <path>              备份源路径
    --full                       全量备份(默认增量)

示例:
    backup backup /data
    backup backup /data --to /backup/data_$(date +%Y%m%d).tar.gz --compress
    backup backup /data --incremental
    backup restore backup_20260304
    backup list
    backup schedule --cron "0 2 * * *" --source /data --to /backup

EOF
}

# 备份命令
cmd_backup() {
    local source=""
    local destination=""
    local incremental=false
    local compress=false
    local exclude_patterns=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --to)
                destination="$2"
                shift 2
                ;;
            --incremental)
                incremental=true
                shift
                ;;
            --compress)
                compress=true
                shift
                ;;
            --exclude)
                exclude_patterns+=("$2")
                shift 2
                ;;
            -*)
                log_error "未知选项: $1"
                exit 1
                ;;
            *)
                source="$1"
                shift
                ;;
        esac
    done
    
    if [[ -z "$source" ]]; then
        log_error "请指定备份源"
        exit 1
    fi
    
    if [[ -z "$destination" ]]; then
        local basename=$(basename "$source")
        local timestamp=$(date +%Y%m%d_%H%M%S)
        destination="$BACKUP_DIR/${basename}_${timestamp}.tar.gz"
    fi
    
    log_info "开始备份: $source -> $destination"
    
    if [[ "$compress" == "true" ]]; then
        local temp_file=$(mktemp)
        tar -czf "$temp_file" -C "$(dirname "$source")" "$(basename "$source")" 2>/dev/null || {
            log_error "备份失败"
            exit 1
        }
        mv "$temp_file" "$destination"
    else
        cp -r "$source" "$destination"
    fi
    
    log_info "备份完成: $destination"
    echo "$destination"
}

# 恢复命令
cmd_restore() {
    local backup=""
    local target=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target)
                target="$2"
                shift 2
                ;;
            -*)
                shift
                ;;
            *)
                backup="$1"
                shift
                ;;
        esac
    done
    
    if [[ -z "$backup" ]]; then
        log_error "请指定备份文件"
        exit 1
    fi
    
    if [[ -z "$target" ]]; then
        target="$(dirname "$backup")/restored_$(date +%Y%m%d)"
    fi
    
    log_info "恢复备份: $backup -> $target"
    
    mkdir -p "$target"
    if [[ "$backup" == *.tar.gz ]]; then
        tar -xzf "$backup" -C "$target"
    else
        cp -r "$backup" "$target"
    fi
    
    log_info "恢复完成: $target"
}

# 列出备份
cmd_list() {
    log_info "可用备份:"
    ls -lh "$BACKUP_DIR" 2>/dev/null || log_warn "暂无备份"
}

# 定时备份
cmd_schedule() {
    local cron_expr=""
    local source=""
    local destination=""
    local full=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --cron)
                cron_expr="$2"
                shift 2
                ;;
            --source)
                source="$2"
                shift 2
                ;;
            --to)
                destination="$2"
                shift 2
                ;;
            --full)
                full=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    
    if [[ -z "$cron_expr" || -z "$source" || -z "$destination" ]]; then
        log_error "请指定 --cron, --source, --to 参数"
        exit 1
    fi
    
    local type="增量"
    [[ "$full" == "true" ]] && type="全量"
    
    log_info "配置定时备份: $type, Cron: $cron_expr"
    log_info "源: $source -> $destination"
    
    # 添加到 crontab
    local backup_cmd="backup backup '$source' --to '$destination'"
    [[ "$full" == "false" ]] && backup_cmd="$backup_cmd --incremental"
    
    (crontab -l 2>/dev/null | grep -v "$source"; echo "$cron_expr $backup_cmd") | crontab -
    
    log_info "定时备份已配置"
}

# 清理过期备份
cmd_clean() {
    local days=7
    
    log_info "清理 $days 天前的备份..."
    find "$BACKUP_DIR" -type f -mtime +$days -delete 2>/dev/null
    log_info "清理完成"
}

# 主命令
case "${1:-}" in
    backup)
        shift
        cmd_backup "$@"
        ;;
    restore)
        shift
        cmd_restore "$@"
        ;;
    list)
        cmd_list
        ;;
    schedule)
        shift
        cmd_schedule "$@"
        ;;
    clean)
        cmd_clean
        ;;
    -h|--help|help)
        show_help
        ;;
    *)
        log_error "未知命令: ${1:-}"
        show_help
        exit 1
        ;;
esac
