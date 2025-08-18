import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import '../models/event_model.dart';

class EventCardWidget extends StatelessWidget {
  final EventModel event;

  const EventCardWidget({
    super.key,
    required this.event,
  });

  Color _getCardColor() {
    switch (event.color) {
      case 'yellow':
        return const Color(0xFFFFF176); // Light Yellow
      case 'purple':
        return const Color(0xFF9C27B0); // Purple
      case 'green':
        return const Color(0xFF8BC34A); // Light Green
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor() {
    switch (event.color) {
      case 'yellow':
      case 'green':
        return Colors.black;
      case 'purple':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  Color _getParticipantTextColor() {
    switch (event.color) {
      case 'yellow':
      case 'green':
        return Colors.black.withOpacity(0.6);
      case 'purple':
        return Colors.white.withOpacity(0.7);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.size20),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(Sizes.size24),
      ),
      child: Column(
        children: [
          // First Row: Time and Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Time Column (centered)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Start Time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        event.startHour.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _getTextColor(),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        event.startMinute.toString().padLeft(2, '0'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _getTextColor(),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    width: Sizes.size1,
                    height: Sizes.size20,
                    color: _getTextColor(),
                    margin: const EdgeInsets.symmetric(vertical: Sizes.size8),
                  ),
                  // End Time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.endHour.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _getTextColor(),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        event.endMinute.toString().padLeft(2, '0'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _getTextColor(),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              Gaps.h14,

              // Title
              Expanded(
                child: AutoSizeText(
                  event.title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: _getTextColor(),
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                ),
              ),
            ],
          ),

          Gaps.v20,

          // Second Row: Participants
          Row(
            children: [
              Gaps.h52,
              Expanded(
                child: Wrap(
                  spacing: 16,
                  children: event.participants.map((participant) {
                    bool isMe = participant == "ME";
                    return Text(
                      participant,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isMe
                                ? Colors.black
                                : _getParticipantTextColor(),
                            fontWeight:
                                isMe ? FontWeight.bold : FontWeight.w500,
                          ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
