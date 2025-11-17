import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

final statsProvider = Provider<StatsService>((ref) {
  return StatsService();
});

class StatsService {
  int getTotalCards() => DatabaseService.getAllCards().length;

  int getLearnedCards() =>
      DatabaseService.getAllCards().where((c) => c.isLearned).length;

  double getGlobalProgress() {
    final total = getTotalCards();
    if (total == 0) return 0.0;
    return getLearnedCards() / total;
  }

  Map<String, ProgressData> getProgressBySet() {
    final sets = DatabaseService.getAllSets();
    return Map.fromEntries(
      sets.map((set) {
        final cards = DatabaseService.getCardsBySet(set.id);
        final learned = cards.where((c) => c.isLearned).length;
        return MapEntry(
          set.id,
          ProgressData(
            setName: set.name,
            total: cards.length,
            learned: learned,
            progress: cards.isEmpty ? 0.0 : learned / cards.length,
          ),
        );
      }),
    );
  }
}

class ProgressData {
  final String setName;
  final int total;
  final int learned;
  final double progress;

  ProgressData({
    required this.setName,
    required this.total,
    required this.learned,
    required this.progress,
  });
}
