class Notice {
  final int id;
  final String title;
  final String content;
  final String category;
  final String priority; // 'low', 'medium', 'high'
  final DateTime createdAt;
  final bool isUrgent;
  final String? imageUrl;
  final int viewCount;

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    required this.createdAt,
    this.isUrgent = false,
    this.imageUrl,
    this.viewCount = 0,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      priority: json['priority'] ?? 'normal',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      isUrgent: json['is_urgent'] ?? false,
      imageUrl: json['image_url'],
      viewCount: json['view_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'is_urgent': isUrgent,
      'image_url': imageUrl,
    };
  }
  // ... timeAgo getter remains same
}
