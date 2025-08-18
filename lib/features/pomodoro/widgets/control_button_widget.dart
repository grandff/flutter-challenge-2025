import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/pomodoro_view_model.dart';

class ControlButtonWidget extends ConsumerWidget {
  const ControlButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(pomodoroViewModelProvider);
    final viewModel = ref.read(pomodoroViewModelProvider.notifier);

    IconData iconData;
    if (pomodoroState.isRunning) {
      iconData = Icons.pause;
    } else if (pomodoroState.isPaused) {
      iconData = Icons.play_arrow;
    } else {
      iconData = Icons.play_arrow;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () => viewModel.toggleTimer(),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red[700],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            iconData,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
