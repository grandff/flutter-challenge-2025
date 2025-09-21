import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodCardWidget extends StatelessWidget {
  final MoodModel mood;
  final VoidCallback? onLongPress;

  const MoodCardWidget({
    super.key,
    required this.mood,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF66C2B0), // 틸/민트 그린 배경
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 무드 이모지와 설명
            Row(
              children: [
                Text(
                  'Mood: ${mood.emoji}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 무드 설명
            Text(
              mood.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // 시간 정보
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                mood.relativeTime,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





