# Recordari 🧠

**Recordari** is a simple and elegant flashcard study application built with Flutter. Create card sets, study with flip animations, and track your learning progress—all offline.

## ✨ Features

- 📚 **Create Card Sets** - Organize flashcards by topics with custom colors
- ✏️ **CRUD Operations** - Create, edit, and delete flashcards easily
- 🔄 **Study Mode** - Interactive flip animation to reveal answers
- 🎲 **Random/Ordered Mode** - Toggle between shuffled and sequential study
- 📊 **Progress Tracking** - View learning statistics by set and globally
- 💾 **Offline First** - All data stored locally with Hive
- 🎨 **Clean UI** - Material Design with intuitive navigation

## 🛠️ Tech Stack

- **Flutter** - Cross-platform framework
- **Hive** - Fast, lightweight NoSQL database
- **Riverpod** - State management
- **FVM** - Flutter Version Management

## 📱 Screenshots

> Add screenshots here

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (using FVM)
- Xcode (for iOS)
- Android Studio (for Android)

### Installation

1. Clone the repository

```bash
git clone <repository-url>
cd recordari/app/recordari
```

2. Install dependencies

```bash
fvm flutter pub get
```

3. Generate Hive adapters

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

4. Run the app

```bash
fvm flutter run
```

## 📦 Build Release

### Android APK

```bash
fvm flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
fvm flutter build ios --release
```

## 🏗️ Architecture

```
lib/
├── models/          # Hive data models (CardSet, Flashcard)
├── providers/       # Riverpod state management
├── services/        # DatabaseService (repository pattern)
├── screens/         # UI screens (Home, CardSet, Study, Stats)
├── utils/          # Constants and helpers
└── main.dart       # App entry point
```

### Key Design Patterns

- **Repository Pattern** - `DatabaseService` abstracts database operations
- **Feature-First Structure** - Organized by feature modules
- **Provider Pattern** - Riverpod 3.0 with `Notifier` API
- **Cascade Delete** - Deleting a set removes all associated cards

## 📝 Data Models

### CardSet

- `id` (String) - Unique identifier
- `name` (String) - Set name
- `color` (int) - Display color
- `createdAt` (DateTime) - Creation timestamp

### Flashcard

- `id` (String) - Unique identifier
- `setId` (String) - Parent set reference
- `question` (String) - Front of card
- `answer` (String) - Back of card
- `isLearned` (bool) - Learning status
- `createdAt` (DateTime) - Creation timestamp

## 🎯 Usage Flow

1. **Create a Set** - Tap FAB on home screen
2. **Add Cards** - Open set → tap FAB → enter question/answer
3. **Study** - Tap play icon → flip cards → mark known/unknown
4. **Track Progress** - View statistics screen for learning metrics

## 🔧 Configuration

The app uses **Hive boxes** for storage:

- `sets` - CardSet storage
- `cards` - Flashcard storage

Data persists automatically between app sessions.

## 👥 Contributors

- Sergio Alejandro León Rodríguez - [@seraleman](https://github.com/seraleman)

## 📄 License

This project is licensed for educational purposes.

## 🙏 Acknowledgments

Built as a university project demonstrating Flutter + Hive + Riverpod integration for offline-first mobile applications.
