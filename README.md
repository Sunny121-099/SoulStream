<div align="center">

# 🎧 SoulStream
### *Your Weather-Adaptive Music Companion*

[![Build & Release APK](https://github.com/Sunny121-099/SoulStream/actions/workflows/build.yml/badge.svg)](https://github.com/Sunny121-099/SoulStream/actions/workflows/build.yml)
[![Latest Release](https://img.shields.io/github/v/release/Sunny121-099/SoulStream?include_prereleases&style=flat-square&color=6366f1)](https://github.com/Sunny121-099/SoulStream/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?style=flat-square&logo=flutter)](https://flutter.dev)

[Explore Features](#-features) • [Weather-to-Mood Engine](#-weather-to-mood-mapping-engine) • [Architecture](#-architecture) • [Download APK](https://github.com/Sunny121-099/SoulStream/releases/latest)

</div>

---

## ✨ Overview

**SoulStream** is an intelligent Flutter application that bridges the gap between your physical environment and your musical soul. By dynamically detecting real-time weather conditions via location services, SoulStream curates and transitions your playlist to match the atmospheric vibe — turning stormy downpours into cozy lofi beats and sunny skies into high-energy anthems.

---

## 🌟 Features

- 🌤️ **Weather-to-Mood Engine**: Seamlessly translates weather data (temperature, humidity, precipitation) into curated musical moods.
- 🎵 **Immersive Audio Player**: Built-in background audio service with sleek controls, queue management, and mini-player support.
- ❤️ **Favorites & Library**: Easily bookmark tracks and manage your personalized soundtrack collection.
- 🚀 **Automated CI/CD**: Fully integrated GitHub Actions workflow that builds and publishes debug APKs to GitHub Releases on every push.

---

## 🌤️ Weather-to-Mood Mapping Engine

| Weather Condition | Atmospheric Vibe | Curated Genre / Mood | Primary Vibe / Tempo |
| :--- | :--- | :--- | :--- |
| ☀️ **Sunny / Clear** | Bright, Warm, Energetic | Upbeat Pop, Indie Dance | High Energy, 120-130 BPM |
| 🌧️ **Rainy / Drizzle** | Cozy, Melancholic, Reflective | Lofi Hip Hop, Acoustic, Ambient | Relaxed, 70-90 BPM |
| 🌩️ **Thunderstorm** | Dramatic, Intense, Electric | Synthwave, Dark Ambient, Cinematic | Moody, Dynamic |
| ☁️ **Cloudy / Overcast** | Calm, Mellow, Thoughtful | Indie Folk, Soft Jazz, Chillwave | Mid Tempo, 95-110 BPM |
| ❄️ **Snow / Frosty** | Crisp, Serene, Peaceful | Classical Piano, Neo-Classical, Chill | Slow & Peaceful, 60-80 BPM |

---

## 🏛️ Architecture

SoulStream follows a clean, modular architecture separating UI screens, core domain services, data models, and reusable components:

```text
lib/
├── app.dart                   # App root & theme configuration
├── main.dart                  # Application entry point
├── models/                    # Domain data structures
│   ├── song.dart              # Song / Track model
│   └── weather_mood.dart      # Weather & mood mapping models
├── screens/                   # Application view screens
│   ├── favorites_screen.dart  # Liked tracks view
│   ├── home_screen.dart       # Dashboard & weather display
│   └── player_screen.dart     # Full-screen audio player
├── services/                  # Business logic & integrations
│   ├── music_service.dart     # Audio track management
│   ├── player_manager.dart    # Audio playback controller
│   └── weather_service.dart   # Weather API & detection
└── widgets/                   # Reusable UI components
    └── mini_player.dart       # Persistent bottom mini player
```

---

## 📥 Download & Install

Grab the latest Android APK directly from GitHub Releases:

<div align="center">

[📥 **Download SoulStream Latest APK**](https://github.com/Sunny121-099/SoulStream/releases/latest)

</div>

---

## 🛠️ Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Sunny121-099/SoulStream.git
   cd SoulStream
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run on device/emulator**:
   ```bash
   flutter run
   ```

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
