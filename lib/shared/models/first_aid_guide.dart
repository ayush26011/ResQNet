import 'dart:convert';

class FirstAidGuide {
  final String id;
  final String title;
  final String category;
  final String emoji;
  final String shortDescription;
  final List<String> steps;
  final List<String> warnings;
  final String emergencyAction;
  final String duration;
  final String difficulty;

  const FirstAidGuide({
    required this.id,
    required this.title,
    required this.category,
    required this.emoji,
    required this.shortDescription,
    required this.steps,
    required this.warnings,
    required this.emergencyAction,
    required this.duration,
    required this.difficulty,
  });

  FirstAidGuide copyWith({
    String? id,
    String? title,
    String? category,
    String? emoji,
    String? shortDescription,
    List<String>? steps,
    List<String>? warnings,
    String? emergencyAction,
    String? duration,
    String? difficulty,
  }) {
    return FirstAidGuide(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      shortDescription: shortDescription ?? this.shortDescription,
      steps: steps ?? this.steps,
      warnings: warnings ?? this.warnings,
      emergencyAction: emergencyAction ?? this.emergencyAction,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'emoji': emoji,
      'shortDescription': shortDescription,
      'steps': jsonEncode(steps),
      'warnings': jsonEncode(warnings),
      'emergencyAction': emergencyAction,
      'duration': duration,
      'difficulty': difficulty,
    };
  }

  factory FirstAidGuide.fromMap(Map<String, dynamic> map) {
    // Check type of steps and warnings: could be String (from SQLite) or List (if in-memory)
    List<String> parseJsonList(dynamic field) {
      if (field is List) {
        return List<String>.from(field.map((e) => e.toString()));
      } else if (field is String) {
        try {
          final decoded = jsonDecode(field);
          if (decoded is List) {
            return List<String>.from(decoded.map((e) => e.toString()));
          }
        } catch (_) {}
      }
      return [];
    }

    return FirstAidGuide(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      emoji: map['emoji'] as String,
      shortDescription: (map['shortDescription'] ?? map['summary'] ?? '') as String,
      steps: parseJsonList(map['steps']),
      warnings: parseJsonList(map['warnings']),
      emergencyAction: (map['emergencyAction'] ?? '') as String,
      duration: (map['duration'] ?? '3 min') as String,
      difficulty: (map['difficulty'] ?? 'Moderate') as String,
    );
  }
}
