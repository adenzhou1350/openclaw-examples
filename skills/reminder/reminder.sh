#!/bin/bash
# ========================================
# ⏰ OpenClaw Reminder Script
# 定时提醒脚本 - 支持一次性/周期性提醒
# ========================================

# 配置区域
REMINDER_MESSAGE="${REMINDER_MESSAGE:-💧 该喝水了！}"
REMINDER_WEBHOOK="${REMINDER_WEBHOOK:-}"
REMINDER_TITLE="${REMINDER_TITLE:-⏰ 提醒}"

# 日志
LOG_FILE="/tmp/openclaw-reminder.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 发送提醒（支持钉钉/飞书 Webhook）
send_reminder() {
    local msg="$1"
    local webhook="$2"
    
    if [ -z "$webhook" ]; then
        # 没有 webhook 时直接输出
        log "📢 提醒: $msg"
        return
    fi
    
    # 钉钉/飞书格式
    local payload="{\"msgtype\": \"text\", \"text\": {\"content\": \"$msg\"}}"
    
    curl -s -X POST "$webhook" \
        -H "Content-Type: application/json" \
        -d "$payload" >> "$LOG_FILE" 2>&1
    
    log "✅ 提醒已发送: $msg"
}

# 主程序
main() {
    log "🚀 提醒任务开始"
    
    # 构建完整消息
    local full_message="${REMINDER_TITLE}\n\n${REMINDER_MESSAGE}\n\n⏰ $(date '+%Y-%m-%d %H:%M:%S')"
    
    # 发送提醒
    send_reminder "$full_message" "$REMINDER_WEBHOOK"
    
    log "✨ 任务完成"
}

# 直接运行
main "$@"

# 使用说明：
# 1. 设置环境变量: export REMINDER_MESSAGE="喝水啦"
# 2. 配置 cron: crontab -e
# 3. 示例: 0 * * * * /path/to/reminder.sh  # 每小时提醒
