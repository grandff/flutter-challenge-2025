import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/activity_view_model.dart';
import '../widgets/activity_item_widget.dart';

class ActivityView extends ConsumerStatefulWidget {
  const ActivityView({super.key});

  @override
  ConsumerState<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends ConsumerState<ActivityView> {
  final List<String> _filters = ['All', 'Replies', 'Mentions', 'Verified'];

  @override
  void initState() {
    super.initState();
    // Load activities when view is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityViewModelProvider.notifier).loadActivities();
    });
  }

  void _onFilterChanged(String filter) {
    ref.read(activityViewModelProvider.notifier).filterActivities(filter);
  }

  @override
  Widget build(BuildContext context) {
    final activityState = ref.watch(activityViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with title
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
                vertical: Sizes.size12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: const Row(
                children: [
                  Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Filter tabs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size16),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = activityState.currentFilter == filter;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onFilterChanged(filter),
                      child: Container(
                        margin: const EdgeInsets.only(right: Sizes.size8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.size12,
                          vertical: Sizes.size8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          filter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: Sizes.size8),
            // Activities list
            Expanded(
              child: activityState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : activityState.error != null
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
                                'Error loading activities',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: Sizes.size8),
                              Text(
                                activityState.error!,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : activityState.activities.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_none,
                                    color: Colors.grey[400],
                                    size: 64,
                                  ),
                                  const SizedBox(height: Sizes.size16),
                                  Text(
                                    'No activities yet',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: Sizes.size8),
                                  Text(
                                    'When you have new activities, they\'ll show up here',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: activityState.activities.length,
                              itemBuilder: (context, index) {
                                final activity =
                                    activityState.activities[index];
                                return Column(
                                  children: [
                                    ActivityItemWidget(activity: activity),
                                    if (index <
                                        activityState.activities.length - 1)
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





