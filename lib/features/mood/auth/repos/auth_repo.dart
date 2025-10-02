import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auth_model.dart';

class AuthRepo {
  static final SupabaseClient _client = Supabase.instance.client;

  // 회원가입
  static Future<AuthModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      print('🔧 [AuthRepo] 회원가입 시작: $email');
      
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('✅ [AuthRepo] 회원가입 성공: ${response.user!.id}');
        return AuthModel(
          email: email,
          password: password,
          userId: response.user!.id,
          sessionToken: response.session?.accessToken,
          isAuthenticated: true,
        );
      } else {
        throw Exception('회원가입 실패: 사용자 정보를 가져올 수 없습니다.');
      }
    } catch (e) {
      print('❌ [AuthRepo] 회원가입 실패: $e');
      rethrow;
    }
  }

  // 로그인
  static Future<AuthModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔧 [AuthRepo] 로그인 시작: $email');
      
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('✅ [AuthRepo] 로그인 성공: ${response.user!.id}');
        return AuthModel(
          email: email,
          password: password,
          userId: response.user!.id,
          sessionToken: response.session?.accessToken,
          isAuthenticated: true,
        );
      } else {
        throw Exception('로그인 실패: 사용자 정보를 가져올 수 없습니다.');
      }
    } catch (e) {
      print('❌ [AuthRepo] 로그인 실패: $e');
      rethrow;
    }
  }

  // 로그아웃
  static Future<void> signOut() async {
    try {
      print('🔧 [AuthRepo] 로그아웃 시작');
      await _client.auth.signOut();
      print('✅ [AuthRepo] 로그아웃 성공');
    } catch (e) {
      print('❌ [AuthRepo] 로그아웃 실패: $e');
      rethrow;
    }
  }

  // 현재 사용자 정보 가져오기
  static AuthModel? getCurrentUser() {
    try {
      final user = _client.auth.currentUser;
      if (user != null) {
        return AuthModel(
          email: user.email ?? '',
          password: '',
          userId: user.id,
          sessionToken: _client.auth.currentSession?.accessToken,
          isAuthenticated: true,
        );
      }
      return null;
    } catch (e) {
      print('❌ [AuthRepo] 현재 사용자 정보 가져오기 실패: $e');
      return null;
    }
  }

  // 인증 상태 스트림
  static Stream<AuthModel?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user != null) {
        return AuthModel(
          email: user.email ?? '',
          password: '',
          userId: user.id,
          sessionToken: data.session?.accessToken,
          isAuthenticated: true,
        );
      }
      return null;
    });
  }
}













