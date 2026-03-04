# 🌤️ Weather Skill

天气查询功能，支持实时天气和预报。

## 功能

- 查询当前天气
- 查询未来几天预报
- 支持多城市查询

## 使用方法

```bash
# 安装依赖
pip install requests

# 配置 API
# 在 openclaw 配置文件中添加天气 API key

# 使用示例
python scripts/weather.sh 北京
```

## 配置

需要申请天气 API（如和风天气、OpenWeatherMap 等）。

## 效果

```
用户: 北京天气
Bot: 🌤️ 北京今日天气
    温度：8~20°C
    天气：晴
    湿度：45%
    风力：东北风2级
```
