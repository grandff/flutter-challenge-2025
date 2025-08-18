import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../search/views/search_view.dart';
import '../view_model/home_view_model.dart';
import '../widgets/home_content_widget.dart';
import '../widgets/nav_item_widget.dart';
import 'new_post_view.dart';
import 'notifications_view.dart';
import 'profile_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load posts when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).loadPosts();
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentView() {
    switch (_currentIndex) {
      case 0:
        return const HomeContentWidget();
      case 1:
        return const SearchView();
      case 2:
        return const NewPostView();
      case 3:
        return const NotificationsView();
      case 4:
        return const ProfileView();
      default:
        return const HomeContentWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App header (only show for home tab)
            if (_currentIndex == 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16, vertical: Sizes.size12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedThreads,
                        color: Colors.black,
                        size: Sizes.size48,
                      ),
                    ),

                    // Search icon
                    Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: Sizes.size24,
                    ),
                  ],
                ),
              ),
            // Current view content
            Expanded(
              child: _getCurrentView(),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16, vertical: Sizes.size8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItemWidget(
                  icon: Icons.home,
                  isSelected: _currentIndex == 0,
                  onTap: () => _onTabTapped(0),
                ),
                NavItemWidget(
                  icon: Icons.search,
                  isSelected: _currentIndex == 1,
                  onTap: () => _onTabTapped(1),
                ),
                NavItemWidget(
                  icon: Icons.add_box_outlined,
                  isSelected: _currentIndex == 2,
                  onTap: () => _onTabTapped(2),
                ),
                NavItemWidget(
                  icon: Icons.favorite_outline,
                  isSelected: _currentIndex == 3,
                  onTap: () => _onTabTapped(3),
                ),
                NavItemWidget(
                  icon: Icons.person_outline,
                  isSelected: _currentIndex == 4,
                  onTap: () => _onTabTapped(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
