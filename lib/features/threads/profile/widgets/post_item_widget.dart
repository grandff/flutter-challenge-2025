import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../models/post_model.dart';
import '../view_model/profile_view_model.dart';

class PostItemWidget extends ConsumerWidget {
  final PostModel post;

  const PostItemWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.size16,
        vertical: Sizes.size12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Row(
            children: [
              CircleAvatar(
                radius: Sizes.size20,
                backgroundImage: AssetImage(post.profileImage),
              ),
              const SizedBox(width: Sizes.size12),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    if (post.isVerified) ...[
                      const SizedBox(width: Sizes.size4),
                      Icon(
                        Icons.verified,
                        size: Sizes.size16,
                        color: Colors.blue[600],
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                post.timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: Sizes.size8),
              Icon(
                Icons.more_horiz,
                color: Colors.grey[600],
                size: Sizes.size20,
              ),
            ],
          ),
          const SizedBox(height: Sizes.size12),
          // Post content
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          // Quoted post (if exists)
          if (post.quotedPost != null) ...[
            const SizedBox(height: Sizes.size12),
            Container(
              margin: const EdgeInsets.only(left: Sizes.size20),
              padding: const EdgeInsets.all(Sizes.size12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: Sizes.size16,
                        backgroundImage:
                            AssetImage(post.quotedPost!.profileImage),
                      ),
                      const SizedBox(width: Sizes.size8),
                      Text(
                        post.quotedPost!.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      if (post.quotedPost!.isVerified) ...[
                        const SizedBox(width: Sizes.size4),
                        Icon(
                          Icons.verified,
                          size: Sizes.size12,
                          color: Colors.blue[600],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: Sizes.size8),
                  Text(
                    post.quotedPost!.content,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (post.quotedPost!.repliesCount > 0) ...[
                    const SizedBox(height: Sizes.size4),
                    Text(
                      "${post.quotedPost!.repliesCount} replies",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: Sizes.size12),
          // Interaction buttons
          Row(
            children: [
              // Like button
              GestureDetector(
                onTap: () {
                  ref
                      .read(profileViewModelProvider.notifier)
                      .toggleLike(post.id);
                },
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.grey[600],
                      size: Sizes.size20,
                    ),
                    if (post.likesCount > 0) ...[
                      const SizedBox(width: Sizes.size4),
                      Text(
                        post.likesCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Sizes.size24),
              // Reply button
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey[600],
                    size: Sizes.size20,
                  ),
                  if (post.repliesCount > 0) ...[
                    const SizedBox(width: Sizes.size4),
                    Text(
                      post.repliesCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: Sizes.size24),
              // Repost button
              GestureDetector(
                onTap: () {
                  ref
                      .read(profileViewModelProvider.notifier)
                      .toggleRepost(post.id);
                },
                child: Row(
                  children: [
                    Icon(
                      post.isReposted ? Icons.repeat : Icons.repeat_outlined,
                      color: post.isReposted ? Colors.green : Colors.grey[600],
                      size: Sizes.size20,
                    ),
                    if (post.repostsCount > 0) ...[
                      const SizedBox(width: Sizes.size4),
                      Text(
                        post.repostsCount.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Sizes.size24),
              // Share button
              Icon(
                Icons.send_outlined,
                color: Colors.grey[600],
                size: Sizes.size20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


