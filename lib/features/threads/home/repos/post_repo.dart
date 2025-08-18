import '../models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts();
  Future<PostModel> getPostById(String id);
  Future<void> createPost(PostModel post);
  Future<void> updatePost(PostModel post);
  Future<void> deletePost(String id);
  Future<void> likePost(String postId, String userId);
  Future<void> unlikePost(String postId, String userId);
}

class PostRepositoryImpl implements PostRepository {
  @override
  Future<List<PostModel>> getPosts() async {
    // TODO: Implement actual API call
    // For now, return mock data
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      PostModel(
        id: "1",
        userId: "user1",
        username: "tropicalseductions",
        userProfileImage: "assets/images/face1.jpeg",
        isVerified: true,
        content: "Drop a comment here to test things out.",
        images: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        replyCount: 2,
        likeCount: 4,
        likedBy: ["user2", "user3"],
      ),
      PostModel(
        id: "2",
        userId: "user2",
        username: "shityoushouldcareabout",
        userProfileImage: "assets/images/face2.jpeg",
        isVerified: false,
        content:
            "my phone feels like a vibrator with all these notifications rn",
        images: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        replyCount: 64,
        likeCount: 631,
        likedBy: ["user1", "user3", "user4"],
      ),
      PostModel(
        id: "3",
        userId: "user3",
        username: "_plantswithkrystal_",
        userProfileImage: "assets/images/face3.jpeg",
        isVerified: true,
        content:
            "If you're reading this, go water that thirsty plant. You're welcome 😊",
        images: [],
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        replyCount: 8,
        likeCount: 74,
        likedBy: ["user1", "user2"],
      ),
      PostModel(
        id: "4",
        userId: "user4",
        username: "terracottacoco",
        userProfileImage: "assets/images/face4.jpeg",
        isVerified: false,
        content: "How do you do, fellow kids?",
        images: [
          "assets/images/1.png",
          "assets/images/2.png",
          "assets/images/3.png",
          "assets/images/4.png",
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        replyCount: 12,
        likeCount: 89,
        likedBy: ["user1", "user2", "user3"],
      ),
      PostModel(
        id: "5",
        userId: "user5",
        username: "techguru",
        userProfileImage: "assets/images/face5.jpeg",
        isVerified: true,
        content: "Just deployed a new feature! 🚀",
        images: [
          "assets/images/1.png",
          "assets/images/2.png",
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        replyCount: 15,
        likeCount: 120,
        likedBy: ["user1", "user2", "user3", "user4"],
      ),
      PostModel(
        id: "6",
        userId: "user6",
        username: "foodlover",
        userProfileImage: "assets/images/face6.jpeg",
        isVerified: false,
        content: "Made the most delicious pasta tonight! 🍝",
        images: [
          "assets/images/3.png",
          "assets/images/4.png",
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        replyCount: 8,
        likeCount: 67,
        likedBy: ["user1", "user3"],
      ),
      PostModel(
        id: "7",
        userId: "user7",
        username: "travelbug",
        userProfileImage: "assets/images/face7.jpeg",
        isVerified: false,
        content: "Exploring the world one city at a time! ✈️",
        images: [
          "assets/images/1.png",
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        replyCount: 5,
        likeCount: 45,
        likedBy: ["user1", "user2", "user4"],
      ),
      PostModel(
        id: "8",
        userId: "user8",
        username: "bookworm",
        userProfileImage: "assets/images/face8.jpeg",
        isVerified: true,
        content: "Just finished reading an amazing book! 📚",
        images: [],
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        replyCount: 3,
        likeCount: 28,
        likedBy: ["user1", "user3"],
      ),
      PostModel(
        id: "9",
        userId: "user9",
        username: "fitnessguru",
        userProfileImage: "assets/images/face9.jpeg",
        isVerified: false,
        content: "Morning workout complete! 💪",
        images: [
          "assets/images/2.png",
          "assets/images/3.png",
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        replyCount: 7,
        likeCount: 56,
        likedBy: ["user2", "user4", "user5"],
      ),
      PostModel(
        id: "10",
        userId: "user10",
        username: "musiclover",
        userProfileImage: "assets/images/face10.jpeg",
        isVerified: true,
        content: "New album dropped! 🎵",
        images: [],
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        replyCount: 12,
        likeCount: 89,
        likedBy: ["user1", "user2", "user3", "user6"],
      ),
      PostModel(
        id: "11",
        userId: "user11",
        username: "artcollector",
        userProfileImage: "assets/images/face11.jpeg",
        isVerified: false,
        content: "Beautiful sunset today! 🌅",
        images: [
          "assets/images/4.png",
        ],
        createdAt: DateTime.now(),
        replyCount: 4,
        likeCount: 34,
        likedBy: ["user7", "user8"],
      ),
      PostModel(
        id: "12",
        userId: "user12",
        username: "coffeelover",
        userProfileImage: "assets/images/face12.jpeg",
        isVerified: false,
        content: "Perfect cup of coffee ☕",
        images: [],
        createdAt: DateTime.now(),
        replyCount: 2,
        likeCount: 23,
        likedBy: ["user9", "user10"],
      ),
      PostModel(
        id: "13",
        userId: "user13",
        username: "petparent",
        userProfileImage: "assets/images/face13.jpeg",
        isVerified: false,
        content: "My dog is the best! 🐕",
        images: [
          "assets/images/1.png",
          "assets/images/2.png",
        ],
        createdAt: DateTime.now(),
        replyCount: 6,
        likeCount: 41,
        likedBy: ["user11", "user12"],
      ),
      PostModel(
        id: "14",
        userId: "user14",
        username: "gamer",
        userProfileImage: "assets/images/face14.jpeg",
        isVerified: true,
        content: "New game release! 🎮",
        images: [],
        createdAt: DateTime.now(),
        replyCount: 9,
        likeCount: 67,
        likedBy: ["user1", "user3", "user5", "user7"],
      ),
      PostModel(
        id: "15",
        userId: "user15",
        username: "photographer",
        userProfileImage: "assets/images/face15.jpeg",
        isVerified: false,
        content: "Captured this amazing moment 📸",
        images: [
          "assets/images/3.png",
          "assets/images/4.png",
        ],
        createdAt: DateTime.now(),
        replyCount: 5,
        likeCount: 38,
        likedBy: ["user2", "user4", "user6"],
      ),
      PostModel(
        id: "16",
        userId: "user16",
        username: "chef",
        userProfileImage: "assets/images/face16.jpeg",
        isVerified: true,
        content: "Homemade pasta tonight! 🍝",
        images: [
          "assets/images/1.png",
        ],
        createdAt: DateTime.now(),
        replyCount: 8,
        likeCount: 52,
        likedBy: ["user8", "user9", "user10"],
      ),
    ];
  }

  @override
  Future<PostModel> getPostById(String id) async {
    // TODO: Implement actual API call
    final posts = await getPosts();
    return posts.firstWhere((post) => post.id == id);
  }

  @override
  Future<void> createPost(PostModel post) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> updatePost(PostModel post) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deletePost(String id) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
