import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

class DateSelectorWidget extends StatelessWidget {
  final List<String> dates;
  final int selectedIndex;
  final Function(int) onDateSelected;

  const DateSelectorWidget({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // TODAY text with special styling
          GestureDetector(
            onTap: () => onDateSelected(0),
            child: Container(
              padding: const EdgeInsets.only(right: Sizes.size8),
              child: Row(
                children: [
                  Text(
                    'TODAY',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color:
                              selectedIndex == 0 ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // Pink dot after TODAY
                  Container(
                    margin: const EdgeInsets.only(
                        left: Sizes.size8, top: Sizes.size8),
                    width: Sizes.size12,
                    height: Sizes.size12,
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Gaps.h16,

          // Other dates
          ...dates.skip(1).toList().asMap().entries.map((entry) {
            final index = entry.key + 1; // +1 because we skipped TODAY
            final date = entry.value;

            return GestureDetector(
              onTap: () => onDateSelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: Sizes.size16),
                child: Text(
                  date,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color:
                            selectedIndex == index ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
