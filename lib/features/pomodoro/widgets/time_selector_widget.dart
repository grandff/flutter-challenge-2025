import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/pomodoro_view_model.dart';

class TimeSelectorWidget extends ConsumerWidget {
  const TimeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(pomodoroViewModelProvider);
    final viewModel = ref.read(pomodoroViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: viewModel.timeOptions.map((minutes) {
          final isSelected = pomodoroState.selectedMinutes == minutes;

          return GestureDetector(
            onTap: () => viewModel.selectTime(minutes),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                minutes.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.red[700]
                      : Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
