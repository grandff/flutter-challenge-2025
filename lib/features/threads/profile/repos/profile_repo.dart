import '../models/profile_model.dart';
import '../models/post_model.dart';

class ProfileRepo {
  // Get profile data
  Future<ProfileModel> getProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return ProfileModel(
      id: "1",
      username: "jane_mobbin",
      fullName: "Jane",
      bio: "Plant enthusiast!",
      profileImage: "assets/images/face13.jpeg",
      followersCount: 2,
      isVerified: false,
      threadsNetLink: "threads.net",
    );
  }

  // Get threads (posts)
  Future<List<PostModel>> getThreads() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      PostModel(
        id: "1",
        userId: "jane_mobbin",
        username: "jane_mobbin",
        profileImage: "assets/images/face13.jpeg",
        content:
            "Give @john_mobbin a follow if you want to see more travel content!",
        timeAgo: "5h",
        isVerified: false,
        postType: PostType.thread,
        repliesCount: 3,
        likesCount: 12,
        repostsCount: 2,
      ),
      PostModel(
        id: "2",
        userId: "jane_mobbin",
        username: "jane_mobbin",
        profileImage: "assets/images/face13.jpeg",
        content: "Tea. Spillage.",
        timeAgo: "6h",
        isVerified: false,
        postType: PostType.thread,
        quotedPost: PostModel(
          id: "quoted_1",
          userId: "iwetmyyplants",
          username: "iwetmyyplants",
          profileImage: "assets/images/face14.jpeg",
          content:
              "I'm just going to say what we are all thinking and knowing is about to go downity down: There is about to be some piping hot tea spillage on here daily that people will be...",
          timeAgo: "6h",
          isVerified: true,
          postType: PostType.thread,
          repliesCount: 256,
        ),
        repliesCount: 8,
        likesCount: 24,
        repostsCount: 5,
      ),
    ];
  }

  // Get replies
  Future<List<PostModel>> getReplies() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      PostModel(
        id: "reply_1",
        userId: "john_mobbin",
        username: "john_mobbin",
        profileImage: "assets/images/face15.jpeg",
        content: "Always a dream to see the Medina in Morocco!",
        timeAgo: "5h",
        isVerified: false,
        postType: PostType.reply,
        quotedPost: PostModel(
          id: "quoted_2",
          userId: "earthpix",
          username: "earthpix",
          profileImage: "assets/images/face16.jpeg",
          content:
              "What is one place you're absolutely traveling to by next year?",
          timeAgo: "5h",
          isVerified: true,
          postType: PostType.thread,
          repliesCount: 256,
        ),
        repliesCount: 2,
        likesCount: 8,
        repostsCount: 1,
      ),
      PostModel(
        id: "reply_2",
        userId: "jane_mobbin",
        username: "jane_mobbin",
        profileImage: "assets/images/face13.jpeg",
        content: "See you there!",
        timeAgo: "5h",
        isVerified: false,
        postType: PostType.reply,
        quotedPost: PostModel(
          id: "quoted_2",
          userId: "earthpix",
          username: "earthpix",
          profileImage: "assets/images/face16.jpeg",
          content:
              "What is one place you're absolutely traveling to by next year?",
          timeAgo: "5h",
          isVerified: true,
          postType: PostType.thread,
          repliesCount: 256,
        ),
        repliesCount: 1,
        likesCount: 5,
        repostsCount: 0,
      ),
      PostModel(
        id: "reply_3",
        userId: "iwetmyyplants",
        username: "iwetmyyplants",
        profileImage: "assets/images/face14.jpeg",
        content: "Can't wait to see what happens next!",
        timeAgo: "6h",
        isVerified: true,
        postType: PostType.reply,
        repliesCount: 0,
        likesCount: 3,
        repostsCount: 0,
      ),
    ];
  }
}











