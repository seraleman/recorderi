import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard.dart';
import '../services/database_service.dart';

// Provider that returns cards by setId - use this to read
final flashcardProvider = Provider.family<List<Flashcard>, String>((
  ref,
  setId,
) {
  return DatabaseService.getCardsBySet(setId);
});

// Helper functions for card operations
Future<void> createCard(String setId, String question, String answer) async {
  final newCard = Flashcard(
    id: const Uuid().v4(),
    setId: setId,
    question: question,
    answer: answer,
    isLearned: false,
    createdAt: DateTime.now(),
  );
  await DatabaseService.saveCard(newCard);
}

Future<void> updateCard(String id, String question, String answer) async {
  final card = DatabaseService.getCard(id);
  if (card != null) {
    final updated = card.copyWith(question: question, answer: answer);
    await DatabaseService.saveCard(updated);
  }
}

Future<void> markAsLearned(String cardId, bool isLearned) async {
  final card = DatabaseService.getCard(cardId);
  if (card != null) {
    final updated = card.copyWith(isLearned: isLearned);
    await DatabaseService.saveCard(updated);
  }
}

Future<void> deleteCard(String id) async {
  await DatabaseService.deleteCard(id);
}
