import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

class ReportBottomSheet extends StatelessWidget {
  final String postId;
  final VoidCallback? onBack;

  const ReportBottomSheet({
    super.key,
    required this.postId,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.size16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Sizes.size12),
            width: Sizes.size40,
            height: Sizes.size4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Sizes.size2),
            ),
          ),
          Gaps.v20,
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
            child: Column(
              children: [
                const Text(
                  'Report',
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Gaps.v12,
                Text(
                  'Why are you reporting this thread? Your report is anonymous, except if you\'re reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services - don\'t wait.',
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Gaps.v20,
          // Report options
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildReportOption(
                  context: context,
                  title: 'I just don\'t like it',
                  onTap: () => _handleReportOption(context, 'dislike'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'It\'s unlawful content under NetzDG',
                  onTap: () => _handleReportOption(context, 'unlawful'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'It\'s spam',
                  onTap: () => _handleReportOption(context, 'spam'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'Hate speech or symbols',
                  onTap: () => _handleReportOption(context, 'hate_speech'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'Nudity or sexual activity',
                  onTap: () => _handleReportOption(context, 'nudity'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'False information',
                  onTap: () => _handleReportOption(context, 'false_info'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'Violence or dangerous organizations',
                  onTap: () => _handleReportOption(context, 'violence'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'Intellectual property infringement',
                  onTap: () => _handleReportOption(context, 'ip_infringement'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'Suicide or self-harm',
                  onTap: () => _handleReportOption(context, 'self_harm'),
                ),
                _buildReportOption(
                  context: context,
                  title: 'Eating disorders',
                  onTap: () => _handleReportOption(context, 'eating_disorder'),
                ),
              ],
            ),
          ),
          Gaps.v20,
        ],
      ),
    );
  }

  Widget _buildReportOption({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size20,
          vertical: Sizes.size16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: Sizes.size20,
            ),
          ],
        ),
      ),
    );
  }

  void _handleReportOption(BuildContext context, String reason) {
    // TODO: Implement report logic
    print('Reporting post $postId for reason: $reason');

    // Close the bottom sheet
    Navigator.of(context).pop();

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Submitted'),
        content:
            const Text('Thank you for your report. We will review it shortly.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
