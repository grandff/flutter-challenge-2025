class PostModel {
  final String id;
  final String userId;
  final String username;
  final String userProfileImage;
  final bool isVerified;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final int replyCount;
  final int likeCount;
  final List<String> likedBy;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.isVerified,
    required this.content,
    required this.images,
    required this.createdAt,
    required this.replyCount,
    required this.likeCount,
    required this.likedBy,
  });

  // Returns an empty instance
  PostModel.empty()
      : id = "",
        userId = "",
        username = "",
        userProfileImage = "",
        isVerified = false,
        content = "",
        images = [],
        createdAt = DateTime.now(),
        replyCount = 0,
        likeCount = 0,
        likedBy = [];

  // Creates an instance from a JSON map
  PostModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        userId = json["userId"] ?? "",
        username = json["username"] ?? "",
        userProfileImage = json["userProfileImage"] ?? "",
        isVerified = json["isVerified"] ?? false,
        content = json["content"] ?? "",
        images = List<String>.from(json["images"] ?? []),
        createdAt = DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
        replyCount = json["replyCount"] ?? 0,
        likeCount = json["likeCount"] ?? 0,
        likedBy = List<String>.from(json["likedBy"] ?? []);

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "username": username,
        "userProfileImage": userProfileImage,
        "isVerified": isVerified,
        "content": content,
        "images": images,
        "createdAt": createdAt.toIso8601String(),
        "replyCount": replyCount,
        "likeCount": likeCount,
        "likedBy": likedBy,
      };

  // Create a copy of this instance with the given fields replaced
  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userProfileImage,
    bool? isVerified,
    String? content,
    List<String>? images,
    DateTime? createdAt,
    int? replyCount,
    int? likeCount,
    List<String>? likedBy,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      isVerified: isVerified ?? this.isVerified,
      content: content ?? this.content,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      replyCount: replyCount ?? this.replyCount,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  // Check if post has images
  bool get hasImages => images.isNotEmpty;

  // Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return "${difference.inDays}d";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m";
    } else {
      return "now";
    }
  }
}
