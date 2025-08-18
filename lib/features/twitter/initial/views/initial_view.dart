import 'package:flutter/material.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:hugeicons/hugeicons.dart';

import '../widgets/social_login_button.dart';
import 'create_account_view.dart';
import '../widgets/twitter_app_header.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gaps.v24,
              const TwitterAppHeader(),
              const Spacer(),
              Text(
                "See what's happening in the world right now.",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              Gaps.v28,
              SocialLoginButton(
                icon: HugeIcons.strokeRoundedGoogle,
                label: 'Continue with Google',
                onPressed: () {
                  // TODO: integrate Google Sign-In
                },
              ),
              Gaps.v12,
              SocialLoginButton(
                icon: HugeIcons.strokeRoundedApple,
                label: 'Continue with Apple',
                onPressed: () {
                  // TODO: integrate Apple Sign-In
                },
              ),
              Gaps.v20,
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              Gaps.v16,
              SizedBox(
                height: Sizes.size56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateAccountView(),
                      ),
                    );
                  },
                  child: const Text('Create account'),
                ),
              ),
              Gaps.v16,
              Text.rich(
                TextSpan(
                  text: 'By signing up, you agree to our ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
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
                    TextSpan(text: '.'),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.size12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account already? ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Log in',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF1DA1F2),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
