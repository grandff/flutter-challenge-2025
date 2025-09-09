import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // 임시로 비활성화
import '../models/post_model.dart';
// import '../view_model/home_view_model.dart'; // TODO: 좋아요 기능 구현 시 다시 활성화
import 'post_options_bottom_sheet.dart';
import 'report_bottom_sheet.dart';

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
    // TODO: 좋아요 기능은 추후 구현 예정
    // final homeViewModel = ref.read(homeViewModelProvider.notifier);
    // final isLiked = homeViewModel.isPostLiked(post.id, currentUserId);

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
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        child: Center(
                                          child: Text(
                                            post.username.isNotEmpty
                                                ? post.username[0].toUpperCase()
                                                : 'U',
                                            style: TextStyle(
                                              fontSize: Sizes.size18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    post.username.isNotEmpty
                                        ? post.username[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      fontSize: Sizes.size18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                ),
                        ),
                        // Follow (+) badge at bottom-right (본인 게시글이 아닐 때만 표시)
                        if (post.userId != currentUserId)
                          Positioned(
                            right: -Sizes.size2,
                            bottom: -Sizes.size2,
                            child: Container(
                              width: Sizes.size20,
                              height: Sizes.size20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                        color: Theme.of(context).dividerColor,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
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
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6),
                          fontSize: Sizes.size14,
                        ),
                      ),
                      Gaps.h8,
                      GestureDetector(
                        onTap: () => _showPostOptions(context),
                        child: Icon(
                          Icons.more_horiz,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withOpacity(0.6),
                          size: Sizes.size20,
                        ),
                      ),
                    ],
                  ),
                  Gaps.v8,
                  // Post content
                  if (post.content.isNotEmpty)
                    Text(
                      post.content,
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        height: 1.4,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  Gaps.v12,
                  // Images (if any)
                  if (post.hasImages) ...[
                    _buildImageCarousel(context),
                    Gaps.v12,
                  ],
                  // Interaction buttons
                  Row(
                    children: [
                      _buildInteractionButton(
                        icon: Icons.favorite_border, // 임시로 빈 하트로 설정
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
                        onTap: () {
                          // TODO: 좋아요 기능은 추후 구현 예정
                        },
                      ),
                      Gaps.h24,
                      _buildInteractionButton(
                        icon: Icons.chat_bubble_outline,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
                        onTap: () {
                          // TODO: Navigate to comments
                        },
                      ),
                      Gaps.h24,
                      _buildInteractionButton(
                        icon: Icons.repeat,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
                        onTap: () {
                          // TODO: Repost functionality
                        },
                      ),
                      Gaps.h24,
                      _buildInteractionButton(
                        icon: Icons.send,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
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
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              width: 1,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/face${(userId.hashCode % 16) + 1}.jpeg",
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                      ?.withOpacity(0.6),
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.6),
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

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PostOptionsBottomSheet(
        postId: post.id,
        username: post.username,
        onUnfollow: () {
          Navigator.of(context).pop();
          // TODO: Implement unfollow logic
          print('Unfollow ${post.username}');
        },
        onMute: () {
          Navigator.of(context).pop();
          // TODO: Implement mute logic
          print('Mute ${post.username}');
        },
        onHide: () {
          Navigator.of(context).pop();
          // TODO: Implement hide logic
          print('Hide post ${post.id}');
        },
        onReport: () {
          Navigator.of(context).pop();
          _showReportSheet(context);
        },
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReportBottomSheet(
        postId: post.id,
        onBack: () => Navigator.of(context).pop(),
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

  Widget _buildImageCarousel(BuildContext context) {
    if (post.images.isEmpty && post.imageUrl == null)
      return const SizedBox.shrink();

    // 이미지 URL 리스트 생성 (imageUrl이 있으면 우선 사용, 없으면 images 리스트 사용)
    final imageUrls = <String>[];
    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      imageUrls.add(post.imageUrl!);
    } else {
      imageUrls.addAll(post.images);
    }

    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(
              viewportFraction: 0.85,
              initialPage: 0,
            ),
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: Sizes.size4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.image,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withOpacity(0.6),
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
          if (imageUrls.length > 1)
            Positioned(
              bottom: Sizes.size12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
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
