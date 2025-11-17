import 'package:hive/hive.dart';

part 'card_set.g.dart';

@HiveType(typeId: 0)
class CardSet extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int color;

  @HiveField(3)
  final DateTime createdAt;

  CardSet({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  CardSet copyWith({String? name, int? color}) {
    return CardSet(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt,
    );
  }
}
