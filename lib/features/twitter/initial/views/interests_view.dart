import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../widgets/twitter_app_header.dart';
import 'interests_part2_view.dart';

class InterestsView extends StatefulWidget {
  const InterestsView({super.key});

  @override
  State<InterestsView> createState() => _InterestsViewState();
}

class _InterestsViewState extends State<InterestsView> {
  static const List<String> _interests = [
    'Fashion & beauty',
    'Outdoors',
    'Arts & culture',
    'Animation & comics',
    'Business & finance',
    'Food',
    'Travel',
    'Entertainment',
    'Music',
    'Gaming',
    'Technology',
    'Sports',
    'News',
    'Science',
  ];

  final Set<String> _selected = <String>{};

  void _toggle(String interest) {
    setState(() {
      if (_selected.contains(interest)) {
        _selected.remove(interest);
      } else {
        _selected.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canNext = _selected.length >= 3;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TwitterAppHeader(
              showBack: true,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v20,
                    Text(
                      'What do you want to see on Twitter?',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Gaps.v16,
                    Text(
                      'Select at least 3 interests to personalize your Twitter experience. They will be visible on your profile.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    Gaps.v24,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _interests.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3.2,
                      ),
                      itemBuilder: (context, index) {
                        final interest = _interests[index];
                        final selected = _selected.contains(interest);
                        return GestureDetector(
                          onTap: () => _toggle(interest),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size16,
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF1DA1F2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected ? const Color(0xFF1DA1F2) : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    interest,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: selected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  const Icon(Icons.check_circle, color: Colors.white),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Gaps.v12,
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16,
                vertical: Sizes.size12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      canNext
                          ? 'Great work 🎉'
                          : '${_selected.length} of 3 selected',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Sizes.size56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            canNext ? Colors.black : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: canNext
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const InterestsPart2View(),
                                ),
                              );
                            }
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.size24),
                        child: Text(
                          'Next',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




