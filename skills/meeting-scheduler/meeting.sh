#!/bin/bash
#
# 📅 Meeting Scheduler - 智能日程管理脚本
# 支持一次性会议、周期性会议、多渠道提醒
#

set -e

# 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="$SCRIPT_DIR/meetings.json"
CONF_FILE="$SCRIPT_DIR/meeting.conf"

# 默认配置
NOTIFY_CHANNEL="${NOTIFY_CHANNEL:-wecom}"
DEFAULT_REMINDER="${DEFAULT_REMINDER:-15}"
TIMEZONE="${TIMEZONE:-Asia/Shanghai}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 初始化数据文件
init_data() {
    if [[ ! -f "$DATA_FILE" ]]; then
        echo '{"meetings":[],"last_id":0}' > "$DATA_FILE"
    fi
}

# 生成唯一ID
generate_id() {
    local last_id=$(jq -r '.last_id' "$DATA_FILE")
    local new_id=$((last_id + 1))
    jq --argjson id "$new_id" '.last_id = $id' "$DATA_FILE" > tmp.json && mv tmp.json "$DATA_FILE"
    printf "%03d" "$new_id"
}

# 添加会议
cmd_add() {
    local time="$1"
    local title="$2"
    local repeat=""
    local reminder="$DEFAULT_REMINDER"
    local location=""
    local weekday=""
    local month_day=""

    shift 2
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --repeat)
                repeat="$2"
                shift 2
                ;;
            --reminder)
                reminder="$2"
                shift 2
                ;;
            --location)
                location="$2"
                shift 2
                ;;
            --weekday)
                weekday="$2"
                shift 2
                ;;
            --day)
                month_day="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    # 处理时间格式
    if [[ ! "$time" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
        # 只有时间，添加今天的日期
        local today=$(date +%Y-%m-%d)
        time="$today $time"
    fi

    local id=$(generate_id)
    local created_at=$(date -Iseconds)

    # 构建会议对象
    local meeting=$(cat <<EOF
{
    "id": "$id",
    "title": "$title",
    "time": "$time",
    "repeat": "$repeat",
    "reminder": $reminder,
    "location": "$location",
    "weekday": "$weekday",
    "month_day": "$month_day",
    "created_at": "$created_at",
    "enabled": true
}
EOF
)

    # 添加到数据文件
    local temp_file=$(mktemp)
    jq --argjson meeting "$meeting" '.meetings += [$meeting]' "$DATA_FILE" > "$temp_file" && mv "$temp_file" "$DATA_FILE"

    echo -e "${GREEN}✓${NC} 已添加会议: $title"
    echo "  时间: $time"
    echo "  提醒: 提前 $reminder 分钟"
    [[ -n "$repeat" ]] && echo "  重复: $repeat"
    [[ -n "$location" ]] && echo "  地点: $location"
    echo "  ID: $id"
}

# 列出会议
cmd_list() {
    local filter="${1:-today}"
    local meetings=$(jq -r '.meetings[]' "$DATA_FILE")
    
    echo -e "${BLUE}📅 会议列表${NC}"
    echo "─────────────────────────────────"
    
    local count=0
    while IFS= read -r meeting; do
        [[ -z "$meeting" ]] && continue
        
        local id=$(echo "$meeting" | jq -r '.id')
        local title=$(echo "$meeting" | jq -r '.title')
        local time=$(echo "$meeting" | jq -r '.time')
        local location=$(echo "$meeting" | jq -r '.location')
        local repeat=$(echo "$meeting" | jq -r '.repeat')
        
        # 过滤
        if [[ "$filter" == "today" ]]; then
            local today=$(date +%Y-%m-%d)
            [[ ! "$time" =~ ^$today ]] && continue
        fi
        
        echo -e "${YELLOW}$id${NC}    $time    $title"
        [[ -n "$location" ]] && echo "      📍 $location"
        [[ -n "$repeat" && "$repeat" != "null" ]] && echo "      🔄 $repeat"
        
        count=$((count + 1))
    done <<< "$meetings"
    
    echo "─────────────────────────────────"
    echo "共 $count 个会议"
}

# 删除会议
cmd_delete() {
    local id="$1"
    
    local temp_file=$(mktemp)
    if jq --arg id "$id" '(.meetings[] | select(.id == $id)) | .enabled = false' "$DATA_FILE" > "$temp_file" 2>/dev/null; then
        mv "$temp_file" "$DATA_FILE"
        echo -e "${GREEN}✓${NC} 已删除会议 ID: $id"
    else
        echo -e "${RED}✗${NC} 未找到会议 ID: $id"
        rm -f "$temp_file"
    fi
}

# 检查需要提醒的会议
cmd_check() {
    local now=$(date +%s)
    local meetings=$(jq -r '.meetings[]' "$DATA_FILE")
    
    while IFS= read -r meeting; do
        [[ -z "$meeting" ]] && continue
        
        local enabled=$(echo "$meeting" | jq -r '.enabled')
        [[ "$enabled" != "true" ]] && continue
        
        local id=$(echo "$meeting" | jq -r '.id')
        local title=$(echo "$meeting" | jq -r '.title')
        local time=$(echo "$meeting" | jq -r '.time')
        local reminder=$(echo "$meeting" | jq -r '.reminder')
        
        # 计算提醒时间
        local meeting_ts=$(date -d "$time" +%s 2>/dev/null) || continue
        local remind_ts=$((meeting_ts - reminder * 60))
        
        # 检查是否需要提醒
        if [[ $now -ge $remind_ts && $now -lt $meeting_ts ]]; then
            local mins_left=$(( (meeting_ts - now) / 60 ))
            send_notification "$title" "$mins_left 分钟" "$time"
        fi
    done <<< "$meetings"
}

# 发送通知
send_notification() {
    local title="$1"
    local subtitle="$2"
    local time="$3"
    
    case "$NOTIFY_CHANNEL" in
        wecom)
            echo "📱 企业微信通知: $title - $subtitle"
            # 这里可以添加企业微信机器人通知逻辑
            ;;
        telegram)
            echo "📱 Telegram 通知: $title - $subtitle"
            ;;
        *)
            echo "📱 通知: $title - $subtitle"
            ;;
    esac
}

# 显示帮助
cmd_help() {
    cat <<EOF
📅 Meeting Scheduler - 智能日程管理

用法:
    $(basename $0) add <时间> <标题> [选项]
    $(basename $0) list [today|all]
    $(basename $0) delete <ID>
    $(basename $0) check
    $(basename $0) help

示例:
    $(basename $0) add "2026-03-05 10:00" "团队周会"
    $(basename $0) add "09:00" "每日站会" --repeat daily
    $(basename $0) list today
    $(basename $0) delete 001

选项:
    --repeat <daily|weekly|monthly>    重复周期
    --reminder <分钟>                   提前提醒时间
    --location <地点>                   会议地点
    --weekday <0-6>                    周几 (0=周日)
    --day <1-31>                       每月几号
EOF
}

# 主程序
main() {
    init_data
    
    local cmd="${1:-help}"
    shift || true
    
    case "$cmd" in
        add)
            cmd_add "$@"
            ;;
        list)
            cmd_list "$@"
            ;;
        delete)
            cmd_delete "$@"
            ;;
        check)
            cmd_check
            ;;
        help|--help|-h)
            cmd_help
            ;;
        *)
            echo -e "${RED}未知命令: $cmd${NC}"
            cmd_help
            exit 1
            ;;
    esac
}

main "$@"
