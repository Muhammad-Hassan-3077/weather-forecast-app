
# 🌦️ Weatherly — Weather Forecast App

A modern weather forecasting application developed using **Flutter and Dart** for **Task 3 (Medium)** of the Auspify Technologies Flutter Development Internship.

Weatherly integrates the Open-Meteo API to retrieve weather information dynamically and presents current conditions, hourly forecasts, and a 7-day forecast through a clean, dark-themed dashboard.

## ✨ Features

- 🌍 **City Search** — Search for cities and select a location from the available results.
- 🌡️ **Current Weather** — View current temperature and feels-like temperature.
- 💧 **Humidity Information** — Display relative humidity.
- 💨 **Wind Speed** — View wind speed in kilometres per hour.
- 🕒 **Hourly Forecast** — Browse upcoming hourly temperatures and weather conditions.
- 📅 **7-Day Forecast** — View daily weather conditions and high/low temperatures.
- 🔄 **Weather Refresh** — Request updated weather data.
- ⏳ **Loading Indicators** — Display progress while requests are processing.
- ⚠️ **Error Handling** — Show user-friendly messages when API requests fail.
- 🎨 **Modern UI** — Dark theme, weather cards, and a responsive dashboard.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| HTTP package | Network requests to weather APIs |
| Open-Meteo Forecast API | Weather information and forecasts |
| Open-Meteo Geocoding API | City search and geographic coordinates |
| Material Design | User interface components |

## 🌐 API Integration

Weatherly uses the Open-Meteo services for weather information and location search.

- **Forecast API:** https://open-meteo.com/en/docs
- **Geocoding API:** https://open-meteo.com/en/docs/geocoding-api

The application searches for a city, obtains its geographic coordinates, and requests weather information for the selected location.

Weather values and forecasts depend on the API provider's data, location, time, and forecasting model.

## 📋 Prerequisites

Before running the application, ensure that you have:

- Flutter SDK installed and configured.
- Dart SDK available through Flutter.
- Android Studio or another Flutter-compatible development environment.
- An Android emulator, connected device, or supported browser.
- An active internet connection for API requests.

## 🚀 Installation and Setup

### 1. Open the Project

Open the `weather_forecast_app` project directory in Android Studio.

### 2. Install Dependencies

Run the following command in the terminal:

```bash
flutter pub get
```

### 3. Analyse the Project

Check the project for static analysis issues:

```bash
flutter analyze
```

### 4. Run the Application

Launch the application on a connected device or emulator:

```bash
flutter run
```

To run the application in Google Chrome:

```bash
flutter run -d chrome
```

## 📁 Project Structure

```text
weather_forecast_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── weather_model.dart
│   ├── screens/
│   │   └── weather_screen.dart
│   ├── services/
│   │   └── weather_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── current_weather_card.dart
│       ├── hourly_forecast.dart
│       └── daily_forecast.dart
├── android/
├── test/
├── web/
├── windows/
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

## 🧪 Testing Checklist

Verify the following features in the running application before submission:

- [ ] The application launches successfully.
- [ ] City search returns relevant location results.
- [ ] The selected city matches the displayed weather location.
- [ ] Current weather values and units display correctly.
- [ ] The hourly forecast scrolls horizontally.
- [ ] Hourly forecast interactions work as intended.
- [ ] The daily forecast displays the available forecast days.
- [ ] The refresh control requests updated weather data.
- [ ] Loading indicators appear during API requests.
- [ ] API errors are handled with appropriate messages.
- [ ] Weather values are compared with the API response for the same location and approximate time.
- [ ] `flutter analyze` completes without issues.

Only mark checklist items as complete after testing them in the current version of the application.

## 🎓 Internship Information

- **Organisation:** Auspify Technologies
- **Programme:** Flutter Development Internship
- **Task Number:** Task 3
- **Task Name:** Weather Forecast App
- **Difficulty Level:** Medium

## 🔮 Future Enhancements

Potential improvements include:

- Automatic location detection with user permission.
- Weather alerts and severe-weather notifications.
- More detailed forecast visualisations.
- Improved offline and network-recovery handling.
- Additional accessibility and user interface refinements.

## 📌 Project Purpose

This project was developed for educational and internship purposes to practise Flutter UI development, REST API integration, JSON parsing, network requests, and the presentation of dynamic weather information.

---

**Developed by Muhammad Hassan**  
*Flutter Development Intern — Auspify Technologies*
