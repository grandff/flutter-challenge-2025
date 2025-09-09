import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../repos/post_repo.dart';

final postRepoProvider = Provider<PostRepo>((ref) => PostRepo());

final postsProvider = FutureProvider<List<PostModel>>((ref) async {
  final postRepo = ref.watch(postRepoProvider);
  return await postRepo.getAllPosts();
});

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final postRepo = ref.read(postRepoProvider);
  return HomeViewModel(postRepo);
});

class HomeState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? error;
  final bool isRefreshing;

  HomeState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
  });

  HomeState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? error,
    bool? isRefreshing,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final PostRepo _postRepo;

  HomeViewModel(this._postRepo) : super(HomeState());

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final posts = await _postRepo.getAllPosts();
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refreshPosts() async {
    state = state.copyWith(isRefreshing: true);

    try {
      final posts = await _postRepo.getAllPosts();
      state = state.copyWith(posts: posts, isRefreshing: false);
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }

  // TODO: 좋아요 기능은 추후 구현 예정
  // Future<void> likePost(String postId, String userId) async {
  //   // 좋아요 기능 구현 예정
  // }

  // Future<void> unlikePost(String postId, String userId) async {
  //   // 좋아요 취소 기능 구현 예정
  // }

  // bool isPostLiked(String postId, String userId) {
  //   final post = state.posts.firstWhere((post) => post.id == postId);
  //   return post.likedBy.contains(userId);
  // }
}
