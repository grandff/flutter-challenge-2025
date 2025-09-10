import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/search_view_model.dart';
import '../widgets/user_profile_widget.dart';
import '../../home/widgets/post_widget.dart';
import '../../home/utils/user_utils.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 최초 화면에서는 검색어 입력 안내만 표시
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(searchViewModelProvider.notifier).loadTrendingUsers();
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final searchViewModel = ref.read(searchViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size16, vertical: Sizes.size12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                    ),
                  ),
                  const SizedBox(height: Sizes.size12),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search posts...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withOpacity(0.6),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size16,
                              vertical: Sizes.size12,
                            ),
                          ),
                          onChanged: (query) {
                            if (query.isEmpty) {
                              searchViewModel.clearSearch();
                            } else {
                              searchViewModel.search(query);
                            }
                          },
                        ),
                      ),
                      if (_searchController.text.isNotEmpty) ...[
                        const SizedBox(width: Sizes.size8),
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            searchViewModel.clearSearch();
                          },
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.6),
                            size: 24,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Search results
            Expanded(
              child: searchState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : searchState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color
                                    ?.withOpacity(0.4),
                                size: 64,
                              ),
                              const SizedBox(height: Sizes.size16),
                              Text(
                                'Error loading results',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.6),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: Sizes.size8),
                              Text(
                                searchState.error!,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : searchState.query.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.grey[400],
                                    size: 64,
                                  ),
                                  const SizedBox(height: Sizes.size16),
                                  Text(
                                    '검색어를 입력해주세요',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: Sizes.size8),
                                  Text(
                                    '게시글 내용을 검색할 수 있습니다',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : searchState.posts.isEmpty &&
                                  searchState.users.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        color: Colors.grey[400],
                                        size: 64,
                                      ),
                                      const SizedBox(height: Sizes.size16),
                                      Text(
                                        '검색 결과가 없습니다',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: Sizes.size8),
                                      Text(
                                        '"${searchState.query}"에 대한 결과를 찾을 수 없습니다',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : searchState.posts.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: searchState.posts.length,
                                      itemBuilder: (context, index) {
                                        final post = searchState.posts[index];
                                        final currentUserId =
                                            UserUtils.getCurrentUser()?.id ??
                                                '';
                                        return PostWidget(
                                          post: post,
                                          currentUserId: currentUserId,
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      itemCount: searchState.users.length,
                                      itemBuilder: (context, index) {
                                        final user = searchState.users[index];
                                        return Column(
                                          children: [
                                            UserProfileWidget(user: user),
                                            if (index <
                                                searchState.users.length - 1)
                                              Divider(
                                                height: 1,
                                                color: Colors.grey[200],
                                                indent: Sizes.size60,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
            ),
          ],
        ),
      ),
    );
  }
}
