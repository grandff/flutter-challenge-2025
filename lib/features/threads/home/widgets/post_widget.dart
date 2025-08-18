import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../models/post_model.dart';
import '../view_model/home_view_model.dart';

class PostWidget extends ConsumerWidget {
  final PostModel post;
  final String currentUserId;

  const PostWidget({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final isLiked = homeViewModel.isPostLiked(post.id, currentUserId);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16, vertical: Sizes.size12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Avatar + follow badge + vertical line + engagement avatars
            SizedBox(
              width: Sizes.size40,
              child: Column(
                children: [
                  // Main avatar with follow badge
                  SizedBox(
                    width: Sizes.size40,
                    height: Sizes.size40,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Avatar
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: post.userProfileImage.isNotEmpty
                              ? ClipOval(
                                  child: Image.asset(
                                    post.userProfileImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[400],
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey[600],
                                          size: Sizes.size20,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: Colors.grey[600],
                                  size: Sizes.size20,
                                ),
                        ),
                        // Follow (+) badge at bottom-right
                        Positioned(
                          right: -Sizes.size2,
                          bottom: -Sizes.size2,
                          child: Container(
                            width: Sizes.size20,
                            height: Sizes.size20,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: Sizes.size2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: Sizes.size12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Vertical line (only when there is engagement)
                  if (post.replyCount > 0 || post.likeCount > 0) ...[
                    Gaps.v8,
                    Expanded(
                      child: Container(
                        width: Sizes.size2,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Gaps.h12,
            // Right side: Content (username, text, images, icons, stats)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info header
                  Row(
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size16,
                        ),
                      ),
                      if (post.isVerified) ...[
                        Gaps.h4,
                        Container(
                          width: Sizes.size16,
                          height: Sizes.size16,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: Sizes.size12,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        post.timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: Sizes.size14,
                        ),
                      ),
                      Gaps.h8,
                      Icon(
                        Icons.more_horiz,
                        color: Colors.grey[600],
                        size: Sizes.size20,
                      ),
                    ],
                  ),
                  Gaps.v8,
                  // Post content
                  if (post.content.isNotEmpty)
                    Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        height: 1.4,
                      ),
                    ),
                  Gaps.v12,
                  // Images (if any)
                  if (post.hasImages) ...[
                    _buildImageCarousel(),
                    Gaps.v12,
                  ],
                  // Interaction buttons
                  Row(
                    children: [
                      _buildInteractionButton(
                        icon: isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey[600],
                        onTap: () {
                          if (isLiked) {
                            homeViewModel.unlikePost(post.id, currentUserId);
                          } else {
                            homeViewModel.likePost(post.id, currentUserId);
                          }
                        },
                      ),
                      Gaps.h24,
                      _buildInteractionButton(
                        icon: Icons.chat_bubble_outline,
                        color: Colors.grey[600],
                        onTap: () {
                          // TODO: Navigate to comments
                        },
                      ),
                      Gaps.h24,
                      _buildInteractionButton(
                        icon: Icons.repeat,
                        color: Colors.grey[600],
                        onTap: () {
                          // TODO: Repost functionality
                        },
                      ),
                      Gaps.h24,
                      _buildInteractionButton(
                        icon: Icons.send,
                        color: Colors.grey[600],
                        onTap: () {
                          // TODO: Share functionality
                        },
                      ),
                    ],
                  ),
                  // Engagement stats with avatars (overlay avatars aligned to left column)
                  if (post.replyCount > 0 || post.likeCount > 0) ...[
                    Gaps.v8,
                    SizedBox(
                      height: Sizes.size20,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (post.likedBy.isNotEmpty)
                            Transform.translate(
                              offset: const Offset(
                                  -(Sizes.size40 + Sizes.size12), 0),
                              child: Row(
                                children: [
                                  ...post.likedBy.take(2).map(
                                        (userId) => Container(
                                          margin: const EdgeInsets.only(
                                              right: Sizes.size4),
                                          width: Sizes.size20,
                                          height: Sizes.size20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            color: Colors.grey[400],
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/face${(userId.hashCode % 16) + 1}.jpeg",
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  color: Colors.grey[600],
                                                  size: Sizes.size12,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${post.replyCount} replies · ${post.likeCount} likes",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: Sizes.size14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
        size: Sizes.size24,
      ),
    );
  }

  Widget _buildImageCarousel() {
    if (post.images.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size12),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(
              viewportFraction: 0.85,
              initialPage: 0,
            ),
            itemCount: post.images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: Sizes.size4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                  child: Image.asset(
                    post.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[600],
                          size: Sizes.size50,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Page indicator dots
          if (post.images.length > 1)
            Positioned(
              bottom: Sizes.size12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  post.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: Sizes.size4),
                    width: Sizes.size8,
                    height: Sizes.size8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
