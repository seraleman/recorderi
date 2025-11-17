import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 1)
class Flashcard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String setId;

  @HiveField(2)
  final String question;

  @HiveField(3)
  final String answer;

  @HiveField(4)
  final bool isLearned;

  @HiveField(5)
  final DateTime createdAt;

  Flashcard({
    required this.id,
    required this.setId,
    required this.question,
    required this.answer,
    required this.isLearned,
    required this.createdAt,
  });

  Flashcard copyWith({String? question, String? answer, bool? isLearned}) {
    return Flashcard(
      id: id,
      setId: setId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isLearned: isLearned ?? this.isLearned,
      createdAt: createdAt,
    );
  }
}
