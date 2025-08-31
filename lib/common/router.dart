import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../constants/sizes.dart';
import '../features/threads/activity/views/activity_view.dart';
import '../features/threads/home/views/new_post_view.dart';
import '../features/threads/home/widgets/home_content_widget.dart';
import '../features/threads/home/widgets/create_post_bottom_sheet.dart';
import '../features/threads/home/widgets/nav_item_widget.dart';
import '../features/threads/home/view_model/home_view_model.dart';
import '../features/threads/profile/views/profile_view.dart';
import '../features/threads/search/views/search_view.dart';
import '../features/threads/settings/views/privacy_view.dart';
import '../features/threads/settings/views/settings_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ThreadsShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const HomeContentWidget(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              name: 'search',
              builder: (context, state) => const SearchView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/new_post_dummy',
              name: 'new_post_dummy',
              builder: (context, state) => const NewPostView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/activity',
              name: 'activity',
              builder: (context, state) => const ActivityView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ThreadsProfileView(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const ThreadsSettingsView(),
    ),
    GoRoute(
      path: '/settings/privacy',
      name: 'privacy',
      builder: (context, state) => const ThreadsPrivacyView(),
    ),
    GoRoute(
      path: '/new_post',
      name: 'new_post',
      builder: (context, state) => const NewPostView(),
    ),
  ],
);

// Shell scaffold with fixed bottom navigation
class ThreadsShellScaffold extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ThreadsShellScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<ThreadsShellScaffold> createState() =>
      _ThreadsShellScaffoldState();
}

class _ThreadsShellScaffoldState extends ConsumerState<ThreadsShellScaffold> {
  @override
  void initState() {
    super.initState();
    // Load posts when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).loadPosts();
    });
  }

  void _onTap(int index) {
    if (index == 2) {
      // 쓰기 화면은 바텀시트로 처리
      _showCreatePostSheet();
    } else {
      widget.navigationShell.goBranch(index);
    }
  }

  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CreatePostBottomSheet(
        onPostCreated: () {
          // Refresh posts after creation
          ref.read(homeViewModelProvider.notifier).loadPosts();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App header (only show for home tab)
            if (widget.navigationShell.currentIndex == 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedThreads,
                        color:
                            Theme.of(context).iconTheme.color ?? Colors.black,
                        size: Sizes.size48,
                      ),
                    ),
                    // Search icon
                    Icon(
                      Icons.search,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.7),
                      size: 24,
                    ),
                  ],
                ),
              ),
            // Current view content
            Expanded(
              child: widget.navigationShell,
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItemWidget(
                  icon: Icons.home,
                  isSelected: widget.navigationShell.currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
                NavItemWidget(
                  icon: Icons.search,
                  isSelected: widget.navigationShell.currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
                NavItemWidget(
                  icon: Icons.add_box_outlined,
                  isSelected: widget.navigationShell.currentIndex == 2,
                  onTap: () => _onTap(2),
                ),
                NavItemWidget(
                  icon: Icons.favorite_outline,
                  isSelected: widget.navigationShell.currentIndex == 3,
                  onTap: () => _onTap(3),
                ),
                NavItemWidget(
                  icon: Icons.person_outline,
                  isSelected: widget.navigationShell.currentIndex == 4,
                  onTap: () => _onTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Individual Views wrapped for go_router
class ThreadsProfileView extends StatelessWidget {
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onNavigateToPrivacy;

  const ThreadsProfileView({
    super.key,
    this.onNavigateToSettings,
    this.onNavigateToPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileView(
      onNavigateToSettings:
          onNavigateToSettings ?? () => context.push('/settings'),
      onNavigateToPrivacy:
          onNavigateToPrivacy ?? () => context.push('/settings/privacy'),
    );
  }
}

class ThreadsSettingsView extends StatelessWidget {
  final VoidCallback? onBackToProfile;
  final VoidCallback? onNavigateToPrivacy;

  const ThreadsSettingsView({
    super.key,
    this.onBackToProfile,
    this.onNavigateToPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsView(
      onBackToProfile: onBackToProfile ?? () => context.go('/profile'),
      onNavigateToPrivacy:
          onNavigateToPrivacy ?? () => context.push('/settings/privacy'),
    );
  }
}

class ThreadsPrivacyView extends StatelessWidget {
  final VoidCallback? onBackToProfile;

  const ThreadsPrivacyView({
    super.key,
    this.onBackToProfile,
  });

  @override
  Widget build(BuildContext context) {
    return PrivacyView(
      onBackToProfile: onBackToProfile ?? () => context.go('/profile'),
    );
  }
}
