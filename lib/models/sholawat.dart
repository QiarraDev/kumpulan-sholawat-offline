import 'package:hive/hive.dart';

part 'sholawat.g.dart';

@HiveType(typeId: 0)
class Sholawat extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String arabic;

  @HiveField(3)
  final String latin;

  @HiveField(4)
  final String translation;

  @HiveField(5)
  final String audio;

  @HiveField(6)
  final String category;

  Sholawat({
    required this.id,
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.audio,
    required this.category,
  });

  factory Sholawat.fromJson(Map<String, dynamic> json) {
    return Sholawat(
      id: json['id'],
      title: json['title'],
      arabic: json['arabic'],
      latin: json['latin'],
      translation: json['translation'],
      audio: json['audio'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabic': arabic,
      'latin': latin,
      'translation': translation,
      'audio': audio,
      'category': category,
    };
  }
}
