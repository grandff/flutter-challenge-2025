import 'package:flutter/material.dart';
import '../models/pomodoro_model.dart';

class TimerDisplayWidget extends StatelessWidget {
  final PomodoroModel pomodoroState;

  const TimerDisplayWidget({
    super.key,
    required this.pomodoroState,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = pomodoroState.currentMinutes.toString().padLeft(2, '0');
    final seconds = pomodoroState.currentSeconds.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Minutes card
          _buildTimeCard(minutes),

          // Colon separator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),

          // Seconds card
          _buildTimeCard(seconds),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String time) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main time display
          Center(
            child: Text(
              time,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),

          // Top layer effect (paper flip effect)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
