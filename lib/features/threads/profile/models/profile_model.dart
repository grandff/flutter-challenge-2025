class ProfileModel {
  final String id;
  final String username;
  final String fullName;
  final String bio;
  final String profileImage;
  final int followersCount;
  final bool isVerified;
  final String threadsNetLink;

  ProfileModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.bio,
    required this.profileImage,
    required this.followersCount,
    this.isVerified = false,
    this.threadsNetLink = "threads.net",
  });

  // Returns an empty instance
  ProfileModel.empty()
      : id = "",
        username = "",
        fullName = "",
        bio = "",
        profileImage = "",
        followersCount = 0,
        isVerified = false,
        threadsNetLink = "threads.net";

  // Creates an instance from a JSON map
  ProfileModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        username = json["username"] ?? "",
        fullName = json["fullName"] ?? "",
        bio = json["bio"] ?? "",
        profileImage = json["profileImage"] ?? "",
        followersCount = json["followersCount"] ?? 0,
        isVerified = json["isVerified"] ?? false,
        threadsNetLink = json["threadsNetLink"] ?? "threads.net";

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullName": fullName,
        "bio": bio,
        "profileImage": profileImage,
        "followersCount": followersCount,
        "isVerified": isVerified,
        "threadsNetLink": threadsNetLink,
      };
}


