import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../models/activity_model.dart';
import '../view_model/activity_view_model.dart';

class ActivityItemWidget extends ConsumerWidget {
  final ActivityModel activity;

  const ActivityItemWidget({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size16,
        vertical: Sizes.size12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image with activity icon overlay
          Stack(
            children: [
              CircleAvatar(
                radius: Sizes.size20,
                backgroundImage: AssetImage(activity.profileImage),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: Sizes.size16,
                  height: Sizes.size16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: _getActivityIcon(),
                ),
              ),
            ],
          ),
          const SizedBox(width: Sizes.size12),
          // Activity content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      activity.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    if (activity.isVerified) ...[
                      const SizedBox(width: Sizes.size4),
                      Icon(
                        Icons.verified,
                        size: Sizes.size16,
                        color: Colors.blue[600],
                      ),
                    ],
                    const Spacer(),
                    Text(
                      activity.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                if (activity.activityType.isNotEmpty) ...[
                  const SizedBox(height: Sizes.size2),
                  Text(
                    activity.activityType,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (activity.message.isNotEmpty) ...[
                  const SizedBox(height: Sizes.size4),
                  Text(
                    activity.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Follow button (only for follow activities)
          if (activity.activityType == "Followed you")
            Container(
              margin: const EdgeInsets.only(left: Sizes.size8),
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(activityViewModelProvider.notifier)
                      .toggleFollow(activity.userId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey[600],
                  side: BorderSide(color: Colors.grey[300]!),
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
                  activity.isFollowing ? "Following" : "Follow",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        activity.isFollowing ? Colors.grey[600] : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _getActivityIcon() {
    switch (activity.activityType) {
      case "Mentioned you":
        return Icon(
          Icons.alternate_email,
          size: Sizes.size12,
          color: Colors.green[600],
        );
      case "Replied to":
        return Icon(
          Icons.reply,
          size: Sizes.size12,
          color: Colors.blue[600],
        );
      case "Followed you":
        return Icon(
          Icons.person_add,
          size: Sizes.size12,
          color: Colors.purple[600],
        );
      case "Liked":
        return Icon(
          Icons.favorite,
          size: Sizes.size12,
          color: Colors.red[600],
        );
      default:
        return Icon(
          Icons.notifications,
          size: Sizes.size12,
          color: Colors.grey[600],
        );
    }
  }
}



