# 💾 Backup Tool Skill

> 自动备份重要文件和数据，支持本地/云端存储

## 功能特性

- 📁 文件/目录备份
- ☁️ 云端存储支持 (S3/OSS/腾讯云COS)
- 🔄 增量备份
- ⏰ 定时自动备份
- 📊 备份历史记录
- 🗑️ 过期备份清理

## 使用方法

### 基础备份

```bash
# 备份单个文件
backup backup /path/to/file.txt

# 备份目录
backup backup /path/to/directory/

# 备份到云端
backup backup /data --to oss://my-bucket/

# 增量备份
backup backup /data --incremental
```

### 定时备份

```bash
# 每天凌晨2点自动备份
backup schedule --cron "0 2 * * *" --source /data --to /backup

# 每周日全量备份
backup schedule --cron "0 3 * * 0" --source /data --to /backup --full
```

### 恢复数据

```bash
# 列出可用备份
backup list

# 恢复指定备份
backup restore backup_20260304

# 恢复到指定路径
backup restore backup_20260304 --target /restored/
```

## 配置

### 环境变量

```bash
# 云存储配置 (可选)
export OSS_ENDPOINT="oss-cn-hangzhou.aliyuncs.com"
export OSS_ACCESS_KEY="your_access_key"
export OSS_ACCESS_SECRET="your_access_secret"
export OSS_BUCKET="your_bucket"

# 腾讯云COS配置
export COS_SECRET_ID="your_secret_id"
export COS_SECRET_KEY="your_secret_key"
export COS_BUCKET="your_bucket"
export COS_REGION="ap-guangzhou"
```

### 配置文件

创建 `~/.backup/config.yml`:

```yaml
backup:
  default_destination: /backup
  
retention:
  daily: 7      # 保留7天
  weekly: 4     # 保留4周
  monthly: 12   # 保留12个月
  
exclude:
  - "*.tmp"
  - "*.log"
  - "node_modules/"
  - ".git/"
```

## 备份策略建议

| 场景 | 策略 | 频率 |
|------|------|------|
| 代码仓库 | 增量 | 每日 |
| 数据库 | 全量+增量 | 每日+每小时 |
| 用户上传 | 全量 | 每周 |
| 配置文件 | 增量 | 每日 |

## 示例脚本

### 每日代码备份

```bash
#!/bin/bash
# daily-code-backup.sh

REPO_DIR="$HOME/projects"
BACKUP_DIR="/backup/code"
DATE=$(date +%Y%m%d)

# 备份所有git仓库
for repo in $REPO_DIR/*; do
    if [ -d "$repo/.git" ]; then
        backup backup "$repo" --to $BACKUP_DIR/$(basename $repo)_$DATE.tar.gz
    fi
done

echo "代码备份完成: $DATE"
```

## 技术栈

- Shell Script
- rsync (增量同步)
- tar/gzip (压缩)
- cron (定时任务)
- AWS S3 /阿里云OSS / 腾讯云COS (云存储)

## License

MIT
