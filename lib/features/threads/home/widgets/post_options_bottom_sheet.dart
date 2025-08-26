import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final String postId;
  final String username;
  final VoidCallback? onUnfollow;
  final VoidCallback? onMute;
  final VoidCallback? onHide;
  final VoidCallback? onReport;

  const PostOptionsBottomSheet({
    super.key,
    required this.postId,
    required this.username,
    this.onUnfollow,
    this.onMute,
    this.onHide,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.size16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Sizes.size12),
            width: Sizes.size40,
            height: Sizes.size4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Sizes.size2),
            ),
          ),
          Gaps.v20,
          // Options
          _buildOptionTile(
            context: context,
            title: 'Unfollow $username',
            onTap: onUnfollow,
            textColor: Colors.black,
          ),
          _buildOptionTile(
            context: context,
            title: 'Mute $username',
            onTap: onMute,
            textColor: Colors.black,
          ),
          _buildDivider(),
          _buildOptionTile(
            context: context,
            title: 'Hide',
            onTap: onHide,
            textColor: Colors.black,
          ),
          _buildDivider(),
          _buildOptionTile(
            context: context,
            title: 'Report',
            onTap: onReport,
            textColor: Colors.red,
          ),
          Gaps.v20,
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String title,
    required VoidCallback? onTap,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size20,
          vertical: Sizes.size16,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: Sizes.size16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(horizontal: Sizes.size20),
    );
  }
}
