# News Digest 示例

用固定模拟标题演示新闻简报的排版和通知流程，**不是实时新闻采集器**。

```bash
# 从仓库根目录运行，只显示模拟内容
bash skills/news-digest/news-digest.sh --category tech
```

支持 `tech`、`finance`、`sports`、`entertainment`、`all`。真实数据源需要自行替换脚本的 `fetch_news`，当前 `NEWS_API_KEY` 未被用于请求。

传入 `--dingtalk` 或 `--telegram` 才会发送通知。配置项见 [.env.example](.env.example)，由 shell 环境变量提供；脚本不会自动加载 `.env`。不要提交真实 Webhook 或 token。

定时运行示例见 [cron.example](cron.example)，请先修改为自己的路径。
