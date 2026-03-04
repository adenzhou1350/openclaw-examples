# 📊 Monitor Skill

服务器/系统监控告警 Skill。

## 功能

- CPU/内存/磁盘使用率监控
- 进程监控
- 自定义告警阈值
- 多通道告警通知

## 使用方法

```bash
# 添加 crontab 任务
*/5 * * * * /path/to/scripts/monitor.sh

# 或使用内置命令
用户: 检查服务器状态
Bot: 📊 服务器状态
    
    CPU: 45%
    内存: 6.2GB / 16GB (38%)
    磁盘: 120GB / 500GB (24%)
    
    运行时间: 15天3小时
    负载: 0.52, 0.48, 0.51
```

## 配置

在 `configs/monitor.yaml` 中配置：

```yaml
thresholds:
  cpu: 80      # CPU 告警阈值
  memory: 90   # 内存告警阈值
  disk: 85     # 磁盘告警阈值

alerts:
  - type: email
    to: admin@example.com
  - type: dingtalk
    webhook: https://oapi.dingtalk.com/...
```

## 告警示例

```
🚨 服务器告警

CPU 使用率: 92% (阈值: 80%)
时间: 2026-03-04 10:30
主机: my-server
```
