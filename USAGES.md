# 使用示例

以下命令均从仓库根目录运行，使用 Linux / WSL 的 Bash。

## 资源检查

```bash
bash skills/system-health-check/health_check.sh
```

终端报告包含 CPU、内存、磁盘、进程数和负载。阈值在脚本开头定义，也可通过同目录 `config.sh` 设置。当前 `--json` 中的 `status` 是固定字段，请用默认模式的退出码判断阈值状态。

## 备份一个测试目录

先用临时目录验证复制和恢复，再改成自己的数据路径：

```bash
demo_dir=$(mktemp -d)
mkdir -p "$demo_dir/source"
echo hello > "$demo_dir/source/example.txt"

bash skills/backup-tool/backup.sh backup "$demo_dir/source" --to "$demo_dir/example.tar.gz" --compress
bash skills/backup-tool/backup.sh restore "$demo_dir/example.tar.gz" --target "$demo_dir/restored"
cat "$demo_dir/restored/source/example.txt"
```

预期最后输出 `hello`。当前备份实现主要是本地 `cp` / `tar`，不要把帮助文字中的增量或云端备份当作已实现能力。

## 模拟新闻简报

```bash
bash skills/news-digest/news-digest.sh --category tech
```

输出来自脚本内的固定数组，用于演示简报布局。`NEWS_API_KEY` 尚未用于抓取；若需要真实新闻，需要替换 `fetch_news` 的实现。

通知接口仅在显式传入 `--dingtalk` 或 `--telegram` 时调用，需要自己的环境变量配置。示例命令不发送通知。

[返回 README](README.md)
