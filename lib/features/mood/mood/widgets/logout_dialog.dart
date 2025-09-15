import 'package:flutter/material.dart';
import '../../common/widgets/common_button_widget.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Logout',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        'Are you sure you want to logout?',
        style: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Column(
          children: [
            // 로그아웃 버튼
            CommonButtonWidget(
              text: 'Logout',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
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
    required VoidCallback onLogout,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LogoutDialog(
          onLogout: onLogout,
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
