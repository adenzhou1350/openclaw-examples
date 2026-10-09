# OpenClaw Examples · 可拆开学习的自动化小例子

一些可以拆开阅读、改成自己版本的自动化小例子：资源检查、提醒、文件备份和简报模板。

这个仓库同时包含脚本和场景说明。下面标出了可执行入口，以及哪些仍然只是模板。

[运行第一个例子](#先运行一个不用-api-key-的例子) · [示例目录](#选一个例子) · [使用步骤](USAGES.md) · [作者的教学区](https://adenzhou1350.github.io/learn/)

## 先运行一个不用 API key 的例子

需要 Linux / WSL、Bash 和常见系统工具。

```bash
git clone https://github.com/adenzhou1350/openclaw-examples.git
cd openclaw-examples
bash skills/system-health-check/health_check.sh --help
bash skills/system-health-check/health_check.sh
```

它会输出资源使用情况和阈值提示。需要让脚本判断是否越过阈值时，可使用 `--quiet`：退出码 `0` 表示正常、`1` 表示警告、`2` 表示严重。下面使用 `if` 接住非零状态，不会因为告警而提前中断外层脚本：

```bash
if bash skills/system-health-check/health_check.sh --quiet; then
  echo "资源在阈值内"
else
  status=$?
  echo "检查返回 $status；请查看完整报告"
fi
```

## 选一个例子

| 例子 | 入口 | 当前范围 |
| --- | --- | --- |
| 资源检查 | [system-health-check](skills/system-health-check) | Linux 资源检查与终端报告 |
| 定时提醒 | [reminder.sh](skills/reminder/reminder.sh) | 直接运行或接 cron；未设 Webhook 时打印到终端 |
| 本地备份 | [backup.sh](skills/backup-tool/backup.sh) | 本地复制或 tar.gz 压缩、恢复、列出备份；增量与排除参数尚未实现 |
| 新闻简报 | [news-digest.sh](skills/news-digest/news-digest.sh) | **固定模拟数据**，演示排版和通知流程，未接入真实新闻 API |
| 会议安排 | [meeting.sh](skills/meeting-scheduler/meeting.sh) | 依赖 `jq` 的实验草稿；删除流程可能破坏存储结构，仅供阅读，暂不用于真实日程 |
| AI 写作 / SEO / 天气等 | [skills](skills) | 部分目录仅有说明文档，需自行补实现 |

## 两个简单用法

```bash
# 没有 REMINDER_WEBHOOK 时只输出，不发送消息
REMINDER_MESSAGE="站起来活动一下" bash skills/reminder/reminder.sh

# 演示简报内容；里面的标题不是实时新闻
bash skills/news-digest/news-digest.sh --category tech
```

更多可复制步骤见 [使用示例](USAGES.md)。脚本可以独立运行，接到 OpenClaw 时请按宿主的技能格式配置；仅有 README 的目录不会自动成为可调用的 Skill。

## 阅读与改造顺序

1. 从提醒脚本看懂「环境变量 → 内容 → 终端或 Webhook」的流程。
2. 用资源检查练习阈值和退出码，先在自己的 Linux 环境核对采样结果。
3. 再看备份、简报等例子，把模拟数据和占位实现替换为自己的需求。

资源检查的 `--json` 当前把 `status` 固定写为 `healthy`，单项选择参数也尚未作用到执行流程；做状态判断请使用 `--quiet`，不要把 JSON 的状态字段当作结论。普通报告的汇总规则与 `--quiet` 不同，单个严重指标不一定返回 `2`。这些例子适合学习与改造，尚不是统一验收的运维工具集。

Webhook 和 token 从本地环境变量读取。可参考 [新闻简报配置模板](skills/news-digest/.env.example)，不要把真实值写入仓库。

欢迎分享你跑通的用法，或补一个包含输入、输出和依赖说明的小例子。见 [贡献说明](CONTRIBUTING.md)。

## 相关入口

当前仓库侧重**独立示例与实现边界**。需要工作区配置，看 [openclaw-starter](https://github.com/adenzhou1350/openclaw-starter)；需要生成行为配置，看 [soul-generator](https://github.com/adenzhou1350/soul-generator)；需要天气早报和复盘脚本，看 [openclaw-automation](https://github.com/adenzhou1350/openclaw-automation)。

完整项目展示与技术文章见 [个人网站](https://adenzhou1350.github.io/)。

[MIT License](LICENSE)
