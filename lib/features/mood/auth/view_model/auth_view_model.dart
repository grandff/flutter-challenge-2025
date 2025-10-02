import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_model.dart';
import '../repos/auth_repo.dart';

// Auth 상태를 관리하는 StateNotifier
class AuthViewModel extends StateNotifier<AuthModel> {
  AuthViewModel() : super(AuthModel.empty()) {
    _initializeAuth();
  }

  // 초기화 - 현재 인증 상태 확인
  void _initializeAuth() {
    final currentUser = AuthRepo.getCurrentUser();
    if (currentUser != null) {
      state = currentUser;
    }
  }

  // 이메일 업데이트
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  // 비밀번호 업데이트
  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  // 회원가입
  Future<void> signUp() async {
    if (!state.isValidForm) {
      throw Exception('이메일과 비밀번호를 올바르게 입력해주세요.');
    }

    try {
      final authModel = await AuthRepo.signUp(
        email: state.email,
        password: state.password,
      );
      state = authModel;
    } catch (e) {
      rethrow;
    }
  }

  // 로그인
  Future<void> signIn() async {
    if (!state.isValidForm) {
      throw Exception('이메일과 비밀번호를 올바르게 입력해주세요.');
    }

    try {
      final authModel = await AuthRepo.signIn(
        email: state.email,
        password: state.password,
      );
      state = authModel;
    } catch (e) {
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await AuthRepo.signOut();
      state = AuthModel.empty();
    } catch (e) {
      rethrow;
    }
  }

  // 폼 초기화
  void clearForm() {
    state = AuthModel.empty();
  }
}

// AuthViewModel Provider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthModel>((ref) {
  return AuthViewModel();
});

// 인증 상태 스트림 Provider
final authStateStreamProvider = StreamProvider<AuthModel?>((ref) {
  return AuthRepo.authStateChanges;
});

// 현재 사용자 Provider
final currentUserProvider = Provider<AuthModel?>((ref) {
  return AuthRepo.getCurrentUser();
});













