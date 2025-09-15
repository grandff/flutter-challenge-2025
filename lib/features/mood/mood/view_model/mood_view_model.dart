import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_model.dart';
import '../repos/mood_repo.dart';
import '../../auth/repos/auth_repo.dart';

class MoodViewModel extends StateNotifier<AsyncValue<List<MoodModel>>> {
  MoodViewModel() : super(const AsyncValue.loading()) {
    _initializeMoods();
  }

  // 무드 목록 초기화
  void _initializeMoods() async {
    try {
      final currentUser = AuthRepo.getCurrentUser();
      if (currentUser != null) {
        await loadMoods();
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 무드 목록 로드
  Future<void> loadMoods() async {
    try {
      state = const AsyncValue.loading();
      final currentUser = AuthRepo.getCurrentUser();
      if (currentUser == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final moods = await MoodRepo.getMoods(userId: currentUser.userId!);
      state = AsyncValue.data(moods);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 무드 생성
  Future<void> createMood({
    required String emoji,
    required String description,
  }) async {
    try {
      final currentUser = AuthRepo.getCurrentUser();
      if (currentUser == null) return;

      final newMood = await MoodRepo.createMood(
        userId: currentUser.userId!,
        emoji: emoji,
        description: description,
      );

      // 현재 상태에 새 무드 추가
      state.whenData((moods) {
        state = AsyncValue.data([newMood, ...moods]);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 무드 삭제
  Future<void> deleteMood({required String moodId}) async {
    try {
      await MoodRepo.deleteMood(moodId: moodId);

      // 현재 상태에서 삭제된 무드 제거
      state.whenData((moods) {
        final updatedMoods = moods.where((mood) => mood.id != moodId).toList();
        state = AsyncValue.data(updatedMoods);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // 무드 업데이트
  Future<void> updateMood({
    required String moodId,
    required String emoji,
    required String description,
  }) async {
    try {
      final updatedMood = await MoodRepo.updateMood(
        moodId: moodId,
        emoji: emoji,
        description: description,
      );

      // 현재 상태에서 무드 업데이트
      state.whenData((moods) {
        final updatedMoods = moods.map((mood) {
          return mood.id == moodId ? updatedMood : mood;
        }).toList();
        state = AsyncValue.data(updatedMoods);
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// MoodViewModel Provider
final moodViewModelProvider =
    StateNotifierProvider<MoodViewModel, AsyncValue<List<MoodModel>>>((ref) {
  return MoodViewModel();
});

// 무드 스트림 Provider (실시간 업데이트)
final moodStreamProvider = StreamProvider<List<MoodModel>>((ref) {
  final currentUser = AuthRepo.getCurrentUser();
  if (currentUser == null) {
    return Stream.value([]);
  }
  return MoodRepo.getMoodsStream(userId: currentUser.userId!);
});
