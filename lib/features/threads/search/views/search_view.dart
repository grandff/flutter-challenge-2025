import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/search_view_model.dart';
import '../widgets/user_profile_widget.dart';

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
    // Load trending users when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchViewModelProvider.notifier).loadTrendingUsers();
    });
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                            hintText: 'Search',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.black,
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
                            color: Colors.grey[600],
                            size: 24,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Search results or trending users
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
                                color: Colors.grey[400],
                                size: 64,
                              ),
                              const SizedBox(height: Sizes.size16),
                              Text(
                                'Error loading results',
                                style: TextStyle(
                                  color: Colors.grey[600],
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
                      : searchState.users.isEmpty
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
                                    'Search for posts, people, or topics',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: searchState.users.length,
                              itemBuilder: (context, index) {
                                final user = searchState.users[index];
                                return Column(
                                  children: [
                                    UserProfileWidget(user: user),
                                    if (index < searchState.users.length - 1)
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
