import '../models/search_model.dart';

class SearchRepo {
  // Get sample search results (user profiles)
  Future<List<SearchModel>> searchUsers(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Sample data based on the image
    final allUsers = [
      SearchModel(
        id: "1",
        username: "rjmithun",
        fullName: "Mithun",
        profileImage: "assets/images/face6.jpeg",
        followers: "26.6K followers",
        isVerified: false,
        isFollowing: false,
      ),
      SearchModel(
        id: "2",
        username: "vicenews",
        fullName: "VICE News",
        profileImage: "assets/images/face7.jpeg",
        followers: "301K followers",
        isVerified: true,
        isFollowing: false,
      ),
      SearchModel(
        id: "3",
        username: "trevornoah",
        fullName: "Trevor Noah",
        profileImage: "assets/images/face8.jpeg",
        followers: "789K followers",
        isVerified: true,
        isFollowing: false,
      ),
      SearchModel(
        id: "4",
        username: "condenasttraveller",
        fullName: "Condé Nast Traveller",
        profileImage: "assets/images/face9.jpeg",
        followers: "130K followers",
        isVerified: true,
        isFollowing: false,
      ),
      SearchModel(
        id: "5",
        username: "chef_pillai",
        fullName: "Suresh Pillai",
        profileImage: "assets/images/face10.jpeg",
        followers: "69.2K followers",
        isVerified: false,
        isFollowing: false,
      ),
      SearchModel(
        id: "6",
        username: "malala",
        fullName: "Malala Yousafzai",
        profileImage: "assets/images/face11.jpeg",
        followers: "237K followers",
        isVerified: true,
        isFollowing: false,
      ),
      SearchModel(
        id: "7",
        username: "sebin_cyriac",
        fullName: "Fishing_freaks",
        profileImage: "assets/images/face12.jpeg",
        followers: "53.2K followers",
        isVerified: false,
        isFollowing: false,
      ),
    ];

    if (query.isEmpty) {
      return allUsers;
    }

    // Filter users based on query
    return allUsers.where((user) {
      final queryLower = query.toLowerCase();
      return user.username.toLowerCase().contains(queryLower) ||
          user.fullName.toLowerCase().contains(queryLower);
    }).toList();
  }

  // Get trending users (for empty search state)
  Future<List<SearchModel>> getTrendingUsers() async {
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      SearchModel(
        id: "1",
        username: "rjmithun",
        fullName: "Mithun",
        profileImage: "assets/images/face6.jpeg",
        followers: "26.6K followers",
        isVerified: false,
        isFollowing: false,
      ),
      SearchModel(
        id: "2",
        username: "vicenews",
        fullName: "VICE News",
        profileImage: "assets/images/face7.jpeg",
        followers: "301K followers",
        isVerified: true,
        isFollowing: false,
      ),
      SearchModel(
        id: "3",
        username: "trevornoah",
        fullName: "Trevor Noah",
        profileImage: "assets/images/face8.jpeg",
        followers: "789K followers",
        isVerified: true,
        isFollowing: false,
      ),
    ];
  }
}
