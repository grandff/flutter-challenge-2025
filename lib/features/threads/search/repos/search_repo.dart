import '../models/search_model.dart';

abstract class SearchRepository {
  Future<List<String>> searchPosts(String query);
  Future<List<String>> searchUsers(String query);
  Future<List<String>> searchTrending();
}

class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<List<String>> searchPosts(String query) async {
    // TODO: Implement actual search API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  @override
  Future<List<String>> searchUsers(String query) async {
    // TODO: Implement actual search API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }

  @override
  Future<List<String>> searchTrending() async {
    // TODO: Implement actual search API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
}
