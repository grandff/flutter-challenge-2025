import 'package:flutter/material.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:hugeicons/hugeicons.dart';

class TwitterAppHeader extends StatelessWidget {
  const TwitterAppHeader({
    super.key,
    this.showCancel = false,
    this.onCancel,
    this.showBack = false,
    this.onBack,
  });

  final bool showCancel;
  final VoidCallback? onCancel;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: Sizes.size56,
      child: Stack(
        children: [
          if (showCancel)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (!showCancel && showBack)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          const Align(
            alignment: Alignment.center,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedNewTwitter,
              size: Sizes.size32,
              color: Color(0xFF1DA1F2),
            ),
          ),
        ],
      ),
    );
  }
}
