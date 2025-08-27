import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_model.dart';
import '../repos/activity_repo.dart';

final activityRepoProvider = Provider<ActivityRepo>((ref) {
  return ActivityRepo();
});

final activityViewModelProvider =
    StateNotifierProvider<ActivityViewModel, ActivityState>((ref) {
  final repo = ref.read(activityRepoProvider);
  return ActivityViewModel(repo);
});

class ActivityState {
  final List<ActivityModel> activities;
  final bool isLoading;
  final String? error;
  final String currentFilter;

  ActivityState({
    this.activities = const [],
    this.isLoading = false,
    this.error,
    this.currentFilter = 'All',
  });

  ActivityState copyWith({
    List<ActivityModel>? activities,
    bool? isLoading,
    String? error,
    String? currentFilter,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class ActivityViewModel extends StateNotifier<ActivityState> {
  final ActivityRepo _repo;

  ActivityViewModel(this._repo) : super(ActivityState());

  Future<void> loadActivities() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final activities = await _repo.getActivities();
      state = state.copyWith(
        activities: activities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> filterActivities(String filter) async {
    state = state.copyWith(isLoading: true, error: null, currentFilter: filter);

    try {
      final activities = await _repo.getActivitiesByFilter(filter);
      state = state.copyWith(
        activities: activities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void toggleFollow(String userId) {
    final updatedActivities = state.activities.map((activity) {
      if (activity.userId == userId) {
        return ActivityModel(
          id: activity.id,
          userId: activity.userId,
          username: activity.username,
          fullName: activity.fullName,
          profileImage: activity.profileImage,
          activityType: activity.activityType,
          message: activity.message,
          timeAgo: activity.timeAgo,
          isVerified: activity.isVerified,
          isFollowing: !activity.isFollowing,
          postContent: activity.postContent,
        );
      }
      return activity;
    }).toList();

    state = state.copyWith(activities: updatedActivities);
  }
}





