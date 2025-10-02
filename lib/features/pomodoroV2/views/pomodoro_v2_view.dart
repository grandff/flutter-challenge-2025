import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/pomodoro_timer_widget.dart';
import '../widgets/control_buttons_widget.dart';

class PomodoroV2View extends ConsumerWidget {
  const PomodoroV2View({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 상단 여백
              SizedBox(height: 60),

              // 타이머 위젯
              PomodoroTimerWidget(),

              // 타이머와 버튼 사이 여백
              SizedBox(height: 80),

              // 컨트롤 버튼들
              ControlButtonsWidget(),

              // 하단 여백
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}





