import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/pomodoro_view_model.dart';

class ProgressDisplayWidget extends ConsumerWidget {
  const ProgressDisplayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(pomodoroViewModelProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Rounds display
          _buildProgressItem(
            completed: pomodoroState.completedRounds,
            total: 4,
            label: 'ROUND',
          ),

          // Goals display
          _buildProgressItem(
            completed: pomodoroState.completedCycles,
            total: 12,
            label: 'GOAL',
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem({
    required int completed,
    required int total,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          '$completed/$total',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
