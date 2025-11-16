# 🏗️ Architecture - Recordari

---

## 📊 Overview

Recordari uses a **Feature-First** architecture with **Provider Pattern** (Riverpod) for state management and **Hive** as local database.

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│                    (Screens)                            │
│  HomeScreen | CardSetScreen | StudyScreen | StatsScreen│
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│                 State Management                        │
│                   (Providers)                           │
│   CardSetProvider | FlashcardProvider | StatsProvider   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│                 Business Logic                          │
│                   (Services)                            │
│              DatabaseService                            │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────┐
│                  Data Layer                             │
│                    (Hive)                               │
│          Box<CardSet> | Box<Flashcard>                  │
└─────────────────────────────────────────────────────────┘
```

---

## 🗂️ Architecture Layers

### 1. UI Layer (Presentation)

**Responsibility:** Display data and capture user interactions

**Components:**

- **Screens**: Full screens with navigation
- **Widgets**: Reusable components

**Characteristics:**

- Consume providers using `ref.watch()` / `ref.read()`
- Only contain UI logic (animations, navigation)
- StatelessWidget whenever possible

**Example:**

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sets = ref.watch(cardSetProvider);

    return Scaffold(
      body: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          return CardSetTile(set: sets[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
      ),
    );
  }
}
```

---

### 2. State Management (Providers)

**Responsibility:** Manage state and business logic

**Pattern:** Riverpod with StateNotifier

**Providers:**

#### CardSetProvider

```dart
final cardSetProvider = StateNotifierProvider<CardSetNotifier, List<CardSet>>((ref) {
  return CardSetNotifier(ref.read(databaseServiceProvider));
});

class CardSetNotifier extends StateNotifier<List<CardSet>> {
  final DatabaseService _db;

  CardSetNotifier(this._db) : super([]) {
    _loadSets();
  }

  Future<void> _loadSets() async {
    state = await _db.getAllSets();
  }

  Future<void> createSet(String name) async {
    final newSet = CardSet(
      id: uuid.v4(),
      nombre: name,
      color: _getRandomColor(),
      createdAt: DateTime.now(),
    );
    await _db.saveSet(newSet);
    state = [...state, newSet];
  }

  Future<void> deleteSet(String id) async {
    await _db.deleteSet(id);
    state = state.where((s) => s.id != id).toList();
  }
}
```

#### FlashcardProvider

```dart
final flashcardProvider = StateNotifierProvider.family<FlashcardNotifier, List<Flashcard>, String>(
  (ref, setId) {
    return FlashcardNotifier(ref.read(databaseServiceProvider), setId);
  },
);

class FlashcardNotifier extends StateNotifier<List<Flashcard>> {
  final DatabaseService _db;
  final String setId;

  FlashcardNotifier(this._db, this.setId) : super([]) {
    _loadCards();
  }

  Future<void> createCard(String pregunta, String respuesta) async {
    final newCard = Flashcard(
      id: uuid.v4(),
      setId: setId,
      pregunta: pregunta,
      respuesta: respuesta,
      aprendida: false,
      createdAt: DateTime.now(),
    );
    await _db.saveCard(newCard);
    state = [...state, newCard];
  }

  Future<void> markAsLearned(String cardId) async {
    final index = state.indexWhere((c) => c.id == cardId);
    if (index != -1) {
      final updated = state[index].copyWith(aprendida: true);
      await _db.updateCard(updated);
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    }
  }
}
```

#### StatsProvider

```dart
final statsProvider = Provider((ref) {
  return StatsService(ref.read(databaseServiceProvider));
});

class StatsService {
  final DatabaseService _db;

  StatsService(this._db);

  int getTotalCards() => _db.getAllCards().length;

  int getLearnedCards() =>
      _db.getAllCards().where((c) => c.aprendida).length;

  double getGlobalProgress() {
    final total = getTotalCards();
    if (total == 0) return 0.0;
    return getLearnedCards() / total;
  }

  Map<String, double> getProgressBySet() {
    final sets = _db.getAllSets();
    return Map.fromEntries(
      sets.map((set) {
        final cards = _db.getCardsBySet(set.id);
        final learned = cards.where((c) => c.aprendida).length;
        return MapEntry(
          set.id,
          cards.isEmpty ? 0.0 : learned / cards.length,
        );
      }),
    );
  }
}
```

---

### 3. Service Layer

**Responsibility:** Database operations and shared logic

#### DatabaseService

