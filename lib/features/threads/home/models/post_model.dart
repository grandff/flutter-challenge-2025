class PostModel {
  final String id;
  final String userId;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  // 추가 필드들 (기존 코드와의 호환성을 위해)
  final String username;
  final String userProfileImage;
  final bool isVerified;
  final int replyCount;
  final int likeCount;
  final List<String> likedBy;
  final List<String> images;

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.username = '',
    this.userProfileImage = '',
    this.isVerified = false,
    this.replyCount = 0,
    this.likeCount = 0,
    this.likedBy = const [],
    this.images = const [],
  });

  PostModel.empty()
      : id = "",
        userId = "",
        content = "",
        imageUrl = null,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        username = "",
        userProfileImage = "",
        isVerified = false,
        replyCount = 0,
        likeCount = 0,
        likedBy = const [],
        images = const [];

  PostModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        userId = json["user_id"] ?? "",
        content = json["content"] ?? "",
        imageUrl = json["image_url"],
        createdAt = json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt = json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
        username = json["username"] ?? "",
        userProfileImage = json["user_profile_image"] ?? "",
        isVerified = json["is_verified"] ?? false,
        replyCount = json["reply_count"] ?? 0,
        likeCount = json["like_count"] ?? 0,
        likedBy = List<String>.from(json["liked_by"] ?? []),
        images = json["image_url"] != null ? [json["image_url"]] : [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "content": content,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "username": username,
        "user_profile_image": userProfileImage,
        "is_verified": isVerified,
        "reply_count": replyCount,
        "like_count": likeCount,
        "liked_by": likedBy,
        "images": images,
      };

  // copyWith 메서드 추가
  PostModel copyWith({
    String? id,
    String? userId,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? username,
    String? userProfileImage,
    bool? isVerified,
    int? replyCount,
    int? likeCount,
    List<String>? likedBy,
    List<String>? images,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      isVerified: isVerified ?? this.isVerified,
      replyCount: replyCount ?? this.replyCount,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
      images: images ?? this.images,
    );
  }

  // 시간 표시용 getter
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  // 이미지가 있는지 확인
  bool get hasImages => images.isNotEmpty || imageUrl != null;
}
