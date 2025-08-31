import 'package:flutter/material.dart';
import 'package:flutter_study/constants/sizes.dart';

class NavItemWidget extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItemWidget({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.size8),
        child: Icon(
          icon,
          color: isSelected 
              ? Theme.of(context).iconTheme.color 
              : Theme.of(context).iconTheme.color?.withOpacity(0.3),
          size: Sizes.size28,
        ),
      ),
    );
  }
}
