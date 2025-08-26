import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/profile_view_model.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_tab_header_widget.dart';
import '../widgets/post_item_widget.dart';

class ProfileView extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onNavigateToPrivacy;

  const ProfileView(
      {super.key, this.onNavigateToSettings, this.onNavigateToPrivacy});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    // Load profile and threads when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileViewModelProvider.notifier).loadProfile();
      ref.read(profileViewModelProvider.notifier).loadThreads();
    });
  }

  void _onTabChanged(ProfileTab tab) {
    ref.read(profileViewModelProvider.notifier).switchTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final profileViewModel = ref.read(profileViewModelProvider.notifier);

    if (profileState.profile == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar for profile header
          SliverAppBar(
            expandedHeight: 320, // Increased to prevent bottom overflow
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: ProfileHeaderWidget(
                profile: profileState.profile!,
                onNavigateToSettings: widget.onNavigateToSettings,
                onNavigateToPrivacy: widget.onNavigateToPrivacy,
              ),
            ),
          ),
          // SliverPersistentHeader for tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: ProfileTabHeaderWidget(
              currentTab: profileState.currentTab,
              onTabChanged: _onTabChanged,
            ),
          ),
          // Content based on selected tab
          if (profileState.currentTab == ProfileTab.threads)
            _buildThreadsList(profileState, profileViewModel)
          else
            _buildRepliesList(profileState, profileViewModel),
        ],
      ),
    );
  }

  Widget _buildThreadsList(ProfileState state, dynamic viewModel) {
    if (state.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading threads',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.threads.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.post_add,
                color: Colors.grey[400],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No threads yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'When you post threads, they\'ll show up here',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = state.threads[index];
          return Column(
            children: [
              PostItemWidget(post: post),
              if (index < state.threads.length - 1)
                Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 60,
                ),
            ],
          );
        },
        childCount: state.threads.length,
      ),
    );
  }

  Widget _buildRepliesList(ProfileState state, dynamic viewModel) {
    if (state.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading replies',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state.replies.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.reply,
                color: Colors.grey[400],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No replies yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'When you reply to posts, they\'ll show up here',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = state.replies[index];
          return Column(
            children: [
              PostItemWidget(post: post),
              if (index < state.replies.length - 1)
                Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 60,
                ),
            ],
          );
        },
        childCount: state.replies.length,
      ),
    );
  }
}
