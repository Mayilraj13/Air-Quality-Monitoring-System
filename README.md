Air Quality Monitoring & Prediction System

This  source files for a simple Air Quality Monitoring project using ESP32 + MQ-135, ThingSpeak, and a Django dashboard with basic prediction.

 Included files
- `esp32/air_quality.ino` - Arduino sketch for ESP32 to read MQ-135 and send data to ThingSpeak.
- `monitor/views.py` - Django app views (dashboard and API endpoint).
- `monitor/urls.py` - URL routes for the monitor app.
- `monitor/templates/dashboard.html` - Dashboard template (Bootstrap + Chart.js).
- `requirements.txt` - Python dependencies.
- `README.md` - This file.

Quick setup (Django app)
1. Create a Django project (if you don't have one):
django-admin startproject airdash_project
cd airdash_project
python manage.py startapp monitor

2. Copy the `monitor` files into the `monitor` app folder in your Django project. Create a `templates` folder inside `monitor` and place `dashboard.html` there (`monitor/templates/dashboard.html`).

3. Add `'monitor'` to `INSTALLED_APPS` in `airdash_project/settings.py` and ensure `TEMPLATES` is configured to find app templates (default Django setup works).

4. Add the app URLs to your project `urls.py`:
from django.urls import path, include

urlpatterns = [
    path('', include('monitor.urls')),
]

5. Install requirements:
pip install -r requirements.txt

6. Edit `monitor/views.py` and replace `THINGSPEAK_CHANNEL_ID` with your ThingSpeak channel ID. Also set `THINGSPEAK_RESULTS` if desired.

7. Run the server:
python manage.py runserver

8. Open `http://127.0.0.1:8000/` to see the dashboard. The page will call `/get-air-data/` to fetch data from ThingSpeak and will update every 20 seconds.

ESP32 setup
- Open `esp32/air_quality.ino` in Arduino IDE (or PlatformIO).
- Replace `YOUR_WIFI_NAME`, `YOUR_WIFI_PASSWORD`, and `YOUR_THINGSPEAK_WRITE_API_KEY`.
- Upload to ESP32, power it, and ensure data appears in your ThingSpeak channel.

Notes
- MQ-135 analog readings are scaled with a simple linear conversion in the sketch. Calibrate the sensor for accurate PPM readings.
- For better predictions replace the linear regression with ARIMA or LSTM models.
- You can extend the project with notifications, maps, and database storage.
  
  Simulation link : https://wokwi.com/projects/new/esp32

