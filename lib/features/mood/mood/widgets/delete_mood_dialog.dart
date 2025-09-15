import 'package:flutter/material.dart';
import '../../common/widgets/common_button_widget.dart';

class DeleteMoodDialog extends StatelessWidget {
  final String moodDescription;
  final VoidCallback onDelete;

  const DeleteMoodDialog({
    super.key,
    required this.moodDescription,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Delete note',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Are you sure you want to do this?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '"${moodDescription.length > 30 ? '${moodDescription.substring(0, 30)}...' : moodDescription}"',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Column(
          children: [
            // 삭제 버튼
            CommonButtonWidget(
              text: 'Delete',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
            const SizedBox(height: 12),
            // 취소 버튼
            CommonButtonWidget(
              text: 'Cancel',
              backgroundColor: Colors.white,
              textColor: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String moodDescription,
    required VoidCallback onDelete,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return DeleteMoodDialog(
          moodDescription: moodDescription,
          onDelete: onDelete,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0), // 아래에서 시작
            end: Offset.zero, // 원래 위치로
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    );
  }
}
