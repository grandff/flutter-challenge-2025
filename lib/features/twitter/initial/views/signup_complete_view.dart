import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:flutter_study/features/twitter/initial/views/confirmation_code_view.dart';

import '../view_model/signup_view_model.dart';
import '../widgets/twitter_app_header.dart';

class SignupCompleteView extends ConsumerWidget {
  const SignupCompleteView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final signup = ref.watch(signupViewModelProvider);

    String formatDob(String dob) {
      try {
        final dt = DateTime.parse(dob);
        const months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      } catch (_) {
        return dob;
      }
    }

    Widget infoRow({
      required String label,
      required String value,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade800,
            ),
          ),
          Gaps.v8,
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF1DA1F2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          Gaps.v12,
          Divider(color: Colors.grey.shade300),
          Gaps.v12,
        ],
      );
    }

    final contactLabel = signup.isEmail ? 'Email' : 'Phone number';
    final contactValue = signup.contact;
    final dobValue = formatDob(signup.dateOfBirth);

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
                      'Create your account',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Gaps.v24,
                    infoRow(label: 'Name', value: signup.name),
                    infoRow(label: contactLabel, value: contactValue),
                    infoRow(label: 'Date of birth', value: dobValue),
                    Gaps.v20,
                    Text(
                      'By signing up, you agree to the Terms of Service and Privacy Policy, including Cookie Use. Twitter may use your contact information, including your email address and phone number for purposes outlined in our Privacy Policy, like keeping your account secure and personalizing our services, including ads. Learn more. Others will be able to find you by email or phone number, when provided, unless you choose otherwise here.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Sizes.size16),
              child: SizedBox(
                width: double.infinity,
                height: Sizes.size56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DA1F2),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ConfirmationCodeView(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
