#!/bin/bash

# ========================================
# 📰 News Digest - 每日新闻简报自动生成
# ========================================

set -e

# 配置
NEWS_API_KEY="${NEWS_API_KEY:-}"
CATEGORY="${1:-tech}"
DINGTALK_WEBHOOK="${DINGTALK_WEBHOOK:-}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 帮助信息
show_help() {
    echo -e "${BLUE}📰 News Digest - 每日新闻简报${NC}"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  --help           显示帮助"
    echo "  --category <cat> 新闻类别 (tech/finance/sports/entertainment/all)"
    echo "  --dingtalk       发送到钉钉"
    echo "  --telegram       发送到 Telegram"
    echo ""
    echo "示例:"
    echo "  $0 --category tech"
    echo "  $0 --category all --dingtalk"
    echo "  $0 --category finance --telegram"
    echo ""
}

# 获取新闻
fetch_news() {
    local category=$1
    local date=$(date +%Y-%m-%d)
    
    echo -e "${GREEN}📡 正在生成 ${category} 模拟简报...${NC}"
    
    # 模拟新闻数据 (实际使用可接入 NewsAPI)
    local news=()
    
    case $category in
        tech)
            news=("OpenClaw 发布新版本 v2.0，AI 助手能力大幅提升" "Python 3.14 正式发布，性能提升 20%" "GitHub 推出 AI 代码审查功能" "Meta 发布开源大模型 Llama 4")
            ;;
        finance)
            news=("A股三大指数今日全线上涨" "比特币突破 50000 美元大关" "央行降准释放流动性 5000 亿" "科创板 IPO 热度持续")
            ;;
        sports)
            news=("NBA: 湖人击败勇士，詹姆斯砍下 40 分" "国足以 2-1 战胜泰国" "CBA 广东队获得总冠军" "马拉松世锦赛中国选手获铜牌")
            ;;
        entertainment)
            news=("奥斯卡颁奖典礼落幕《寄生虫》获最佳影片" "周杰伦新专辑销量突破千万" "春节档电影票房创新高" "明星公益活动引发热议")
            ;;
        all)
            fetch_news "tech"
            fetch_news "finance"
            fetch_news "sports"
            return
            ;;
    esac
    
    echo ""
    echo -e "${YELLOW}【${category^^}】${NC}"
    for i in "${!news[@]}"; do
        echo "  $((i+1)). ${news[$i]}"
    done
}

# 生成简报
generate_digest() {
    local category="${CATEGORY:-tech}"
    local date=$(date +"%Y年%m月%d日")
    
    echo "========================================"
    echo -e "${BLUE}📰 模拟新闻简报 - ${date}${NC}"
    echo "========================================"
    echo ""
    
    if [ "$category" = "all" ]; then
        fetch_news "tech"
        echo ""
        fetch_news "finance"
        echo ""
        fetch_news "sports"
    else
        fetch_news "$category"
    fi
    
    echo ""
    echo "========================================"
    echo -e "${GREEN}📡 演示数据: 脚本内固定标题，非实时新闻${NC}"
    echo "========================================"
}

# 发送到钉钉
send_dingtalk() {
    local message="$1"
    
    if [ -z "$DINGTALK_WEBHOOK" ]; then
        echo -e "${RED}❌ 未配置钉钉 Webhook${NC}"
        return 1
    fi
    
    curl -s -X POST "$DINGTALK_WEBHOOK" \
        -H 'Content-Type: application/json' \
        -d "{\"msgtype\": \"text\", \"text\": {\"content\": \"$message\"}}"
    
    echo -e "${GREEN}✅ 已发送到钉钉${NC}"
}

# 发送到 Telegram
send_telegram() {
    local message="$1"
    
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo -e "${RED}❌ 未配置 Telegram${NC}"
        return 1
    fi
    
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=$message"
    
    echo -e "${GREEN}✅ 已发送到 Telegram${NC}"
}

# 主函数
main() {
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                show_help
                exit 0
                ;;
            --category)
                CATEGORY="$2"
                shift 2
                ;;
            --dingtalk)
                SEND_DINGTALK=1
                shift
                ;;
            --telegram)
                SEND_TELEGRAM=1
                shift
                ;;
            *)
                echo -e "${RED}未知参数: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 生成简报
    local digest=$(generate_digest)
    echo "$digest"
    
    # 发送通知
    if [ "$SEND_DINGTALK" = "1" ]; then
        send_dingtalk "$digest"
    fi
    
    if [ "$SEND_TELEGRAM" = "1" ]; then
        send_telegram "$digest"
    fi
}

# 执行
main "$@"
