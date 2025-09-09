import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase_client.dart';
import '../../../../features/auth/repos/auth_repo.dart';

class UserUtils {
  static final SupabaseClient _client = SupabaseService.client;
  static final AuthRepo _authRepo = AuthRepo();

  // 현재 로그인된 사용자 정보 가져오기
  static User? getCurrentUser() {
    final user = _client.auth.currentUser;
    print('👤 [UserUtils] 현재 사용자: ${user?.email ?? "로그인되지 않음"}');
    return user;
  }

  // 사용자 이메일 가져오기
  static String getUserEmail() {
    final user = getCurrentUser();
    return user?.email ?? 'guest@example.com';
  }

  // 사용자 이름 가져오기 (이메일에서 추출)
  static String getUserName() {
    final email = getUserEmail();
    return email.split('@')[0];
  }

  // 사용자 아바타 텍스트 (이메일 첫 글자)
  static String getUserAvatarText() {
    final name = getUserName();
    return name.isNotEmpty ? name[0].toUpperCase() : 'G';
  }

  // 사용자 프로필 정보 가져오기
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;

    try {
      print('👤 [UserUtils] 사용자 프로필 조회 시작 - UserID: ${user.id}');
      final profile = await _authRepo.getUserProfile(user.id);

      if (profile != null) {
        print('👤 [UserUtils] 프로필 조회 성공: ${profile.name} (${profile.email})');
        return {
          'id': profile.id,
          'email': profile.email,
          'name': profile.name,
        };
      } else {
        print('👤 [UserUtils] 프로필이 없습니다. 기본 정보 사용');
        return {
          'id': user.id,
          'email': user.email ?? '',
          'name': getUserName(),
        };
      }
    } catch (e) {
      print('❌ [UserUtils] 프로필 조회 실패: $e');
      return {
        'id': user.id,
        'email': user.email ?? '',
        'name': getUserName(),
      };
    }
  }
}
