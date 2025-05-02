import requests
from datetime import datetime
import pytz

def get_location_info():
    try:
        response = requests.get("https://ipinfo.io/json")
        data = response.json()
        country = data.get("country", "Unknown Country")
        region = data.get("region", "Unknown Region")
        timezone = data.get("timezone", "UTC")
        return country, region, timezone
    except Exception as e:
        print("Error fetching location info:", e)
        return "Unknown", "Unknown", "UTC"

def get_current_datetime(timezone_str):
    try:
        tz = pytz.timezone(timezone_str)
        now = datetime.now(tz)
        return now
    except Exception as e:
        print("Error with timezone:", e)
        return datetime.utcnow()

if __name__ == "__main__":
    country, state, timezone = get_location_info()
    current_datetime = get_current_datetime(timezone)

    print(f"Country: {country}")
    print(f"State/Region: {state}")
    print(f"Date: {current_datetime.strftime('%Y-%m-%d')}")
    print(f"Time: {current_datetime.strftime('%H:%M:%S')}")
    print(f"Year: {current_datetime.year}")

