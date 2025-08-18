class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String profileImage;
  final bool isVerified;
  final String bio;
  final int followersCount;
  final int followingCount;

  UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.profileImage,
    required this.isVerified,
    required this.bio,
    required this.followersCount,
    required this.followingCount,
  });

  // Returns an empty instance
  UserModel.empty()
      : id = "",
        username = "",
        displayName = "",
        profileImage = "",
        isVerified = false,
        bio = "",
        followersCount = 0,
        followingCount = 0;

  // Creates an instance from a JSON map
  UserModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        username = json["username"] ?? "",
        displayName = json["displayName"] ?? "",
        profileImage = json["profileImage"] ?? "",
        isVerified = json["isVerified"] ?? false,
        bio = json["bio"] ?? "",
        followersCount = json["followersCount"] ?? 0,
        followingCount = json["followingCount"] ?? 0;

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "displayName": displayName,
        "profileImage": profileImage,
        "isVerified": isVerified,
        "bio": bio,
        "followersCount": followersCount,
        "followingCount": followingCount,
      };
}
