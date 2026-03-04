# 📰 News Digest Skill

> 自动聚合并推送每日新闻简报

## 功能特性

- 📊 支持多类别新闻（科技、财经、体育、娱乐）
- ⏰ 支持定时自动推送
- 🎯 支持关键词过滤
- 📱 多渠道推送（钉钉、微信、Telegram）

## 使用方法

```bash
# 查看帮助
./news-digest.sh --help

# 获取今日科技新闻
./news-digest.sh --category tech

# 获取财经新闻并发送到钉钉
./news-digest.sh --category finance --dingtalk

# 定时任务配置 (每天早上 8 点)
0 8 * * * /path/to/news-digest.sh --category all --dingtalk
```

## 配置说明

在 `.env` 文件中配置：

```bash
# 钉钉机器人 Webhook
DINGTALK_WEBHOOK=https://oapi.dingtalk.com/robot/send?access_token=xxx

# Telegram Bot
TELEGRAM_BOT_TOKEN=xxx
TELEGRAM_CHAT_ID=xxx

# 新闻源 API (可选)
NEWS_API_KEY=xxx
```

## 输出示例

```
📰 每日新闻简报 - 2026年3月4日

【科技】
🔹 OpenClaw 发布新版本 v2.0，AI 助手能力大幅提升
🔹 Python 3.14 正式发布，性能提升 20%
🔹 GitHub 推出 AI 代码审查功能

【财经】
🔹 A 股三大指数今日全线上涨
🔹 比特币突破 50000 美元大关

【体育】
🔹 NBA: 湖人击败勇士，詹姆斯砍下 40 分
🔹 国足世预赛战胜韩国，保留出线希望
```

## 文件结构

```
news-digest/
├── news-digest.sh      # 主脚本
├── .env.example        # 配置示例
├── README.md           # 本文件
└── cron.example        # 定时任务示例
```
