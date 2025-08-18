import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_model.dart';
import '../repos/pomodoro_repo.dart';

class PomodoroViewModel extends StateNotifier<PomodoroModel> {
  final PomodoroRepo _repo;

  PomodoroViewModel(this._repo) : super(PomodoroModel.empty()) {
    _loadInitialState();
  }

  // Load initial state
  Future<void> _loadInitialState() async {
    final savedState = await _repo.loadPomodoroState();
    state = savedState;
  }

  // Select time duration
  void selectTime(int minutes) {
    state = state.copyWith(
      selectedMinutes: minutes,
      currentMinutes: minutes,
      currentSeconds: 0,
      isRunning: false,
      isPaused: false,
    );
  }

  // Start timer
  void startTimer() {
    if (state.isRunning) return;

    state = state.copyWith(
      isRunning: true,
      isPaused: false,
    );

    _repo.startTimer(state, (newState) {
      state = newState;
    });
  }

  // Pause timer
  void pauseTimer() {
    if (!state.isRunning) return;

    _repo.pauseTimer();
    state = state.copyWith(
      isRunning: false,
      isPaused: true,
    );
  }

  // Resume timer
  void resumeTimer() {
    if (state.isRunning || !state.isPaused) return;

    // 현재 상태를 그대로 유지하면서 타이머만 재시작
    final currentState = state;

    _repo.startTimer(currentState, (newState) {
      state = newState.copyWith(
        isRunning: true,
        isPaused: false,
      );
    });
  }

  // Reset timer
  void resetTimer() {
    _repo.pauseTimer();
    state = _repo.resetTimer(state);
  }

  // Toggle timer (start/pause/resume)
  void toggleTimer() {
    if (state.isRunning) {
      pauseTimer();
    } else if (state.isPaused) {
      resumeTimer();
    } else {
      startTimer();
    }
  }

  // Get available time options
  List<int> get timeOptions => [15, 20, 25, 30, 35];

  // Get progress percentage
  double get progressPercentage {
    final totalSeconds = state.selectedMinutes * 60;
    final remainingSeconds = state.totalSeconds;
    return ((totalSeconds - remainingSeconds) / totalSeconds).clamp(0.0, 1.0);
  }

  // Check if timer is in break mode
  bool get isInBreak => state.isBreak;

  // Get current session type text
  String get sessionTypeText => state.isBreak ? '휴식 시간' : '작업 시간';

  // Save state
  Future<void> saveState() async {
    await _repo.savePomodoroState(state);
  }

  @override
  void dispose() {
    _repo.pauseTimer();
    super.dispose();
  }
}

// Provider for PomodoroViewModel
final pomodoroViewModelProvider =
    StateNotifierProvider<PomodoroViewModel, PomodoroModel>((ref) {
  final repo = ref.watch(pomodoroRepoProvider);
  return PomodoroViewModel(repo);
});
