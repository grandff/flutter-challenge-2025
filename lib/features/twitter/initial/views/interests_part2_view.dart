import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../widgets/twitter_app_header.dart';

class InterestsPart2View extends StatefulWidget {
  const InterestsPart2View({super.key});

  @override
  State<InterestsPart2View> createState() => _InterestsPart2ViewState();
}

class _InterestsPart2ViewState extends State<InterestsPart2View> {
  final Map<String, List<String>> _sections = const {
    'Music': [
      'Rap',
      'R&B & soul',
      'Grammy Awards',
      'Pop',
      'K-pop',
      'Music industry',
      'EDM',
      'Music news',
      'Hip hop',
      'Reggae',
    ],
    'Entertainment': [
      'Anime',
      'Movies & TV',
      'Harry Potter',
      'Marvel Universe',
      'Movie news',
      'Naruto',
      'Movies',
      'Grammy Awards',
      'Entertainment',
    ],
    'Sports': [
      'Soccer',
      'Baseball',
      'Basketball',
      'Tennis',
      'F1',
      'Golf',
      'NFL',
      'eSports',
    ],
  };

  final Set<String> _selected = <String>{};

  String _keyOf(String section, String label) => '$section::$label';

  void _toggle(String section, String label) {
    final key = _keyOf(section, label);
    setState(() {
      if (_selected.contains(key)) {
        _selected.remove(key);
      } else {
        _selected.add(key);
      }
    });
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _chip({
    required String section,
    required String label,
  }) {
    final theme = Theme.of(context);
    final key = _keyOf(section, label);
    final selected = _selected.contains(key);
    return GestureDetector(
      onTap: () => _toggle(section, label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1DA1F2) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFF1DA1F2) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
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
                      'Interests are used to personalize your experience and will be visible on your profile.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                    Gaps.v12,
                    for (final entry in _sections.entries) ...[
                      _sectionHeader(context, entry.key),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final label in entry.value)
                              _chip(section: entry.key, label: label),
                          ],
                        ),
                      ),
                      Gaps.v16,
                    ],
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
                      onPressed: canNext ? () {} : null,
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
