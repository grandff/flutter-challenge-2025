import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../view_model/mood_view_model.dart';
import '../widgets/mood_card_widget.dart';
import '../widgets/delete_mood_dialog.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/post_bottom_sheet.dart';
import '../models/mood_model.dart';
import '../../auth/view_model/auth_view_model.dart';

class MoodHomeView extends ConsumerStatefulWidget {
  const MoodHomeView({super.key});

  @override
  ConsumerState<MoodHomeView> createState() => _MoodHomeViewState();
}

class _MoodHomeViewState extends ConsumerState<MoodHomeView> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    // 무드 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moodViewModelProvider.notifier).loadMoods();
    });
  }

  void _showPostBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SheetViewport(
        child: PostBottomSheet(
          onMoodCreated: () {
            // 무드 생성 후 홈화면 새로고침
            ref.read(moodViewModelProvider.notifier).loadMoods();
          },
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    LogoutDialog.show(
      context: context,
      onLogout: () async {
        try {
          await ref.read(authViewModelProvider.notifier).signOut();
          if (mounted) {
            context.go('/mood/login');
          }
        } catch (e) {
          if (mounted) {
            CherryToast.error(
              title: const Text('로그아웃 실패'),
              description: Text(e.toString()),
            ).show(context);
          }
        }
      },
    );
  }

  void _showDeleteDialog(MoodModel mood) {
    DeleteMoodDialog.show(
      context: context,
      moodDescription: mood.description,
      onDelete: () async {
        try {
          await ref
              .read(moodViewModelProvider.notifier)
              .deleteMood(moodId: mood.id);
          if (mounted) {
            CherryToast.success(
              title: const Text('무드가 삭제되었습니다'),
            ).show(context);
          }
        } catch (e) {
          if (mounted) {
            CherryToast.error(
              title: const Text('삭제 실패'),
              description: Text(e.toString()),
            ).show(context);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      navBarStyle: NavBarStyle.style15,
    );
  }

  List<Widget> _buildScreens() {
    return [
      _buildHomeScreen(),
      _buildPostScreen(),
      _buildLogoutScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const HugeIcon(
          icon: HugeIcons.strokeRoundedHome01,
          color: Colors.black,
        ),
        title: "홈",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.black87,
      ),
      PersistentBottomNavBarItem(
        icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedPen01, color: Colors.white),
        title: "글쓰기",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey[600]!,
        onPressed: (context) {
          _showPostBottomSheet();
        },
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.logout),
        title: "로그아웃",
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.red,
        onPressed: (context) {
          _showLogoutDialog();
        },
      ),
    ];
  }

  Widget _buildHomeScreen() {
    final moodsAsync = ref.watch(moodViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7E9),
      body: SafeArea(
        child: Column(
          children: [
            // 앱 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: const Text(
                '🔥 MOOD 🔥',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // 무드 목록
            Expanded(
              child: moodsAsync.when(
                data: (moods) {
                  if (moods.isEmpty) {
                    return const Center(
                      child: Text(
                        '아직 기록된 무드가 없습니다.\n첫 번째 무드를 기록해보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 50),
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      final mood = moods[index];
                      return MoodCardWidget(
                        mood: mood,
                        onLongPress: () => _showDeleteDialog(mood),
                      )
                          .animate()
                          .fadeIn(
                            duration: 600.ms,
                            delay: (index * 100).ms, // 각 카드마다 100ms씩 지연
                          )
                          .slideX(
                            begin: 0.3, // 오른쪽에서 시작 (양수)
                            end: 0, // 원래 위치로
                            duration: 600.ms,
                            delay: (index * 100).ms,
                            curve: Curves.easeOut,
                          );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '무드를 불러오는데 실패했습니다',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(moodViewModelProvider.notifier).loadMoods();
                        },
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F7E9),
      body: Center(
        child: Text(
          '글쓰기 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildLogoutScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F7E9),
      body: Center(
        child: Text(
          '로그아웃 화면',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
