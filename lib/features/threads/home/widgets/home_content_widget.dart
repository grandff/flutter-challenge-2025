import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/home_view_model.dart';
import 'post_widget.dart';

class HomeContentWidget extends ConsumerWidget {
  const HomeContentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return homeState.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : homeState.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[400],
                      size: Sizes.size48,
                    ),
                    Gaps.v16,
                    Text(
                      'Error loading posts',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.v8,
                    Text(
                      homeState.error!,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Sizes.size14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.v16,
                    ElevatedButton(
                      onPressed: () {
                        homeViewModel.loadPosts();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await homeViewModel.refreshPosts();
                },
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: homeState.posts.length,
                  itemBuilder: (context, index) {
                    final post = homeState.posts[index];
                    return PostWidget(
                      post: post,
                      currentUserId: "currentUser", // TODO: Get from auth
                    );
                  },
                ),
              );
  }
}
