import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_model.dart';
import '../repos/search_repo.dart';

final searchRepoProvider = Provider<SearchRepo>((ref) {
  return SearchRepo();
});

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final repo = ref.read(searchRepoProvider);
  return SearchViewModel(repo);
});

class SearchState {
  final List<SearchModel> users;
  final bool isLoading;
  final String? error;
  final String query;

  SearchState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  SearchState copyWith({
    List<SearchModel>? users,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return SearchState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}

class SearchViewModel extends StateNotifier<SearchState> {
  final SearchRepo _repo;

  SearchViewModel(this._repo) : super(SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(query: '', users: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null, query: query);

    try {
      final users = await _repo.searchUsers(query);
      state = state.copyWith(
        users: users,
        isLoading: false,
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
      final users = await _repo.getTrendingUsers();
      state = state.copyWith(
        users: users,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(query: '', users: []);
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
