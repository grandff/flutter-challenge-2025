class PostModel {
  final String id;
  final String userId;
  final String username;
  final String profileImage;
  final String content;
  final String timeAgo;
  final bool isVerified;
  final PostType postType;
  final PostModel? quotedPost;
  final int repliesCount;
  final int likesCount;
  final int repostsCount;
  final bool isLiked;
  final bool isReposted;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.content,
    required this.timeAgo,
    this.isVerified = false,
    this.postType = PostType.thread,
    this.quotedPost,
    this.repliesCount = 0,
    this.likesCount = 0,
    this.repostsCount = 0,
    this.isLiked = false,
    this.isReposted = false,
  });

  // Returns an empty instance
  PostModel.empty()
      : id = "",
        userId = "",
        username = "",
        profileImage = "",
        content = "",
        timeAgo = "",
        isVerified = false,
        postType = PostType.thread,
        quotedPost = null,
        repliesCount = 0,
        likesCount = 0,
        repostsCount = 0,
        isLiked = false,
        isReposted = false;

  // Creates an instance from a JSON map
  PostModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        userId = json["userId"] ?? "",
        username = json["username"] ?? "",
        profileImage = json["profileImage"] ?? "",
        content = json["content"] ?? "",
        timeAgo = json["timeAgo"] ?? "",
        isVerified = json["isVerified"] ?? false,
        postType = PostType.values.firstWhere(
          (e) => e.toString() == 'PostType.${json["postType"] ?? "thread"}',
          orElse: () => PostType.thread,
        ),
        quotedPost = json["quotedPost"] != null
            ? PostModel.fromJson(json: json["quotedPost"])
            : null,
        repliesCount = json["repliesCount"] ?? 0,
        likesCount = json["likesCount"] ?? 0,
        repostsCount = json["repostsCount"] ?? 0,
        isLiked = json["isLiked"] ?? false,
        isReposted = json["isReposted"] ?? false;

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "username": username,
        "profileImage": profileImage,
        "content": content,
        "timeAgo": timeAgo,
        "isVerified": isVerified,
        "postType": postType.toString().split('.').last,
        "quotedPost": quotedPost?.toJson(),
        "repliesCount": repliesCount,
        "likesCount": likesCount,
        "repostsCount": repostsCount,
        "isLiked": isLiked,
        "isReposted": isReposted,
      };
}

enum PostType {
  thread,
  reply,
}























