import 'package:flutter/material.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/profile_view_model.dart';

class ProfileTabHeaderWidget extends SliverPersistentHeaderDelegate {
  final ProfileTab currentTab;
  final Function(ProfileTab) onTabChanged;

  ProfileTabHeaderWidget({
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Tab buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(ProfileTab.threads),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: currentTab == ProfileTab.threads
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      'Threads',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: currentTab == ProfileTab.threads
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentTab == ProfileTab.threads
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(ProfileTab.replies),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: currentTab == ProfileTab.replies
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      'Replies',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: currentTab == ProfileTab.replies
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentTab == ProfileTab.replies
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Divider line
          Container(
            height: 0.5,
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}


