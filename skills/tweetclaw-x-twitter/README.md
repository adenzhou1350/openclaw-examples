# TweetClaw X/Twitter 自动化示例

用 TweetClaw 给 OpenClaw Agent 添加 X/Twitter 工作流：搜索推文、搜索回复、导出关注者、查询用户、管理媒体、监控推文、接收 Webhook、抽取 Giveaway 获奖者，并在明确批准后发布推文或回复。

## 功能特性

- 🔎 **搜索推文**：按关键词、账号或活动主题查找公开推文
- 💬 **搜索回复**：分析指定推文下的用户反馈和常见问题
- 👥 **导出关注者**：整理公开关注者列表，支持后续人工筛选
- 👤 **用户查询**：读取公开资料、账号状态和基础指标
- 🖼️ **媒体工作流**：上传发布素材，下载账号相关媒体
- 🔔 **监控与 Webhook**：持续跟踪关键词、账号或活动话题
- 🎁 **Giveaway 抽奖**：按规则抽取互动用户并保留结果
- ✅ **批准后发布**：推文、回复、私信、关注、转发等可见动作先人工确认

## 安装方法

```bash
openclaw plugins install @xquik/tweetclaw
```

## 配置说明

在 OpenClaw 的本地环境中配置 Xquik API Key，不要把密钥写入仓库：

```bash
XQUIK_API_KEY=your-api-key
```

## 使用示例

### 1. 活动前调研

让 Agent 先搜索公开讨论，再汇总可用角度：

```text
用 TweetClaw 搜索最近 7 天关于 OpenClaw plugin 的推文和回复，
总结开发者最常提到的 5 个问题，并列出可回复的推文链接。
```

### 2. 发布前检查

先让 Agent 准备内容，再要求人工确认：

```text
根据这些用户问题写 3 条 X 推文草稿。
不要发布，先给我审核每条推文的目标、链接和风险点。
```

### 3. 监控上线反馈

上线后持续跟踪关键词并发送 Webhook：

```text
监控 TweetClaw、OpenClaw plugin 和 X/Twitter automation 关键词。
发现高意图问题时记录推文链接、作者、时间和建议回复。
```

## 适用场景

- 产品发布前的公开用户问题收集
- X/Twitter 内容反馈分析
- 开发者社区关键词监控
- Giveaway 活动抽奖和结果留痕
- 需要人工确认的推文和回复工作流

## 相关链接

- GitHub: https://github.com/Xquik-dev/tweetclaw
- npm: https://www.npmjs.com/package/@xquik/tweetclaw
- ClawHub: https://clawhub.ai/plugins/@xquik/tweetclaw
