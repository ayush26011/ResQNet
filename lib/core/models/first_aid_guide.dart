class FirstAidGuide {
  final String id;
  final String title;
  final String? description;
  final String content;
  final String? category;
  final String? keywords;
  final int createdAt;

  FirstAidGuide({
    required this.id,
    required this.title,
    this.description,
    required this.content,
    this.category,
    this.keywords,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'category': category,
      'keywords': keywords,
      'created_at': createdAt,
    };
  }

  factory FirstAidGuide.fromMap(Map<String, dynamic> map) {
    return FirstAidGuide(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      content: map['content'],
      category: map['category'],
      keywords: map['keywords'],
      createdAt: map['created_at'],
    );
  }
}
