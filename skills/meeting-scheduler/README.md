# 📅 Meeting Scheduler Skill

智能日程管理 - 支持一次性会议提醒和周期性会议安排。

## 功能特性

- ⏰ 一次性会议提醒
- 🔄 周期性会议（每天/每周/每月）
- 📱 多渠道通知（企业微信/钉钉/Telegram）
- 🕐 智能时区处理
- 🎯 会议前提醒（5分钟/15分钟/30分钟/1小时）

## 使用方法

### 基本用法

```bash
# 添加明天上午10点的会议
./meeting.sh add "2026-03-05 10:00" "团队周会"

# 添加下午3点的会议
./meeting.sh add "15:00" "项目评审"

# 查看今日会议
./meeting.sh list today

# 查看所有会议
./meeting.sh list all

# 删除会议
./meeting.sh delete <会议ID>
```

### 周期性会议

```bash
# 每天早上9点的站会
./meeting.sh add "09:00" "每日站会" --repeat daily

# 每周一上午10点的周会
./meeting.sh add "10:00" "周会" --repeat weekly --weekday 1

# 每月1号上午10点的月度总结
./meeting.sh add "10:00" "月度总结" --repeat monthly --day 1
```

### 高级选项

```bash
# 会议前30分钟提醒
./meeting.sh add "14:00" "重要会议" --reminder 30

# 设置会议地点
./meeting.sh add "10:00" "面试" --location "会议室A" --reminder 15
```

## 文件结构

```
meeting-scheduler/
├── meeting.sh          # 主脚本
├── meeting.conf        # 配置文件
├── meetings.json       # 会议数据存储
└── README.md           # 说明文档
```

## 配置

编辑 `meeting.conf` 设置：

```bash
# 通知渠道 (wecom|dingtalk|telegram)
NOTIFY_CHANNEL=wecom

# 默认提醒时间（分钟）
DEFAULT_REMINDER=15

# 时区
TIMEZONE=Asia/Shanghai
```

## 示例输出

```
$ ./meeting.sh list today

📅 今日会议 (2026-03-04)

ID       时间      会议名称        地点
─────────────────────────────────────────────
001      10:00    团队周会        会议室A
002      14:00    项目评审        线上
003      16:00    面试            会议室B
```

## 结合 Cron 使用

```bash
# 每分钟检查是否有会议需要提醒
* * * * * /path/to/meeting.sh check

# 每天早上8点发送当日日程
0 8 * * * /path/to/meeting.sh daily-summary
```

## 依赖

- `curl` - HTTP 请求
- `jq` - JSON 处理
- `at` 或 `cron` - 定时任务

## License

MIT
