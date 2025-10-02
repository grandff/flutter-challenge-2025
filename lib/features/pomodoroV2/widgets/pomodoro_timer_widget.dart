import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/pomodoro_view_model.dart';
import 'circular_progress_painter.dart';

class PomodoroTimerWidget extends ConsumerWidget {
  const PomodoroTimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(PomodoroViewModel.provider);

    return SizedBox(
      width: 300,
      height: 300,
      child: CustomPaint(
        painter: CircularProgressPainter(
          progress: pomodoroState.progress,
          backgroundColor: Colors.grey[300]!,
          progressColor: Colors.red[600]!,
          strokeWidth: 20.0,
        ),
        child: Center(
          child: Text(
            pomodoroState.formattedTime,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}