```dart
final databaseServiceProvider = Provider((ref) => DatabaseService());

class DatabaseService {
  late Box<CardSet> _setsBox;
  late Box<Flashcard> _cardsBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(CardSetAdapter());
    Hive.registerAdapter(FlashcardAdapter());

    // Open boxes
    _setsBox = await Hive.openBox<CardSet>('sets');
    _cardsBox = await Hive.openBox<Flashcard>('cards');
  }

  // CardSet operations
  List<CardSet> getAllSets() => _setsBox.values.toList();

  CardSet? getSet(String id) =>
      _setsBox.values.firstWhere((s) => s.id == id, orElse: () => null);

  Future<void> saveSet(CardSet set) => _setsBox.put(set.id, set);

  Future<void> deleteSet(String id) async {
    await _setsBox.delete(id);
    // Also delete associated cards
    final cards = getCardsBySet(id);
    for (var card in cards) {
      await _cardsBox.delete(card.id);
    }
  }

  // Flashcard operations
  List<Flashcard> getAllCards() => _cardsBox.values.toList();

  List<Flashcard> getCardsBySet(String setId) =>
      _cardsBox.values.where((c) => c.setId == setId).toList();

  List<Flashcard> getUnlearnedCards(String setId) =>
      getCardsBySet(setId).where((c) => !c.aprendida).toList();

  Future<void> saveCard(Flashcard card) => _cardsBox.put(card.id, card);

  Future<void> updateCard(Flashcard card) => _cardsBox.put(card.id, card);

  Future<void> deleteCard(String id) => _cardsBox.delete(id);

  void close() {
    _setsBox.close();
    _cardsBox.close();
  }
}
```

---

### 4. Data Layer (Models)

**Responsibility:** Define data structure and serialization

#### CardSet Model

```dart
import 'package:hive/hive.dart';

part 'card_set.g.dart'; // Generated by build_runner

@HiveType(typeId: 0)
class CardSet {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nombre;

  @HiveField(2)
  final int color; // Color.value

  @HiveField(3)
  final DateTime createdAt;

  CardSet({
    required this.id,
    required this.nombre,
    required this.color,
    required this.createdAt,
  });

  CardSet copyWith({
    String? nombre,
    int? color,
  }) {
    return CardSet(
      id: id,
      nombre: nombre ?? this.nombre,
      color: color ?? this.color,
      createdAt: createdAt,
    );
  }
}
```

#### Flashcard Model

```dart
import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 1)
class Flashcard {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String setId;

  @HiveField(2)
  final String pregunta;

  @HiveField(3)
  final String respuesta;

  @HiveField(4)
  final bool aprendida;

  @HiveField(5)
  final DateTime createdAt;

  Flashcard({
    required this.id,
    required this.setId,
    required this.pregunta,
    required this.respuesta,
    required this.aprendida,
    required this.createdAt,
  });

  Flashcard copyWith({
    String? pregunta,
    String? respuesta,
    bool? aprendida,
  }) {
    return Flashcard(
      id: id,
      setId: setId,
      pregunta: pregunta ?? this.pregunta,
      respuesta: respuesta ?? this.respuesta,
      aprendida: aprendida ?? this.aprendida,
      createdAt: createdAt,
    );
  }
}
```

---

## 🔄 Data Flows

### Read Flow

```
User Opens HomeScreen
       ↓
ConsumerWidget calls ref.watch(cardSetProvider)
       ↓
CardSetNotifier loads from DatabaseService
       ↓
DatabaseService queries Hive Box
       ↓
Data flows back up to UI
       ↓
ListView.builder renders items
```

### Write Flow

```
User taps FAB to create set
       ↓
Dialog captures input
       ↓
Calls ref.read(cardSetProvider.notifier).createSet(name)
       ↓
CardSetNotifier creates CardSet object
       ↓
DatabaseService.saveSet() persists to Hive
       ↓
Notifier updates state = [...state, newSet]
       ↓
UI automatically rebuilds with new data
```

### Study Flow

```
User enters StudyScreen
       ↓
Loads unlearned cards from FlashcardProvider
       ↓
Shuffle if random mode
       ↓
Display first card (question)
       ↓
User taps → flip to answer
       ↓
User taps "I know it"
       ↓
Calls markAsLearned(cardId)
       ↓
Updates card.isLearned = true in Hive
       ↓
Removes from current queue
       ↓
Shows next card
```

---

## 🎯 Architecture Decisions

### Why Riverpod?

- ✅ Better than Provider (more modern, compile-time safety)
- ✅ Easier testing
- ✅ Doesn't require BuildContext
- ✅ Automatic scoping

### Why Hive?

- ✅ Faster than SQLite
- ✅ No SQL required
- ✅ Type-safe with TypeAdapters
- ✅ Perfect for simple structured data
- ✅ No complex setup required

### Why StateNotifier?

- ✅ Immutable state (more predictable)
- ✅ Clear separation between UI and logic
- ✅ Easy to test

### Why Feature-First?

- ✅ Scalable
- ✅ Code organized by functionality
- ✅ Easy to find related files

---

## 📦 Dependencies

### Core

- `flutter_riverpod`: State management
- `hive`: NoSQL database
- `hive_flutter`: Hive integration for Flutter
- `path_provider`: For storage paths
- `uuid`: Generate unique IDs

### Dev

- `build_runner`: Generate TypeAdapters
- `hive_generator`: Code generation for Hive

---

## 🧪 Testing Strategy (if time permits)

### Unit Tests

- Providers (business logic)
- Services (DB operations)
- Models (serialization)

### Widget Tests

- Individual widgets
- Dialogs
- Forms

### Integration Tests

- Complete flow from create→study→stats

---

**Last updated:** Nov 16, 2025
