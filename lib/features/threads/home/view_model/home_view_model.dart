import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../repos/post_repo.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl();
});

final postsProvider = FutureProvider<List<PostModel>>((ref) async {
  final repository = ref.read(postRepositoryProvider);
  return await repository.getPosts();
});

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return HomeViewModel(repository);
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
  final PostRepository _repository;

  HomeViewModel(this._repository) : super(HomeState());

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final posts = await _repository.getPosts();
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
      final posts = await _repository.getPosts();
      state = state.copyWith(posts: posts, isRefreshing: false);
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _repository.likePost(postId, userId);
      // Update local state
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          final newLikedBy = List<String>.from(post.likedBy);
          if (!newLikedBy.contains(userId)) {
            newLikedBy.add(userId);
          }
          return post.copyWith(
            likedBy: newLikedBy,
            likeCount: post.likeCount + 1,
          );
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _repository.unlikePost(postId, userId);
      // Update local state
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          final newLikedBy = List<String>.from(post.likedBy);
          newLikedBy.remove(userId);
          return post.copyWith(
            likedBy: newLikedBy,
            likeCount: post.likeCount - 1,
          );
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      // Handle error
    }
  }

  bool isPostLiked(String postId, String userId) {
    final post = state.posts.firstWhere((post) => post.id == postId);
    return post.likedBy.contains(userId);
  }
}
