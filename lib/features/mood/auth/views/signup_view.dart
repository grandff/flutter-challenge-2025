import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_widget.dart';
import '../view_model/auth_view_model.dart';
import '../models/auth_model.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 인증 상태 스트림을 감시
    ref.listen<AsyncValue<AuthModel?>>(
      authStateStreamProvider,
      (previous, next) {
        next.whenData((authModel) {
          if (authModel != null && authModel.isAuthenticated) {
            // 회원가입 성공 시 홈 화면으로 이동
            // 라우터의 redirect 로직이 자동으로 처리하므로 여기서는 페이지 새로고침만
            context.go('/mood/home');
          }
        });
      },
    );

    return const Scaffold(
      body: AuthWidget(isSignUp: true),
    );
  }
}
