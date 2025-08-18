import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repos/search_repo.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});

final searchViewModelProvider =
    StateNotifierProvider<SearchViewModel, SearchState>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SearchViewModel(repository);
});

class SearchState {
  final String query;
  final List<String> results;
  final bool isLoading;
  final String? error;

  SearchState({
    this.query = "",
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<String>? results,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SearchViewModel extends StateNotifier<SearchState> {
  final SearchRepository _repository;

  SearchViewModel(this._repository) : super(SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(query: "", results: []);
      return;
    }

    state = state.copyWith(query: query, isLoading: true, error: null);

    try {
      final results = await _repository.searchPosts(query);
      state = state.copyWith(results: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(query: "", results: []);
  }
}
