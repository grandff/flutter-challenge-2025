import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_model.dart';
import '../models/post_model.dart';
import '../repos/profile_repo.dart';

final profileRepoProvider = Provider<ProfileRepo>((ref) {
  return ProfileRepo();
});

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  final repo = ref.read(profileRepoProvider);
  return ProfileViewModel(repo);
});

class ProfileState {
  final ProfileModel? profile;
  final List<PostModel> threads;
  final List<PostModel> replies;
  final bool isLoading;
  final String? error;
  final ProfileTab currentTab;

  ProfileState({
    this.profile,
    this.threads = const [],
    this.replies = const [],
    this.isLoading = false,
    this.error,
    this.currentTab = ProfileTab.threads,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    List<PostModel>? threads,
    List<PostModel>? replies,
    bool? isLoading,
    String? error,
    ProfileTab? currentTab,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      threads: threads ?? this.threads,
      replies: replies ?? this.replies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}

enum ProfileTab { threads, replies }

class ProfileViewModel extends StateNotifier<ProfileState> {
  final ProfileRepo _repo;

  ProfileViewModel(this._repo) : super(ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _repo.getProfile();
      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadThreads() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final threads = await _repo.getThreads();
      state = state.copyWith(
        threads: threads,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadReplies() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final replies = await _repo.getReplies();
      state = state.copyWith(
        replies: replies,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void switchTab(ProfileTab tab) {
    state = state.copyWith(currentTab: tab);

    // Load data for the selected tab
    if (tab == ProfileTab.threads && state.threads.isEmpty) {
      loadThreads();
    } else if (tab == ProfileTab.replies && state.replies.isEmpty) {
      loadReplies();
    }
  }

  void toggleLike(String postId) {
    // Update threads
    final updatedThreads = state.threads.map((post) {
      if (post.id == postId) {
        return PostModel(
          id: post.id,
          userId: post.userId,
          username: post.username,
          profileImage: post.profileImage,
          content: post.content,
          timeAgo: post.timeAgo,
          isVerified: post.isVerified,
          postType: post.postType,
          quotedPost: post.quotedPost,
          repliesCount: post.repliesCount,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
          repostsCount: post.repostsCount,
          isLiked: !post.isLiked,
          isReposted: post.isReposted,
        );
      }
      return post;
    }).toList();

    // Update replies
    final updatedReplies = state.replies.map((post) {
      if (post.id == postId) {
        return PostModel(
          id: post.id,
          userId: post.userId,
          username: post.username,
          profileImage: post.profileImage,
          content: post.content,
          timeAgo: post.timeAgo,
          isVerified: post.isVerified,
          postType: post.postType,
          quotedPost: post.quotedPost,
          repliesCount: post.repliesCount,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
          repostsCount: post.repostsCount,
          isLiked: !post.isLiked,
          isReposted: post.isReposted,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(
      threads: updatedThreads,
      replies: updatedReplies,
    );
  }

  void toggleRepost(String postId) {
    // Update threads
    final updatedThreads = state.threads.map((post) {
      if (post.id == postId) {
        return PostModel(
          id: post.id,
          userId: post.userId,
          username: post.username,
          profileImage: post.profileImage,
          content: post.content,
          timeAgo: post.timeAgo,
          isVerified: post.isVerified,
          postType: post.postType,
          quotedPost: post.quotedPost,
          repliesCount: post.repliesCount,
          likesCount: post.likesCount,
          repostsCount:
              post.isReposted ? post.repostsCount - 1 : post.repostsCount + 1,
          isLiked: post.isLiked,
          isReposted: !post.isReposted,
        );
      }
      return post;
    }).toList();

    // Update replies
    final updatedReplies = state.replies.map((post) {
      if (post.id == postId) {
        return PostModel(
          id: post.id,
          userId: post.userId,
          username: post.username,
          profileImage: post.profileImage,
          content: post.content,
          timeAgo: post.timeAgo,
          isVerified: post.isVerified,
          postType: post.postType,
          quotedPost: post.quotedPost,
          repliesCount: post.repliesCount,
          likesCount: post.likesCount,
          repostsCount:
              post.isReposted ? post.repostsCount - 1 : post.repostsCount + 1,
          isLiked: post.isLiked,
          isReposted: !post.isReposted,
        );
      }
      return post;
    }).toList();

    state = state.copyWith(
      threads: updatedThreads,
      replies: updatedReplies,
    );
  }
}























