import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../models/search_model.dart';
import '../view_model/search_view_model.dart';

class UserProfileWidget extends ConsumerWidget {
  final SearchModel user;

  const UserProfileWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size16,
        vertical: Sizes.size12,
      ),
      child: Row(
        children: [
          // Profile image
          CircleAvatar(
            radius: Sizes.size24,
            backgroundImage: AssetImage(user.profileImage),
          ),
          const SizedBox(width: Sizes.size12),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    if (user.isVerified) ...[
                      const SizedBox(width: Sizes.size4),
                      Icon(
                        Icons.verified,
                        size: Sizes.size16,
                        color: Colors.blue[600],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: Sizes.size2),
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: Sizes.size2),
                Text(
                  user.followers,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          // Follow button
          Container(
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(searchViewModelProvider.notifier)
                    .toggleFollow(user.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: user.isFollowing
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).primaryColor,
                foregroundColor: user.isFollowing
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context).colorScheme.onPrimary,
                side: user.isFollowing
                    ? BorderSide(color: Theme.of(context).dividerColor)
                    : BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size16,
                  vertical: Sizes.size8,
                ),
                elevation: 0,
              ),
              child: Text(
                user.isFollowing ? "Following" : "Follow",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: user.isFollowing
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
