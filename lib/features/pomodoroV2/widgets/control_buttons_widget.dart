import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/pomodoro_view_model.dart';
import '../models/pomodoro_state_model.dart';

class ControlButtonsWidget extends ConsumerWidget {
  const ControlButtonsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(PomodoroViewModel.provider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 재설정 버튼
        _buildControlButton(
          icon: Icons.refresh,
          onPressed: () =>
              ref.read(PomodoroViewModel.provider.notifier).resetTimer(),
          isActive: false,
        ),
        const SizedBox(width: 20),
        // 재생/일시정지 버튼 (메인)
        _buildMainControlButton(
          pomodoroState: pomodoroState,
          onPressed: () {
            if (pomodoroState.status == PomodoroStatus.running) {
              ref.read(PomodoroViewModel.provider.notifier).pauseTimer();
            } else {
              ref.read(PomodoroViewModel.provider.notifier).startTimer();
            }
          },
        ),
        const SizedBox(width: 20),
        // 중지 버튼
        _buildControlButton(
          icon: Icons.stop,
          onPressed: () =>
              ref.read(PomodoroViewModel.provider.notifier).stopTimer(),
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isActive ? Colors.red[600] : Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMainControlButton({
    required PomodoroStateModel pomodoroState,
    required VoidCallback onPressed,
  }) {
    IconData icon;
    bool isActive = false;

    switch (pomodoroState.status) {
      case PomodoroStatus.stopped:
        icon = Icons.play_arrow;
        isActive = true;
        break;
      case PomodoroStatus.running:
        icon = Icons.pause;
        isActive = true;
        break;
      case PomodoroStatus.paused:
        icon = Icons.play_arrow;
        isActive = true;
        break;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isActive ? Colors.red[600] : Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}





