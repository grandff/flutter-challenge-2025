class MoodModel {
  final String id;
  final String userId;
  final String emoji;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoodModel({
    required this.id,
    required this.userId,
    required this.emoji,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Returns an empty instance
  MoodModel.empty()
      : id = "",
        userId = "",
        emoji = "",
        description = "",
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  // Creates an instance from a JSON map
  MoodModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        userId = json["user_id"] ?? "",
        emoji = json["emoji"] ?? "",
        description = json["description"] ?? "",
        createdAt = DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt = DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String());

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "emoji": emoji,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  // Copy with method for state updates
  MoodModel copyWith({
    String? id,
    String? userId,
    String? emoji,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to get relative time
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${difference.inDays ~/ 7} weeks ago";
    }
  }
}







