import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_model.dart';

class PomodoroRepo {
  Timer? _timer;
  final StreamController<PomodoroModel> _timerController =
      StreamController<PomodoroModel>.broadcast();

  Stream<PomodoroModel> get timerStream => _timerController.stream;

  // Save pomodoro state (placeholder for future Firebase integration)
  Future<void> savePomodoroState(PomodoroModel state) async {
    // TODO: Implement Firebase save functionality
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Load pomodoro state (placeholder for future Firebase integration)
  Future<PomodoroModel> loadPomodoroState() async {
    // TODO: Implement Firebase load functionality
    await Future.delayed(const Duration(milliseconds: 100));
    return PomodoroModel.empty();
  }

  // Start timer
  void startTimer(
      PomodoroModel currentState, Function(PomodoroModel) onUpdate) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentState.totalSeconds <= 0) {
        _handleTimerComplete(currentState, onUpdate);
        return;
      }

      final newState = currentState.copyWith(
        currentSeconds: currentState.currentSeconds > 0
            ? currentState.currentSeconds - 1
            : 59,
        currentMinutes: currentState.currentSeconds > 0
            ? currentState.currentMinutes
            : currentState.currentMinutes - 1,
      );

      onUpdate(newState);
      _timerController.add(newState);
    });
  }

  // Pause timer
  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Reset timer
  PomodoroModel resetTimer(PomodoroModel currentState) {
    _timer?.cancel();
    _timer = null;

    return currentState.copyWith(
      currentMinutes: currentState.selectedMinutes,
      currentSeconds: 0,
      isRunning: false,
      isPaused: false,
    );
  }

  // Handle timer completion
  void _handleTimerComplete(
      PomodoroModel currentState, Function(PomodoroModel) onUpdate) {
    _timer?.cancel();
    _timer = null;

    if (currentState.isBreak) {
      // Break finished, start new work session
      final newState = currentState.copyWith(
        currentMinutes: currentState.selectedMinutes,
        currentSeconds: 0,
        isRunning: false,
        isPaused: false,
        isBreak: false,
      );
      onUpdate(newState);
    } else {
      // Work session finished
      final newCompletedCycles = currentState.completedCycles + 1;
      final newCompletedRounds = (newCompletedCycles % 4 == 0)
          ? currentState.completedRounds + 1
          : currentState.completedRounds;

      final newState = currentState.copyWith(
        completedCycles: newCompletedCycles,
        completedRounds: newCompletedRounds,
        isRunning: false,
        isPaused: false,
      );

      // Check if it's time for a break (every 4 cycles)
      if (newCompletedCycles % 4 == 0) {
        // Start 5-minute break
        final breakState = newState.copyWith(
          currentMinutes: 5,
          currentSeconds: 0,
          isBreak: true,
        );
        onUpdate(breakState);
      } else {
        // Reset for next work session
        final resetState = newState.copyWith(
          currentMinutes: currentState.selectedMinutes,
          currentSeconds: 0,
        );
        onUpdate(resetState);
      }
    }
  }

  // Dispose resources
  void dispose() {
    _timer?.cancel();
    _timerController.close();
  }
}

// Provider for PomodoroRepo
final pomodoroRepoProvider = Provider<PomodoroRepo>((ref) {
  final repo = PomodoroRepo();
  ref.onDispose(() => repo.dispose());
  return repo;
});
