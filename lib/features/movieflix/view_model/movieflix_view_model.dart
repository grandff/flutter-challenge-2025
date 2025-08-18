import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../repos/movie_repo.dart';

class MovieflixState {
  final List<MovieModel> popular;
  final List<MovieModel> nowPlaying;
  final List<MovieModel> comingSoon;
  final bool isLoading;
  final String? errorMessage;

  const MovieflixState({
    required this.popular,
    required this.nowPlaying,
    required this.comingSoon,
    required this.isLoading,
    this.errorMessage,
  });

  const MovieflixState.initial()
      : popular = const [],
        nowPlaying = const [],
        comingSoon = const [],
        isLoading = false,
        errorMessage = null;

  MovieflixState copyWith({
    List<MovieModel>? popular,
    List<MovieModel>? nowPlaying,
    List<MovieModel>? comingSoon,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MovieflixState(
      popular: popular ?? this.popular,
      nowPlaying: nowPlaying ?? this.nowPlaying,
      comingSoon: comingSoon ?? this.comingSoon,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MovieflixViewModel extends StateNotifier<MovieflixState> {
  final MovieRepo _repo;

  MovieflixViewModel(this._repo) : super(const MovieflixState.initial()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await Future.wait([
        _repo.fetchPopular(),
        _repo.fetchNowPlaying(),
        _repo.fetchComingSoon(),
      ]);

      state = state.copyWith(
        popular: results[0],
        nowPlaying: results[1],
        comingSoon: results[2],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final movieRepoProvider = Provider<MovieRepo>((ref) => MovieRepo());

final movieflixProvider =
    StateNotifierProvider<MovieflixViewModel, MovieflixState>((ref) {
  final repo = ref.watch(movieRepoProvider);
  return MovieflixViewModel(repo);
});

final movieDetailProvider =
    FutureProvider.family<MovieModel, int>((ref, id) async {
  final repo = ref.watch(movieRepoProvider);
  return repo.fetchDetail(id);
});
