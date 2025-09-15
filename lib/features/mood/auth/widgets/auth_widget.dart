import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../view_model/auth_view_model.dart';
import 'auth_input_field.dart';
import '../../common/widgets/common_button_widget.dart';

class AuthWidget extends ConsumerStatefulWidget {
  final bool isSignUp;

  const AuthWidget({
    super.key,
    this.isSignUp = false,
  });

  @override
  ConsumerState<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends ConsumerState<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.isSignUp) {
        await ref.read(authViewModelProvider.notifier).signUp();
        if (mounted) {
          CherryToast.success(
            title: const Text('회원가입이 완료되었습니다!'),
          ).show(context);
        }
      } else {
        await ref.read(authViewModelProvider.notifier).signIn();
        if (mounted) {
          CherryToast.success(
            title: const Text('로그인되었습니다!'),
          ).show(context);
        }
      }
    } catch (e) {
      if (mounted) {
        CherryToast.error(
          title: const Text('오류'),
          description: Text(e.toString()),
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 상태 감시
    final authState = ref.watch(authViewModelProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F7E9), // 베이지색 배경
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 타이틀
                const Text(
                  '🔥 MOOD 🔥',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // 환영 메시지 또는 가입 메시지
                Text(
                  widget.isSignUp ? 'Join!' : 'Welcome!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),

                // 이메일 입력 필드
                AuthInputField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    ref.read(authViewModelProvider.notifier).updateEmail(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return '올바른 이메일 형식을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                AuthInputField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  onChanged: (value) {
                    ref
                        .read(authViewModelProvider.notifier)
                        .updatePassword(value);
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    if (value.length < 6) {
                      return '비밀번호는 6자 이상이어야 합니다';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // 메인 버튼 (회원가입 또는 로그인)
                AuthMainButton(
                  isSignUp: widget.isSignUp,
                  isLoading: _isLoading,
                  isEnabled: authState.isValidForm,
                  onPressed: authState.isValidForm ? _handleAuth : null,
                ),
                const SizedBox(height: 16),

                // 토글 버튼 (로그인 ↔ 회원가입)
                AuthToggleButton(
                  isSignUp: widget.isSignUp,
                  isEnabled: !_isLoading,
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (widget.isSignUp) {
                            context.go('/mood/login');
                          } else {
                            context.go('/mood/signup');
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
