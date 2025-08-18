import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../view_model/uiclone_view_model.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/date_selector_widget.dart';

class UiCloneView extends ConsumerWidget {
  const UiCloneView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(uiCloneViewModelProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Profile and Plus Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: Sizes.size32,
                    backgroundColor: Colors.brown.shade300,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: Sizes.size32,
                    ),
                  ),
                ],
              ),

              Gaps.v40,

              // Date Info
              Text(
                'MONDAY 16',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),

              Gaps.h8,

              // Date Selector
              DateSelectorWidget(
                dates: state.dates,
                selectedIndex: state.selectedDateIndex,
                onDateSelected: (index) {
                  ref.read(uiCloneViewModelProvider.notifier).selectDate(index);
                },
              ),

              Gaps.v24,

              // Event Cards
              Expanded(
                child: ListView.separated(
                  itemCount: state.events.length,
                  separatorBuilder: (context, index) => Gaps.v20,
                  itemBuilder: (context, index) {
                    final event = state.events[index];
                    return EventCardWidget(event: event);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
