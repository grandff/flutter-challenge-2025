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
import '../features/auth/views/login_view.dart' as threads_auth;
import '../features/auth/views/signup_view.dart' as threads_auth;
import '../features/mood/auth/views/login_view.dart' as mood_auth;
import '../features/mood/auth/views/signup_view.dart' as mood_auth;
import '../features/mood/mood/views/mood_home_view.dart';
import '../features/mood/auth/repos/auth_repo.dart';
import '../features/pomodoroV2/views/pomodoro_v2_view.dart';
import '../features/flashcard/views/flashcard_view.dart';
import '../features/movieflix/views/movie_intro_view.dart';
import 'auth_guard.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/movieflix',
  redirect: (context, state) {
    // 현재 경로가 mood 관련인지 확인
    final currentPath = state.uri.path;
    final isMoodRoute = currentPath.startsWith('/mood');

    if (isMoodRoute) {
      // mood 앱의 인증 상태 확인
      final currentUser = AuthRepo.getCurrentUser();

      // 로그인된 사용자이고 로그인/회원가입 페이지에 있다면 홈으로 리다이렉트
      if (currentUser != null && currentUser.isAuthenticated) {
        if (currentPath == '/mood/login' || currentPath == '/mood/signup') {
          return '/mood/home';
        }
      }
      // 로그인되지 않은 사용자이고 홈 페이지에 있다면 로그인으로 리다이렉트
      else if (currentUser == null || !currentUser.isAuthenticated) {
        if (currentPath == '/mood/home' || currentPath == '/mood/posts') {
          return '/mood/login';
        }
      }
    }

    return null; // 리다이렉트하지 않음
  },
  routes: [
    // 플래시 카드 화면
    GoRoute(
      path: '/flashcard',
      name: 'flashcard',
      builder: (context, state) => const FlashcardView(),
    ),
    // 영화 소개 화면
    GoRoute(
      path: '/movieflix',
      name: 'movieflix',
      builder: (context, state) => const MovieIntroView(),
    ),
    // 애니메이션 데모 화면
    GoRoute(
      path: '/animation',
      name: 'animation',
      builder: (context, state) => const PomodoroV2View(),
    ),
    // 무드트래커 로그인 화면
    GoRoute(
      path: '/mood/login',
      name: 'mood_login',
      builder: (context, state) => const mood_auth.LoginView(),
    ),
    // 무드트래커 회원가입 화면
    GoRoute(
      path: '/mood/signup',
      name: 'mood_signup',
      builder: (context, state) => const mood_auth.SignUpView(),
    ),
    // 무드트래커 홈 화면
    GoRoute(
      path: '/mood/home',
      name: 'mood_home',
      builder: (context, state) => const MoodHomeView(),
    ),
    // 무드트래커 게시물 화면 (임시)
    GoRoute(
      path: '/mood/posts',
      name: 'mood_posts',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('게시물 화면 (구현 예정)'),
        ),
      ),
    ),
    // 기존 Threads 로그인 화면
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const threads_auth.LoginView(),
    ),
    // 기존 Threads 회원가입 화면
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const threads_auth.SignupView(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AuthGuard(
          child: ThreadsShellScaffold(navigationShell: navigationShell),
        );
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
