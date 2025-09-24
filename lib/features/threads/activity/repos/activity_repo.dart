import '../models/activity_model.dart';

class ActivityRepo {
  // Get sample activity data
  Future<List<ActivityModel>> getActivities() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ActivityModel(
        id: "1",
        userId: "john_mobbin",
        username: "john_mobbin",
        fullName: "John Mobbin",
        profileImage: "assets/images/face1.jpeg",
        activityType: "Mentioned you",
        message:
            "Here's a thread you should follow if you love botany @jane_mobbin",
        timeAgo: "4h",
        isVerified: false,
        isFollowing: false,
      ),
      ActivityModel(
        id: "2",
        userId: "john_mobbin",
        username: "john_mobbin",
        fullName: "John Mobbin",
        profileImage: "assets/images/face2.jpeg",
        activityType: "Replied to",
        message: "Starting out my gardening club with thr... Count me in!",
        timeAgo: "4h",
        isVerified: false,
        isFollowing: false,
      ),
      ActivityModel(
        id: "3",
        userId: "the.plantdads",
        username: "the.plantdads",
        fullName: "THE PLANT DADS",
        profileImage: "assets/images/face3.jpeg",
        activityType: "Followed you",
        message: "",
        timeAgo: "5h",
        isVerified: true,
        isFollowing: true,
      ),
      ActivityModel(
        id: "4",
        userId: "the.plantdads",
        username: "the.plantdads",
        fullName: "THE PLANT DADS",
        profileImage: "assets/images/face4.jpeg",
        activityType: "Liked",
        message: "Definitely broken! 🧵👀🌱",
        timeAgo: "5h",
        isVerified: true,
        isFollowing: true,
      ),
      ActivityModel(
        id: "5",
        userId: "theberryjungle",
        username: "theberryjungle",
        fullName: "The Berry Jungle",
        profileImage: "assets/images/face5.jpeg",
        activityType: "Liked",
        message: "🌱👀🧵",
        timeAgo: "5h",
        isVerified: false,
        isFollowing: false,
      ),
    ];
  }

  // Get activities by filter
  Future<List<ActivityModel>> getActivitiesByFilter(String filter) async {
    final allActivities = await getActivities();

    switch (filter.toLowerCase()) {
      case 'replies':
        return allActivities
            .where((activity) =>
                activity.activityType.toLowerCase().contains('replied'))
            .toList();
      case 'mentions':
        return allActivities
            .where((activity) =>
                activity.activityType.toLowerCase().contains('mentioned'))
            .toList();
      case 'verified':
        return allActivities.where((activity) => activity.isVerified).toList();
      default:
        return allActivities;
    }
  }
}
























