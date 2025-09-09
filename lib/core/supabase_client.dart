import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    print('🔧 [SupabaseService] Supabase 초기화 시작');
    print('🔧 [SupabaseService] URL: ${SupabaseConfig.url}');
    print(
        '🔧 [SupabaseService] AnonKey: ${SupabaseConfig.anonKey.substring(0, 20)}...');

    try {
      await Supabase.initialize(
        url: SupabaseConfig.url,
        anonKey: SupabaseConfig.anonKey,
      );
      print('✅ [SupabaseService] Supabase 초기화 완료');
    } catch (e) {
      print('❌ [SupabaseService] Supabase 초기화 실패: $e');
      rethrow;
    }
  }
}
