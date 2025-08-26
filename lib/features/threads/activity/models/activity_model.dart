class ActivityModel {
  final String id;
  final String userId;
  final String username;
  final String fullName;
  final String profileImage;
  final String
      activityType; // "Mentioned you", "Followed you", "Replied to", "Liked"
  final String message;
  final String timeAgo;
  final bool isVerified;
  final bool isFollowing;
  final String? postContent;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.profileImage,
    required this.activityType,
    required this.message,
    required this.timeAgo,
    this.isVerified = false,
    this.isFollowing = false,
    this.postContent,
  });

  // Returns an empty instance
  ActivityModel.empty()
      : id = "",
        userId = "",
        username = "",
        fullName = "",
        profileImage = "",
        activityType = "",
        message = "",
        timeAgo = "",
        isVerified = false,
        isFollowing = false,
        postContent = null;

  // Creates an instance from a JSON map
  ActivityModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        userId = json["userId"] ?? "",
        username = json["username"] ?? "",
        fullName = json["fullName"] ?? "",
        profileImage = json["profileImage"] ?? "",
        activityType = json["activityType"] ?? "",
        message = json["message"] ?? "",
        timeAgo = json["timeAgo"] ?? "",
        isVerified = json["isVerified"] ?? false,
        isFollowing = json["isFollowing"] ?? false,
        postContent = json["postContent"];

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "username": username,
        "fullName": fullName,
        "profileImage": profileImage,
        "activityType": activityType,
        "message": message,
        "timeAgo": timeAgo,
        "isVerified": isVerified,
        "isFollowing": isFollowing,
        "postContent": postContent,
      };
}



