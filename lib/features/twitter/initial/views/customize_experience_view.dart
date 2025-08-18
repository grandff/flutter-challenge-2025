import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

import '../view_model/signup_view_model.dart';
import '../widgets/twitter_app_header.dart';
import 'signup_complete_view.dart';

class CustomizeExperienceView extends ConsumerWidget {
  const CustomizeExperienceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final signup = ref.watch(signupViewModelProvider);

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
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v20,
                    Text(
                      'Customize your\nexperience',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    Gaps.v24,
                    Text(
                      'Track where you see Twitter content across the web',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Gaps.v12,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Twitter uses this data to personalize your experience. '
                            'This web browsing history will never be stored with your name, email, or phone number.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.black87,
                              height: 1.35,
                            ),
                          ),
                        ),
                        Switch(
                          value: signup.trackAcrossWeb,
                          onChanged: (v) => ref
                              .read(signupViewModelProvider.notifier)
                              .setTrackAcrossWeb(v),
                        ),
                      ],
                    ),
                    Gaps.v20,
                    Text.rich(
                      TextSpan(
                        text: 'By signing up, you agree to our ',
                        children: const [
                          TextSpan(
                            text: 'Terms',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ', '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: ', and '),
                          TextSpan(
                            text: 'Cookie Use',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: '. '),
                        ],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ),
                    Gaps.v8,
                    Text(
                      'Twitter may use your contact information, including your email address and phone number for purposes outlined in our Privacy Policy. Learn more',
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
                    backgroundColor: signup.trackAcrossWeb
                        ? Colors.black
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: signup.trackAcrossWeb
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignupCompleteView(),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Next',
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
