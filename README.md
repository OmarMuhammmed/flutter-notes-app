# 📱 Simple Flutter Notes App

A beautiful, beginner-friendly Notes Application built with Flutter. It features a premium dark design, local data persistence, and a robust "Favorites" system to keep your most important ideas accessible.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

## ✨ Features

*   **🎨 Premium Dark Mode**: A sleek, modern UI using "Deep Purple" and "Teal" accents with glassmorphism effects.
*   **💾 Local Persistence**: Notes are saved locally on your device using `shared_preferences`, so they remain safe even after you close the app.
*   **⭐ Favorites System**: Quickly star important notes and filter your view to see only your favorites.
*   **🔍 Power Search**: Real-time search that filters by both title and content.
*   **⚡ CRUD Operations**: Create, Read, Update, and Delete notes with smooth animations and intuitive gestures (Swipe to Delete).
*   **📱 Responsive**: Works seamlessly on Android and iOS.

## 🛠️ Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Language**: [Dart](https://dart.dev/)
*   **Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences) (JSON Serialization)
*   **Typography**: [google_fonts](https://pub.dev/packages/google_fonts) (Outfit font family)
*   **Icons**: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

---

## 🚀 Getting Started

Follow these steps to get a local copy of the project up and running on your machine.

### Prerequisites

Ensure you have the following installed on your system:
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) (Latest Stable Version)
*   [Git](https://git-scm.com/)
*   An IDE (VS Code, Android Studio, or IntelliJ)
*   An Emulator (Android/iOS) or a Physical Device connected via USB.

### 📥 Installation

1.  **Clone the Repository**
    Open your terminal or command prompt and run:
    ```bash
    git clone https://github.com/yourusername/flutter-notes-app.git
    cd notes_app
    ```

2.  **Install Dependencies**
    Download the required packages listed in `pubspec.yaml`:
    ```bash
    flutter pub get
    ```

3.  **Run the App**
    Connect your device or start your emulator, then run:
    ```bash
    flutter run
    ```

---

## 🔧 Troubleshooting

**Build Errors / Asset Issues:**
If you change assets (like icons) or face weird build errors, try cleaning the build cache:
```bash
flutter clean
flutter pub get
flutter run
```

**Connection Lost Error:**
If you see "Service has disappeared", simply uninstall the app from your device and run `flutter run` again to perform a full reinstall.

## 📁 Project Structure

```
lib/
├── main.dart           # Entry point and Theme setup
├── models/
│   └── note.dart       # Note data model (JSON logic)
├── screens/
│   ├── notes_home_screen.dart  # Main list & search UI
│   └── note_editor_screen.dart # Create & Edit UI
└── widgets/
    ├── empty_state.dart     # UI for empty lists
    ├── gradient_button.dart # Reusable styled button
    └── note_card.dart       # Individual note item
```
