# Bahasa

An offline-first, AI-enhanced language learning and flashcard application built with Flutter, Clean Architecture, and peer-to-peer collaboration.

---

## Overview

**Bahasa** is designed to provide an interactive, flexible, and privacy-respecting language learning experience. Whether studying solo with animated flashcards and timed quizzes, collaborating in real-time with a peer over local Wi-Fi, or generating tailored vocabulary decks using Cloud or On-Device AI, Bahasa delivers a fluid and modern mobile experience.

---

## ✨ Features

### 🎴 Study Modes
- **Interactive Flashcards:** Smooth card flip animations powered by `flutter_animate`, self-assessment tracking, and instant feedback.
- **Timed Quizzes:** Multiple-choice quiz sessions with countdown timers, dynamic scoring, and answer review.
- **Progress Tracking & Analytics:** Track study streaks, deck mastery levels, accuracy rates, and historical study logs.
- **Smart Recommendations:** Context-aware study reminders based on spaced review and recent activity.

### 🤖 Hybrid AI Deck Generation
- **Cloud AI (Google Gemini 1.5 Flash):** Fast, cloud-assisted deck generation from custom user prompts.
- **Local On-Device AI (Google Gemma 4-E4B via LiteRT-LM):** 100% private, offline, and unlimited deck generation running directly on device hardware using `flutter_litert_lm`.
- **Integrated Model Downloader:** Streamed background downloading and lifecycle management for local AI models directly in Settings.

### 👥 Cooperative Multiplayer ("Latihan Bersama")
- **Zero-Cloud Local Wi-Fi Play:** 2-player cooperative study sessions connected directly via local Wi-Fi / Hotspot using an embedded Shelf HTTP server and Server-Sent Events (SSE).
- **QR Code Joining:** Instant room pairing with QR code generation and integrated camera scanning (`mobile_scanner`).
- **Real-Time Co-Op Mechanics:** Simultaneous question answering, shared combo streaks, cooperative star score tallying, and session recaps.

### 📦 Deck Management & Import/Export
- **Isolated SQLite Storage:** Every deck operates within its own SQLite database (`deck_<uuid>.sqlite`), ensuring clean data boundaries and snappy queries.
- **Custom `.euy` Package Format:** Export and import flashcard decks as portable `.euy` archive files with metadata and card definitions.
- **Batch Operations:** Multi-select deck deletion, search filtering, and flag palette dynamic theming.

### 📲 Peer-to-Peer Data Migration
- Seamlessly migrate profile data, learning history, and all decks between devices over local Wi-Fi without needing cloud backups or third-party accounts.

### 🎨 Design & Experience
- **Material 3 Design:** Carefully crafted UI supporting dynamic **Light**, **Dark**, and **System** themes.
- **Flag Palette Accent Colors:** Dynamic color accents extracted from national flags using `palette_generator_master`.
- **Internationalization (i18n):** Complete bilingual support for **English (`en`)** and **Indonesian (`id`)**.

---

## 🏗️ Architecture

Bahasa adheres to **Clean Architecture** principles and the **BLoC (Business Logic Component)** design pattern:

```text
lib/
├── core/                           # Shared infrastructure and utilities
│   ├── constants/                  # Configuration, route constants, and endpoints
│   ├── errors/                     # Failure definitions and error handling
│   ├── localization/               # LocaleCubit and language switcher
│   ├── router/                     # GoRouter configuration and route declarations
│   ├── server/                     # Embedded Shelf HTTP server for P2P data transfer
│   ├── theme/                      # AppTheme (Light & Dark), semantic colors, and typography
│   ├── utils/                      # Database loaders (MainDbLoader, DeckDbLoader) and helpers
│   └── widgets/                    # Core reusable atomic UI widgets
├── features/
│   ├── login/                      # Profile onboarding, local data migration, and AI preference
│   ├── home/                       # Dashboard, streaks, recommendations, and recent activity
│   ├── decks/                      # Deck management and sub-modules:
│   │   ├── deck_details/           # Card list, deck mastery, accuracy analytics, and stats
│   │   ├── deck_history/           # Study session logs, card answer breakdown, and filter
│   │   ├── study/                  # Interactive Flashcards & Quiz game engines
│   │   ├── generate_deck/          # AI deck generation (Gemini Cloud + Gemma LiteRT-LM)
│   │   └── import_deck/            # Portable .euy deck import and validation
│   ├── multiplayer/                # Real-time 2-player local Wi-Fi co-op quiz
│   └── settings/                   # User profile, theme, language, AI model, and data storage
├── l10n/                           # ARB localization templates and generated delegates
└── main.dart                       # App entry point, dependency injection, and bloc providers
```

### Layer Separation
1. **Domain Layer:** Pure Dart containing Entities, Use Cases, and Repository Interfaces (strictly no UI or framework dependencies).
2. **Data Layer:** Repository Implementations, Local Data Sources (SQLite via `sqlite3`, `shared_preferences`), Models, and Network/Server sources.
3. **Presentation Layer:** State management via BLoC/Cubit (`flutter_bloc`), modular screens/pages, and reusable UI components.

---

## 🛠️ Tech Stack & Dependencies

| Category | Libraries / Tools |
|---|---|
| **Framework** | Flutter (SDK `^3.13.3`), Dart |
| **State Management** | `flutter_bloc`, `hydrated_bloc` |
| **Navigation** | `go_router` |
| **Local Persistence** | `sqlite3`, `sqlite3_flutter_libs`, `shared_preferences`, `path_provider` |
| **Networking & P2P** | `shelf`, `shelf_router`, `shelf_multipart`, `network_info_plus`, SSE |
| **Artificial Intelligence** | `google_generative_ai` (Gemini 1.5 Flash), `flutter_litert_lm` (Gemma 4-E4B) |
| **UI, Assets & Icons** | `flutter_animate`, `material_symbols_icons`, `flutter_svg`, `country_flags` |
| **Camera & QR** | `mobile_scanner`, `pretty_qr_code` |
| **Palette Extraction** | `palette_generator_master` |
| **Localization** | `flutter_localizations`, `intl` |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.13.3` or later)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator (Android 8.0+ recommended for LiteRT-LM support)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/bahasa.git
   cd bahasa
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Create a `.env` file in the project root (or copy from example):
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

   Alternatively, pass the API key at build/run time:
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key_here
   ```

   > For full setup details, refer to [docs/GEMINI_SETUP.md](docs/GEMINI_SETUP.md).

4. **Run Code Generation & Localizations (if needed):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Launch the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Code Quality

Run the test suite:
```bash
flutter test
```

Analyze the codebase for static warnings and lint rules:
```bash
flutter analyze
```

Format code according to Dart conventions:
```bash
dart format .
```

---

## 🤝 Contributing

Contributions, feature suggestions, and bug reports are welcome!
1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
