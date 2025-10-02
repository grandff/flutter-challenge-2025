import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_state_model.dart';

class PomodoroViewModel extends StateNotifier<PomodoroStateModel> {
  PomodoroViewModel() : super(PomodoroStateModel.empty());

  static final provider = StateNotifierProvider<PomodoroViewModel, PomodoroStateModel>(
    (ref) => PomodoroViewModel(),
  );

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (state.status == PomodoroStatus.stopped) {
      _startNewTimer();
    } else if (state.status == PomodoroStatus.paused) {
      _resumeTimer();
    }
  }

  void pauseTimer() {
    if (state.status == PomodoroStatus.running) {
      _timer?.cancel();
      state = state.copyWith(status: PomodoroStatus.paused);
    }
  }

  void stopTimer() {
    _timer?.cancel();
    state = PomodoroStateModel.empty();
  }

  void resetTimer() {
    _timer?.cancel();
    state = PomodoroStateModel.empty();
  }

  void _startNewTimer() {
    state = state.copyWith(
      status: PomodoroStatus.running,
      remainingSeconds: state.totalMinutes * 60,
      progress: 0.0,
    );
    _startCountdown();
  }

  void _resumeTimer() {
    state = state.copyWith(status: PomodoroStatus.running);
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        final newRemainingSeconds = state.remainingSeconds - 1;
        final totalSeconds = state.totalMinutes * 60;
        final newProgress = (totalSeconds - newRemainingSeconds) / totalSeconds;
        
        state = state.copyWith(
          remainingSeconds: newRemainingSeconds,
          progress: newProgress,
        );
      } else {
        _timer?.cancel();
        state = state.copyWith(
          status: PomodoroStatus.stopped,
          progress: 1.0,
        );
      }
    });
  }
}





