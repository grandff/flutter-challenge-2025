import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/profile_model.dart';
import '../../settings/views/settings_view.dart';
import '../../home/views/home_view.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onNavigateToPrivacy;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    this.onNavigateToSettings,
    this.onNavigateToPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.size16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top navigation icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Globe icon
              Icon(
                Icons.public,
                color: Colors.grey[600],
                size: Sizes.size24,
              ),
              // Right side icons
              Row(
                children: [
                  // Camera icon
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedInstagram,
                    color: Colors.grey[600]!,
                    size: Sizes.size24,
                  ),
                  const SizedBox(width: Sizes.size16),
                  // Settings icon
                  GestureDetector(
                    onTap: () {
                      if (onNavigateToSettings != null) {
                        onNavigateToSettings!();
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsView(),
                          ),
                        );
                      }
                    },
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedMenu01,
                      color: Colors.grey[600]!,
                      size: Sizes.size24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: Sizes.size16),
          // Profile info and image row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Profile info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full name
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: Sizes.size4),
                    // Username and threads.net link
                    Row(
                      children: [
                        Text(
                          profile.username,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: Sizes.size8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size8,
                            vertical: Sizes.size4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            profile.threadsNetLink,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.size8),
                    // Bio
                    Text(
                      profile.bio,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: Sizes.size12),
                    // Followers count with avatars
                    Row(
                      children: [
                        // Overlapping follower avatars
                        SizedBox(
                          height: Sizes.size20,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // First follower avatar
                              Container(
                                width: Sizes.size20,
                                height: Sizes.size20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/face1.jpeg",
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
                                          size: Sizes.size12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Second follower avatar (overlapping)
                              Transform.translate(
                                offset: const Offset(12, 0),
                                child: Container(
                                  width: Sizes.size20,
                                  height: Sizes.size20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/face2.jpeg",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[400],
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey[600],
                                            size: Sizes.size12,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gaps.h20,
                        Text(
                          "${profile.followersCount} followers",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Gaps.v16,
                  ],
                ),
              ),
              Gaps.h20,
              // Right side - Profile image
              CircleAvatar(
                radius: Sizes.size40,
                backgroundImage: AssetImage(profile.profileImage),
              ),
            ],
          ),
          // Action buttons in separate row below
          Gaps.v16,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement edit profile
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.size14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size12,
                    ),
                  ),
                  child: const Text(
                    'Edit profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Gaps.h20,
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement share profile
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.size14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size12,
                    ),
                  ),
                  child: const Text(
                    'Share profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
