# 🌍 Air Quality Monitoring & Prediction System

![Python](https://img.shields.io/badge/Python-3.13%2B-blue?logo=python)
![Django](https://img.shields.io/badge/Django-5.2-green?logo=django)
![ESP32](https://img.shields.io/badge/Hardware-ESP32-darkblue?logo=espressif)
![ThingSpeak](https://img.shields.io/badge/IoT-ThingSpeak-orange)
![scikit-learn](https://img.shields.io/badge/ML-scikit--learn-yellow?logo=scikit-learn)
![License](https://img.shields.io/badge/License-MIT-lightgrey)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

A full-stack **IoT Air Quality Monitoring and Prediction System** that combines embedded hardware with a web-based analytics dashboard. An **ESP32 microcontroller** reads air quality data from an **MQ-135 gas sensor**, uploads it to **ThingSpeak IoT cloud**, and a **Django web app** fetches, visualizes, and predicts future pollution levels using **Linear Regression**.

---

## 📌 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Part 1 — ESP32 Hardware Setup](#-part-1--esp32-hardware-setup-client)
- [Part 2 — ThingSpeak Cloud Setup](#-part-2--thingspeak-cloud-setup)
- [Part 3 — Django Server Setup](#-part-3--django-server-setup)
- [Running the Application](#-running-the-application)
- [API Endpoints](#-api-endpoints)
- [Dashboard Features](#-dashboard-features)
- [Simulation](#-simulation-no-hardware-needed)
- [Common Issues & Fixes](#-common-issues--fixes)
- [Future Improvements](#-future-improvements)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

- 📡 **ESP32 + MQ-135 Sensor** — Reads ambient air quality in PPM and sends data to ThingSpeak over Wi-Fi
- ☁️ **ThingSpeak Integration** — IoT cloud storage; Django fetches the last 50 readings via REST API
- 📊 **Live Dashboard** — Bootstrap 5 + Chart.js line chart with real-time data and auto-refresh every 20 seconds
- 🤖 **ML Prediction** — scikit-learn Linear Regression predicts the next 5 air quality values
- 🟢🟡🔴 **AQI Status Card** — Classifies current PPM as Good / Moderate / Poor with color-coded alerts
- 🎨 **Colour-Zoned Chart** — Background zones (green/orange/red) visually mark safe and unsafe PPM ranges
- 🌐 **REST API Endpoint** — `/moniter/get-air-data/` returns JSON with actual + predicted values
- 🔌 **Wokwi Simulation** — Test the ESP32 sketch online without physical hardware

---

## 🛠️ Tech Stack

| Layer            | Technology                          |
|------------------|-------------------------------------|
| Microcontroller  | ESP32 (Arduino framework)           |
| Sensor           | MQ-135 Gas Sensor                   |
| IoT Cloud        | ThingSpeak                          |
| Backend          | Python 3.13, Django 5.2             |
| ML / Prediction  | scikit-learn (LinearRegression), NumPy |
| HTTP Client      | requests                            |
| Frontend         | Bootstrap 5.3, Chart.js, JS Fetch API |
| Database         | SQLite (Django default)             |
| IDE (Hardware)   | Arduino IDE / PlatformIO            |

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    HARDWARE (Client Side)                        │
│                                                                  │
│   MQ-135 Sensor ──► ESP32 ──► Wi-Fi ──► ThingSpeak Cloud        │
│   (Analog PPM)      (Arduino)           (IoT Data Storage)      │
└─────────────────────────────────────────────────────────────────┘
                                │
                    ThingSpeak REST API
                    (GET /channels/{id}/feeds.json)
                                │
┌─────────────────────────────────────────────────────────────────┐
│                    SERVER (Django Backend)                        │
│                                                                  │
│   views.py                                                       │
│   ├── dashboard()       → renders dashboard.html                 │
│   └── get_air_data()    → fetches ThingSpeak → Linear Regression │
│                           → returns JSON (actual + predicted)    │
└─────────────────────────────────────────────────────────────────┘
                                │
                         JSON Response
                                │
┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT (Browser / Frontend)                   │
│                                                                  │
│   dashboard.html                                                 │
│   ├── Status Card   → Good / Moderate / Poor (color-coded)      │
│   ├── Chart.js      → Live line chart (actual + predicted)      │
│   └── setInterval   → Auto-refresh every 20 seconds             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📂 Project Structure

```
Air-Quality-Monitoring-System/
│
├── README.md                              ← Project documentation
│
└── airquality/                            ← Django project root
    │
    ├── manage.py                          ← Django CLI entry point
    ├── db.sqlite3                         ← SQLite database
    │
    ├── airquality/                        ← Django project config
    │   ├── settings.py                    ← Installed apps, DB, templates
    │   ├── urls.py                        ← Root URL routing
    │   ├── wsgi.py                        ← WSGI entry point
    │   └── asgi.py                        ← ASGI entry point
    │
    └── moniter/                           ← Main Django app
        ├── views.py                       ← dashboard() + get_air_data() views
        ├── urls.py                        ← App URL routes
        ├── models.py                      ← (Extendable) DB models
        ├── admin.py                       ← Django admin registration
        ├── apps.py                        ← App config (MoniterConfig)
        ├── migrations/                    ← Database migrations
        └── templates/
            └── dashboard.html             ← Bootstrap + Chart.js frontend
```

---

## ✅ Prerequisites

### Software
- [Python 3.10+](https://www.python.org/downloads/)
- [pip](https://pip.pypa.io/en/stable/)
- [Git](https://git-scm.com/)
- [Arduino IDE](https://www.arduino.cc/en/software) *(for ESP32 — skip if using simulation)*

### Hardware *(optional if simulating)*
- ESP32 development board
- MQ-135 Gas Sensor
- Jumper wires + breadboard
- USB cable

### Accounts
- [ThingSpeak account](https://thingspeak.com/) — free, no credit card needed

---

## 📡 Part 1 — ESP32 Hardware Setup (Client)

### Wiring

| MQ-135 Pin | ESP32 Pin |
|------------|-----------|
| VCC        | 3.3V      |
| GND        | GND       |
| AOUT       | GPIO34 (ADC) |

### Arduino IDE Configuration

1. Open **Arduino IDE**
2. Go to **File → Preferences** and add this URL to Additional Board Manager URLs:
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```
3. Go to **Tools → Board → Boards Manager**, search `esp32`, and install **esp32 by Espressif Systems**
4. Install the **ThingSpeak** library: **Sketch → Include Library → Manage Libraries** → search `ThingSpeak`

### Configure the Sketch

Open `esp32/air_quality.ino` and replace the placeholders:

```cpp
const char* ssid     = "YOUR_WIFI_NAME";
const char* password = "YOUR_WIFI_PASSWORD";
const char* apiKey   = "YOUR_THINGSPEAK_WRITE_API_KEY";
```

### Upload

1. Select **Tools → Board → ESP32 Dev Module**
2. Select the correct COM port under **Tools → Port**
3. Click **Upload** (→)
4. Open **Serial Monitor** at 115200 baud to verify sensor readings and ThingSpeak uploads

---

## ☁️ Part 2 — ThingSpeak Cloud Setup

1. Sign up / log in at [thingspeak.com](https://thingspeak.com/)
2. Click **New Channel** and create a channel with:
   - **Field 1:** `Air Quality (PPM)`
3. Note your **Channel ID** and **Write API Key** (for the ESP32 sketch)
4. Note your **Channel ID** again for the Django `views.py` configuration (Step 3)

---

## 🖥️ Part 3 — Django Server Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Mayilraj13/Air-Quality-Monitoring-System.git
cd Air-Quality-Monitoring-System/airquality
```

### 2. Create & Activate Virtual Environment

**macOS / Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
```

**Windows (CMD):**
```cmd
python -m venv venv
venv\Scripts\activate
```

**Windows (PowerShell):**
```powershell
python -m venv venv
venv\Scripts\Activate.ps1
```

### 3. Install Dependencies

```bash
pip install --upgrade pip
pip install django requests numpy scikit-learn
```

### 4. Configure Your ThingSpeak Channel ID

Open `moniter/views.py` and replace the placeholder with your actual channel ID:

```python
# Line ~13 in views.py
url = "https://api.thingspeak.com/channels/YOUR_CHANNEL_ID/feeds.json?results=50"
#                                          ^^^^^^^^^^^^^^^^
#                                          Replace with your channel ID
```

### 5. Apply Migrations

```bash
python manage.py migrate
```

### 6. (Optional) Create Admin Superuser

```bash
python manage.py createsuperuser
```

---

## ▶️ Running the Application

```bash
python manage.py runserver
```

Server starts at: **http://127.0.0.1:8000/**

Navigate to: **http://127.0.0.1:8000/moniter/**

> The dashboard loads, calls `/moniter/get-air-data/`, displays the live chart, and auto-refreshes every **20 seconds**.

---

## 🔌 API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| `GET` | `/moniter/` | Renders the live dashboard HTML |
| `GET` | `/moniter/get-air-data/` | Returns JSON with actual and predicted air quality data |

### Sample JSON Response — `/moniter/get-air-data/`

```json
{
  "times": ["2025-01-01T10:00:00Z", "2025-01-01T10:01:00Z", "..."],
  "values": [42.5, 47.1, 53.2, "..."],
  "pred_times": ["Pred 1", "Pred 2", "Pred 3", "Pred 4", "Pred 5"],
  "pred_values": [58.4, 61.2, 64.0, 66.8, 69.6]
}
```

---

## 📊 Dashboard Features

### Status Card

| PPM Range | Status   | Color  | Description                                          |
|-----------|----------|--------|------------------------------------------------------|
| 0 – 50    | Good     | 🟢 Green | Air quality is excellent                            |
| 51 – 100  | Moderate | 🟡 Orange | Acceptable, may affect sensitive individuals       |
| 101+      | Poor     | 🔴 Red  | Unhealthy — minimize outdoor activities             |

### Chart

- **Teal line** — Actual air quality readings (last 50 from ThingSpeak)
- **Dashed red line** — Predicted next 5 values (Linear Regression)
- **Background zones** — Green (Good), Orange (Moderate), Red (Poor) shading
- **Auto-refresh** — Updates every 20 seconds automatically

---

## 🧪 Simulation (No Hardware Needed)

Test the ESP32 sketch online without any physical hardware using **Wokwi**:

👉 [https://wokwi.com/projects/new/esp32](https://wokwi.com/projects/new/esp32)

1. Create a new ESP32 project on Wokwi
2. Add an MQ-135 analog sensor component
3. Paste the `esp32/air_quality.ino` sketch code
4. Configure your Wi-Fi and ThingSpeak credentials in the simulation environment
5. Run the simulation and verify data appears in your ThingSpeak channel

---

## 🐛 Common Issues & Fixes

| Error | Solution |
|-------|----------|
| `KeyError: 'feeds'` in `get_air_data` | Channel ID in `views.py` is incorrect or ThingSpeak API is unreachable |
| Dashboard shows "Loading..." forever | Check browser console for fetch errors; verify `/moniter/get-air-data/` is accessible |
| `ModuleNotFoundError: No module named 'requests'` | Run `pip install requests` inside virtual environment |
| `No such table` Django error | Run `python manage.py migrate` |
| ESP32 not connecting to Wi-Fi | Double-check SSID/password; ensure 2.4 GHz network (ESP32 doesn't support 5 GHz) |
| ThingSpeak not receiving data | Verify Write API Key in the sketch; check Serial Monitor for error messages |
| Prediction chart not showing | Ensure at least 2 data points exist in ThingSpeak channel |
| `ALLOWED_HOSTS` error | Add `'127.0.0.1'` to `ALLOWED_HOSTS` in `settings.py` |

---

## 🚀 Future Improvements

- Replace Linear Regression with **ARIMA** or **LSTM** for better time-series prediction
- Add **database storage** to persist historical readings locally
- Integrate **email / SMS notifications** when PPM exceeds threshold
- Add **multi-sensor support** (CO₂, temperature, humidity)
- Deploy to **cloud** (Heroku, Railway, or AWS EC2)
- Add a **map view** for multi-location monitoring
- Calibrate MQ-135 with proper **sensor calibration curve** for accurate PPM conversion

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push to your branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**Mayilraj**
- GitHub: [@Mayilraj13](https://github.com/Mayilraj13)

---

> ⭐ If this project helped you, please consider starring it on GitHub!
