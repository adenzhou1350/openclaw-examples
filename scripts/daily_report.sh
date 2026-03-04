#!/bin/bash
# ========================================
# 🌅 OpenClaw 每日早报脚本
# 每天早上自动生成天气 + 星座运势
# ========================================

# 配置
OUTPUT_DIR="/tmp/daily-report"
DATE=$(date '+%Y-%m-%d')
REPORT_FILE="${OUTPUT_DIR}/report-${DATE}.md"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 获取天气（需要 weather skill）
get_weather() {
    echo "🌤️ 今日天气"
    echo "---"
    # 这里调用实际的天气 API
    echo "北京: 晴，8~20°C"
    echo "上海: 多云，12~18°C"
}

# 获取星座运势（需要 horoscope skill）
get_horoscope() {
    local sign="$1"
    echo "⭐ ${sign} 今日运势"
    echo "---"
    echo "整体运势: ★★★★☆"
    echo "幸运数字: 7"
    echo "幸运色: 红色"
}

# 生成报告
generate_report() {
    cat > "$REPORT_FILE" << EOF
# 📅 每日简报 - ${DATE}

## 🌤️ 天气预报
$(get_weather)

## ⭐ 今日运势（白羊座）
$(get_horoscope "白羊座")

## 📝 今日待办
- [ ] 
- [ ] 
- [ ] 

---
*由 OpenClaw 自动生成*
EOF

    echo "✅ 报告已生成: $REPORT_FILE"
    cat "$REPORT_FILE"
}

# 发送到指定渠道
send_report() {
    local webhook="$1"
    if [ -n "$webhook" ]; then
        local content=$(cat "$REPORT_FILE")
        curl -s -X POST "$webhook" \
            -H "Content-Type: application/json" \
            -d "{\"msgtype\": \"text\", \"text\": {\"content\": \"$content\"}}"
        echo "📤 报告已发送"
    fi
}

# 主程序
main() {
    echo "🚀 开始生成每日简报..."
    generate_report
    
    # 可选：发送到钉钉/飞书
    # send_report "YOUR_WEBHOOK_URL"
}

main
