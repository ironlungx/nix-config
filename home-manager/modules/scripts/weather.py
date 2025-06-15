import requests
from sys import argv
from datetime import datetime

sunrise_icon = ""
sunset_icon = ""


def unix_to_hm(unix_time: int) -> str:
    dt = datetime.fromtimestamp(unix_time)
    return dt.strftime("%I:%M")


wmo_weather_codes = {
    0: ("", ""),
    1: ("", ""),
    2: ("", ""),
    3: ("", ""),
    45: ("", ""),
    48: ("", ""),
    51: ("", ""),
    53: ("", ""),
    55: ("", ""),
    61: ("", ""),
    63: ("", ""),
    65: ("", ""),
    71: ("", ""),
    73: ("", ""),
    75: ("", ""),
    77: ("", ""),
    80: ("", ""),
    81: ("", ""),
    82: ("", ""),
    85: ("", ""),
    86: ("", ""),
    95: ("", ""),
    96: ("", ""),
    99: ("", ""),
}


def get_weather(latitude: str, longitude: str, fmt: str) -> str:
    url = f"https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current=temperature_2m,weather_code,is_day&forecast_days=1&daily=sunrise,sunset&timezone=GMT&timeformat=unixtime"
    data = requests.get(url).json()

    temperature = data["current"]["temperature_2m"]

    icon = ""

    if data["current"]["is_day"]:
        weather_code: int = data["current"]["weather_code"]
        icon = wmo_weather_codes[weather_code][0]
        return fmt.replace("{icon}", str(icon)).replace("{temp}", str(temperature)).replace(
            "{unit}", str(data["current_units"]["temperature_2m"])
        )
    else:
        weather_code: int = data["current"]["weather_code"]
        icon = wmo_weather_codes[weather_code][1]

        fmt.replace("{icon}", icon)
        fmt.replace("{temp}", temperature)
        fmt.replace("{unit}", data["current_units"]["temperature_2m"])

        return fmt.replace("{icon}", str(icon)).replace("{temp}", str(temperature)).replace(
            "{unit}", str(data["current_units"]["temperature_2m"])
        )


lat = argv[1]
long = argv[2]
fmt = argv[3]

print(get_weather(lat, long, fmt))
