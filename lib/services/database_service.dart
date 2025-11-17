import 'package:hive_flutter/hive_flutter.dart';
import '../models/card_set.dart';
import '../models/flashcard.dart';

class DatabaseService {
  static late Box<CardSet> _setsBox;
  static late Box<Flashcard> _cardsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(CardSetAdapter());
    Hive.registerAdapter(FlashcardAdapter());

    // Open boxes
    _setsBox = await Hive.openBox<CardSet>('sets');
    _cardsBox = await Hive.openBox<Flashcard>('cards');
  }

  // CardSet operations
  static List<CardSet> getAllSets() => _setsBox.values.toList();

  static CardSet? getSet(String id) {
    try {
      return _setsBox.values.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveSet(CardSet set) => _setsBox.put(set.id, set);

  static Future<void> deleteSet(String id) async {
    await _setsBox.delete(id);
    // Also delete associated cards
    final cards = getCardsBySet(id);
    for (var card in cards) {
      await _cardsBox.delete(card.id);
    }
  }

  // Flashcard operations
  static List<Flashcard> getAllCards() => _cardsBox.values.toList();

  static List<Flashcard> getCardsBySet(String setId) =>
      _cardsBox.values.where((c) => c.setId == setId).toList();

  static List<Flashcard> getUnlearnedCards(String setId) =>
      getCardsBySet(setId).where((c) => !c.isLearned).toList();

  static Flashcard? getCard(String id) {
    try {
      return _cardsBox.values.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveCard(Flashcard card) => _cardsBox.put(card.id, card);

  static Future<void> deleteCard(String id) => _cardsBox.delete(id);

  static void close() {
    _setsBox.close();
    _cardsBox.close();
  }
}
