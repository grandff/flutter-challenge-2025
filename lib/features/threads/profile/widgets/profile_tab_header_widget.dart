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
      color: Theme.of(context).scaffoldBackgroundColor,
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
                              ? Theme.of(context).primaryColor
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
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.6),
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
                              ? Theme.of(context).primaryColor
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
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.6),
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
            color: Theme.of(context).dividerColor,
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
