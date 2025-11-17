import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/card_set.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

final cardSetProvider = NotifierProvider<CardSetNotifier, List<CardSet>>(
  CardSetNotifier.new,
);

class CardSetNotifier extends Notifier<List<CardSet>> {
  @override
  List<CardSet> build() {
    return DatabaseService.getAllSets();
  }

  Future<void> createSet(String name) async {
    final newSet = CardSet(
      id: const Uuid().v4(),
      name: name,
      color: cardColors[state.length % cardColors.length].toARGB32(),
      createdAt: DateTime.now(),
    );
    await DatabaseService.saveSet(newSet);
    state = [...state, newSet];
  }

  Future<void> updateSet(String id, String name) async {
    final index = state.indexWhere((s) => s.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(name: name);
      await DatabaseService.saveSet(updated);
      state = [
        ...state.sublist(0, index),
        updated,
        ...state.sublist(index + 1),
      ];
    }
  }

  Future<void> deleteSet(String id) async {
    await DatabaseService.deleteSet(id);
    state = state.where((s) => s.id != id).toList();
  }
}
