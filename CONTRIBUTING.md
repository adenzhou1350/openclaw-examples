# 🤝 Contributing to OpenClaw Examples

感谢你对 OpenClaw Examples 项目的兴趣！我们欢迎各种形式的贡献。

## 📋 贡献方式

### 🐛 报告 Bug
1. 检查是否已有类似问题
2. 使用清晰的问题描述
3. 提供复现步骤和环境信息

### 💡 提出新功能
1. 描述你想要的功能
2. 说明使用场景
3. 可能的实现方案

### 📖 改进文档
- 拼写修正
- 补充缺失的说明
- 翻译成其他语言

### 🔧 提交代码
1. Fork 本项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 📝 代码规范

### Shell 脚本
- 添加 shebang (`#!/bin/bash`)
- 使用 `set -e` 错误退出
- 添加执行权限 (`chmod +x`)
- 包含使用说明注释

### Python Skill
- 遵循 PEP 8
- 添加类型注解
- 包含 docstring

### Skill 结构
```
skill-name/
├── README.md          # 使用文档
├── SKILL.md           # Skill 定义
├── skill.py           # 主逻辑
└── configs/           # 配置文件
```

## 🧪 测试

提交前请确保：
- [ ] 脚本可执行且无语法错误
- [ ] 文档与代码保持同步
- [ ] README 包含使用示例

## 📄 提交信息规范

使用清晰的提交信息：
- `Add: 新增天气查询 Skill`
- `Fix: 修复定时任务错误`
- `Update: 完善文档`

## ❓ 问题解答

如有疑问，欢迎提交 Issue 或讨论。

---

⭐ 感谢你的贡献！
