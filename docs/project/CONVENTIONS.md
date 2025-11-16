# 📐 Code Conventions - Recordari

---

## 📁 Folder Structure

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models with TypeAdapters
│   ├── card_set.dart
│   └── flashcard.dart
├── providers/                # Riverpod providers
│   ├── card_set_provider.dart
│   ├── flashcard_provider.dart
│   └── stats_provider.dart
├── services/                 # Services (DB, etc)
│   └── database_service.dart
├── screens/                  # Main screens
│   ├── home_screen.dart
│   ├── card_set_screen.dart
│   ├── study_screen.dart
│   └── stats_screen.dart
├── widgets/                  # Reusable widgets
│   ├── card_flip_widget.dart
│   ├── progress_bar.dart
│   ├── empty_state.dart
│   └── confirmation_dialog.dart
└── utils/                    # Utilities and constants
    ├── constants.dart
    └── colors.dart
```

---

## 🎯 Naming Conventions

### Files

- **snake_case**: `card_set_provider.dart`, `study_screen.dart`
- **Clear suffixes**: `_screen.dart`, `_provider.dart`, `_widget.dart`, `_service.dart`

### Classes

- **PascalCase**: `CardSet`, `Flashcard`, `HomeScreen`
- **Descriptive suffixes**:
  - Screens: `HomeScreen`, `StudyScreen`
  - Providers: `CardSetNotifier`, `FlashcardProvider`
  - Widgets: `CardFlipWidget`, `ProgressBar`

### Variables

- **camelCase**: `cardSet`, `isLearned`, `nextReview`
- **Booleans**: prefix with `is`, `has`, `should`
  - ✅ `isLearned`, `hasCards`, `shouldShuffle`
  - ❌ `learned`, `cards`, `shuffle`

### Constants

- **lowerCamelCase**: `defaultColors`, `maxCardsPerSet`
- In `constants.dart` file

### Providers

```dart
// StateNotifier
final cardSetProvider = StateNotifierProvider<CardSetNotifier, List<CardSet>>(...);

// Simple provider
final statsProvider = Provider<StatsService>(...);

// FutureProvider
final cardsProvider = FutureProvider.family<List<Flashcard>, String>(...);
```

---

## 🏗️ Architecture

### Pattern: Feature-First + Provider

```
User Interaction → Screen → Provider → Service → Hive DB
                              ↓
                         State Update
                              ↓
                         UI Rebuild
```

### Responsibilities

**Models:**

- Data and serialization only
- TypeAdapters for Hive
- No business logic

**Providers:**

- State management
- Business logic
- Service interaction

**Services:**

- DB operations (Hive)
- External operations (if any)

**Screens:**

- UI and navigation
- Consume providers
- Minimal logic (UI only)

**Widgets:**

- Reusable components
- No internal state (or StatelessWidget)
- Receive data via parameters

---

## 🎨 Styles and UI

### Colors

```dart
// In utils/colors.dart
const appPrimaryColor = Color(0xFF2196F3);
const appBackgroundColor = Color(0xFFF5F5F5);
const cardColors = [
  Color(0xFF2196F3), // Blue
  Color(0xFF4CAF50), // Green
  Color(0xFFFF9800), // Orange
  Color(0xFF9C27B0), // Purple
];
```

### Spacing

```dart
// Constants in utils/constants.dart
const double paddingSmall = 8.0;
const double paddingMedium = 16.0;
const double paddingLarge = 24.0;
const double borderRadius = 12.0;
```

### Widgets

- Use `const` whenever possible
- Extract complex widgets to separate files
- Prefer composition over inheritance

---

## 📝 Comments and Documentation

### Code Comments

```dart
// ✅ GOOD: Explains the "why"
// Add back to the end to repeat in this session
queue.add(card);

// ❌ BAD: Explains the "what" (obvious)
// Add the card
queue.add(card);
```

### Function Documentation

```dart
/// Marks a card as learned and updates the progress.
///
/// Returns `true` if the operation was successful.
Future<bool> markAsLearned(String cardId) async {
  // ...
}
```

### TODOs

```dart
// TODO: Implement confirmation before deleting
// FIXME: Bug when shuffling empty list
// NOTE: This method will be optimized in v2
```

---

## 🔒 Best Practices

### Immutable State

```dart
// ✅ GOOD
state = [...state, newItem];

// ❌ BAD
state.add(newItem);
```

### Error Handling

```dart
try {
  await database.save(card);
} catch (e) {
  debugPrint('Error saving card: $e');
  // Show snackbar to user
}
```

### Null Safety

```dart
// Use null safety operators
final name = cardSet?.name ?? 'No name';

// Validate before using
if (cardSet != null) {
  // ...
}
```

### Async/Await

```dart
// ✅ GOOD: Readable async/await
Future<void> loadCards() async {
  final cards = await database.getCards();
  state = cards;
}

// ❌ BAD: Nested .then()
database.getCards().then((cards) {
  setState(() {
    // ...
  });
});
```

---

## 🧪 Testing (if time permits)

### Test Names

```dart
test('should create a new card set', () { });
test('should mark card as learned when user taps correct', () { });
```

### Structure

```dart
// Arrange
final card = Flashcard(...);

// Act
await provider.markAsLearned(card.id);

// Assert
expect(card.isLearned, true);
```

---

## 🚀 Git Commits

### Formato

```
<tipo>: <descripción corta>

[Descripción opcional más detallada]
```

### Types

- `feat`: New functionality
- `fix`: Bug fix
- `refactor`: Refactoring without functionality change
- `style`: Formatting changes, spacing
- `docs`: Documentation
- `test`: Tests

### Examples

```
feat: add study screen with flip animation
fix: prevent crash when deleting last card
refactor: extract card flip logic to widget
docs: update roadmap with completed tasks
```

---

## 📱 Platforms

### Android

- minSdkVersion: 21 (Android 5.0)
- targetSdkVersion: 33

### iOS

- Deployment target: iOS 12.0+

### Permissions

- **None required** (completely offline app)

---

## ⚡ Performance

### Optimizations

- Use `const` constructors
- `ListView.builder` for long lists
- Avoid unnecessary `setState()` calls
- Load data async in `initState` or providers

### Hive

- Use lazy boxes if there's a lot of data
- Close boxes when exiting the app (not critical)
- Indexes if fast searches are needed

---

## 🔧 Dependencies Configuration

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_riverpod: ^2.4.0
  path_provider: ^2.1.1
  uuid: ^4.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

---

**Last updated:** Nov 16, 2025
