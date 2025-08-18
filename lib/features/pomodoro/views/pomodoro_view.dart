import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/pomodoro_view_model.dart';
import '../widgets/timer_display_widget.dart';
import '../widgets/time_selector_widget.dart';
import '../widgets/control_button_widget.dart';
import '../widgets/progress_display_widget.dart';

class PomodoroView extends ConsumerWidget {
  const PomodoroView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(pomodoroViewModelProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD700), // 밝은 노란색
              Color(0xFFFF8C00), // 따뜻한 주황색
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App title
              Container(
                padding: const EdgeInsets.only(
                  top: Sizes.size40,
                  bottom: Sizes.size20,
                ),
                child: const Text(
                  'POMOTIMER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),

              // Timer display
              TimerDisplayWidget(pomodoroState: pomodoroState),

              // Time selector
              const TimeSelectorWidget(),

              // Control button
              const ControlButtonWidget(),

              // Progress display
              const Spacer(),
              const ProgressDisplayWidget(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
