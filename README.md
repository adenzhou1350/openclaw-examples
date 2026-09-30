# OpenClaw Examples 🦞

一些可以拆开阅读、改成自己版本的自动化小例子：资源检查、提醒、文件备份和简报模板。

这个仓库同时包含脚本和场景说明。下面标出了可执行入口，以及哪些仍然只是模板。

## 先运行一个不用 API key 的例子

需要 Linux / WSL、Bash 和常见系统工具。

```bash
git clone https://github.com/adenzhou1350/openclaw-examples.git
cd openclaw-examples
bash skills/system-health-check/health_check.sh --help
bash skills/system-health-check/health_check.sh
```

它会输出资源使用情况和阈值提示。退出码 `0` 表示正常、`1` 表示需要关注、`2` 表示异常，适合接到自己的调度脚本中。

## 选一个例子

| 例子 | 入口 | 当前范围 |
| --- | --- | --- |
| 资源检查 | [system-health-check](skills/system-health-check) | Linux 资源检查与终端报告 |
| 定时提醒 | [reminder.sh](skills/reminder/reminder.sh) | 直接运行或接 cron；未设 Webhook 时打印到终端 |
| 本地备份 | [backup.sh](skills/backup-tool/backup.sh) | 本地复制或 tar.gz 压缩、恢复、列出备份 |
| 新闻简报 | [news-digest.sh](skills/news-digest/news-digest.sh) | **固定模拟数据**，演示排版和通知流程，未接入真实新闻 API |
| 会议安排 | [meeting.sh](skills/meeting-scheduler/meeting.sh) | 本地脚本示例，配置见同目录文件 |
| AI 写作 / SEO / 天气等 | [skills](skills) | 部分目录仅有说明文档，需自行补实现 |

## 两个简单用法

```bash
# 没有 REMINDER_WEBHOOK 时只输出，不发送消息
REMINDER_MESSAGE="站起来活动一下" bash skills/reminder/reminder.sh

# 演示简报内容；里面的标题不是实时新闻
bash skills/news-digest/news-digest.sh --category tech
```

更多可复制步骤见 [使用示例](USAGES.md)。脚本可以独立运行，接到 OpenClaw 时请按宿主的技能格式配置；仅有 README 的目录不会自动成为可调用的 Skill。

Webhook 和 token 从本地环境变量读取。可参考 [新闻简报配置模板](skills/news-digest/.env.example)，不要把真实值写入仓库。

欢迎分享你跑通的用法，或补一个包含输入、输出和依赖说明的小例子。见 [贡献说明](CONTRIBUTING.md)。

[MIT License](LICENSE)
