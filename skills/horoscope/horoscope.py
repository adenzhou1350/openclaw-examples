#!/usr/bin/env python3
"""
星座运势查询脚本
支持 12 星座的每日运势查询
"""

import requests
import sys
import json
from datetime import datetime

# 星座映射
CONSTELLATIONS = {
    "白羊": "aries",
    "金牛": "taurus", 
    "双子": "gemini",
    "巨蟹": "cancer",
    "狮子": "leo",
    "处女": "virgo",
    "天秤": "libra",
    "天蝎": "scorpio",
    "射手": "sagittarius",
    "摩羯": "capricorn",
    "水瓶": "aquarius",
    "双鱼": "pisces"
}

# 完整星座名称
CONSTELLATION_NAMES = {
    "aries": "白羊座",
    "taurus": "金牛座",
    "gemini": "双子座",
    "cancer": "巨蟹座",
    "leo": "狮子座",
    "virgo": "处女座",
    "libra": "天秤座",
    "scorpio": "天蝎座",
    "sagittarius": "射手座",
    "capricorn": "摩羯座",
    "aquarius": "水瓶座",
    "pisces": "双鱼座"
}

def get_horoscope(constellation: str, day: str = "today") -> dict:
    """
    获取星座运势
    
    Args:
        constellation: 星座名称（中文或英文）
        day: today, tomorrow, week
    
    Returns:
        运势数据字典
    """
    # 转换为小写并匹配
    constellation = constellation.lower()
    
    # 如果输入的是中文简称，转换为英文
    for cn, en in CONSTELLATIONS.items():
        if cn in constellation:
            constellation = en
            break
    
    # 尝试直接匹配
    if constellation not in CONSTELLATION_NAMES:
        # 尝试模糊匹配
        for en, cn in CONSTELLATION_NAMES.items():
            if constellation in cn or cn[:2] in constellation:
                constellation = en
                break
    
    try:
        # 使用免费的星座运势 API
        url = f"https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily?sign={constellation}&day={day}"
        response = requests.get(url, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            return {
                "success": True,
                "sign": CONSTELLATION_NAMES.get(constellation, constellation),
                "date": data.get("data", {}).get("date", ""),
                "horoscope": data.get("data", {}).get("horoscope", "暂无数据")
            }
        else:
            return {
                "success": False,
                "error": f"API 请求失败: {response.status_code}"
            }
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }

def format_horoscope(result: dict) -> str:
    """格式化运势输出"""
    if not result.get("success"):
        return f"❌ 查询失败: {result.get('error', '未知错误')}"
    
    sign = result.get("sign", "")
    date = result.get("date", "")
    horoscope = result.get("horoscope", "")
    
    # 解析运势文本
    lines = horoscope.split("\n")
    formatted = f"🌟 **{sign}** 今日运势 ({date})\n\n"
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
        # 简单格式化
        formatted += f"{line}\n"
    
    return formatted

def main():
    if len(sys.argv) < 2:
        # 默认输出所有星座今日运势
        print("📅 今日星座运势汇总\n")
        for cn_name in ["白羊座", "金牛座", "双子座", "巨蟹座", 
                       "狮子座", "处女座", "天秤座", "天蝎座", 
                       "射手座", "摩羯座", "水瓶座", "双鱼座"]:
            constellation = cn_name.replace("座", "")
            result = get_horoscope(constellation)
            if result.get("success"):
                # 简化输出
                horoscope = result.get("horoscope", "")
                first_line = horoscope.split("\n")[0] if horoscope else "暂无"
                print(f"• {cn_name}: {first_line}")
            else:
                print(f"• {cn_name}: 查询失败")
            print()  # 添加空行
        return
    
    constellation = sys.argv[1]
    day = sys.argv[2] if len(sys.argv) > 2 else "today"
    
    result = get_horoscope(constellation, day)
    print(format_horoscope(result))

if __name__ == "__main__":
    main()
