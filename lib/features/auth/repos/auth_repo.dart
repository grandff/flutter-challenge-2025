import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../../core/supabase_client.dart';

class AuthRepo {
  final SupabaseClient _client = SupabaseService.client;

  // 로그인
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 회원가입 (이메일만)
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    print('🔐 [AuthRepo] 회원가입 시작 - Email: $email, Name: $name');

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      print('🔐 [AuthRepo] Supabase auth.signUp 응답: ${response.user?.id}');
      print('🔐 [AuthRepo] 사용자 이메일: ${response.user?.email}');
      print(
          '🔐 [AuthRepo] 이메일 확인 필요: ${response.user?.emailConfirmedAt == null}');
      print('✅ [AuthRepo] 트리거가 자동으로 members 테이블에 프로필을 생성합니다');

      return response;
    } catch (e) {
      print('❌ [AuthRepo] 회원가입 에러: $e');
      rethrow;
    }
  }

  // 현재 사용자 정보 가져오기
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // 사용자 프로필 정보 가져오기
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      print('📋 [AuthRepo] getUserProfile 시작 - UserID: $userId');
      final response =
          await _client.from('members').select().eq('id', userId).single();

      print(
          '📋 [AuthRepo] 프로필 조회 성공: ${response['name']} (${response['email']})');
      return UserModel.fromJson(json: response);
    } catch (e) {
      print('❌ [AuthRepo] 프로필 조회 실패: $e');
      return null;
    }
  }

  // 트리거가 프로필을 생성했는지 확인하는 메서드
  Future<bool> checkProfileExists(String userId) async {
    try {
      print('🔍 [AuthRepo] 프로필 존재 확인 - UserID: $userId');
      final response = await _client
          .from('members')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      final exists = response != null;
      print('🔍 [AuthRepo] 프로필 존재 여부: $exists');
      return exists;
    } catch (e) {
      print('❌ [AuthRepo] 프로필 존재 확인 실패: $e');
      return false;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // 인증 상태 스트림
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
