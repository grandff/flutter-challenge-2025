import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_model.dart';
import '../repos/search_repo.dart';
import '../../home/models/post_model.dart';
import '../../home/repos/post_repo.dart';

final searchRepoProvider = Provider<SearchRepo>((ref) {
  return SearchRepo();
});

final postRepoProvider = Provider<PostRepo>((ref) {
  return PostRepo();
});

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final searchRepo = ref.read(searchRepoProvider);
  final postRepo = ref.read(postRepoProvider);
  return SearchViewModel(searchRepo, postRepo);
});

class SearchState {
  final List<SearchModel> users;
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;
  final String query;
  final SearchType searchType;

  SearchState({
    this.users = const [],
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
    this.searchType = SearchType.posts,
  });

  SearchState copyWith({
    List<SearchModel>? users,
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
    String? query,
    SearchType? searchType,
  }) {
    return SearchState(
      users: users ?? this.users,
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      query: query ?? this.query,
      searchType: searchType ?? this.searchType,
    );
  }
}

enum SearchType {
  posts,
  users,
}

class SearchViewModel extends StateNotifier<SearchState> {
  final SearchRepo _searchRepo;
  final PostRepo _postRepo;

  SearchViewModel(this._searchRepo, this._postRepo) : super(SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(query: '', users: [], posts: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null, query: query);

    try {
      // 게시글 검색 (기본)
      final posts = await _postRepo.searchPosts(query);
      state = state.copyWith(
        posts: posts,
        users: [], // 게시글 검색 시에는 사용자 목록 초기화
        isLoading: false,
        searchType: SearchType.posts,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(query: '', users: [], posts: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null, query: query);

    try {
      final users = await _searchRepo.searchUsers(query);
      state = state.copyWith(
        users: users,
        posts: [], // 사용자 검색 시에는 게시글 목록 초기화
        isLoading: false,
        searchType: SearchType.users,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadTrendingUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _searchRepo.getTrendingUsers();
      state = state.copyWith(
        users: users,
        posts: [],
        isLoading: false,
        searchType: SearchType.users,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(query: '', users: [], posts: []);
  }

  void setSearchType(SearchType type) {
    state = state.copyWith(searchType: type);
  }

  void toggleFollow(String userId) {
    final updatedUsers = state.users.map((user) {
      if (user.id == userId) {
        return SearchModel(
          id: user.id,
          username: user.username,
          fullName: user.fullName,
          profileImage: user.profileImage,
          followers: user.followers,
          isVerified: user.isVerified,
          isFollowing: !user.isFollowing,
        );
      }
      return user;
    }).toList();

    state = state.copyWith(users: updatedUsers);
  }
}
