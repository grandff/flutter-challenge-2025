import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mood_model.dart';

class MoodRepo {
  static final SupabaseClient _client = Supabase.instance.client;

  // 무드 목록 가져오기
  static Future<List<MoodModel>> getMoods({required String userId}) async {
    try {
      print('🔧 [MoodRepo] 무드 목록 가져오기 시작: $userId');

      final response = await _client
          .from('moods')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final moods = (response as List)
          .map((json) => MoodModel.fromJson(json: json))
          .toList();

      print('✅ [MoodRepo] 무드 목록 가져오기 성공: ${moods.length}개');
      return moods;
    } catch (e) {
      print('❌ [MoodRepo] 무드 목록 가져오기 실패: $e');
      rethrow;
    }
  }

  // 무드 생성
  static Future<MoodModel> createMood({
    required String userId,
    required String emoji,
    required String description,
  }) async {
    try {
      print('🔧 [MoodRepo] 무드 생성 시작: $userId');

      final response = await _client
          .from('moods')
          .insert({
            'user_id': userId,
            'emoji': emoji,
            'description': description,
          })
          .select()
          .single();

      final mood = MoodModel.fromJson(json: response);
      print('✅ [MoodRepo] 무드 생성 성공: ${mood.id}');
      return mood;
    } catch (e) {
      print('❌ [MoodRepo] 무드 생성 실패: $e');
      rethrow;
    }
  }

  // 무드 삭제
  static Future<void> deleteMood({required String moodId}) async {
    try {
      print('🔧 [MoodRepo] 무드 삭제 시작: $moodId');

      await _client.from('moods').delete().eq('id', moodId);

      print('✅ [MoodRepo] 무드 삭제 성공: $moodId');
    } catch (e) {
      print('❌ [MoodRepo] 무드 삭제 실패: $e');
      rethrow;
    }
  }

  // 무드 업데이트
  static Future<MoodModel> updateMood({
    required String moodId,
    required String emoji,
    required String description,
  }) async {
    try {
      print('🔧 [MoodRepo] 무드 업데이트 시작: $moodId');

      final response = await _client
          .from('moods')
          .update({
            'emoji': emoji,
            'description': description,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', moodId)
          .select()
          .single();

      final mood = MoodModel.fromJson(json: response);
      print('✅ [MoodRepo] 무드 업데이트 성공: ${mood.id}');
      return mood;
    } catch (e) {
      print('❌ [MoodRepo] 무드 업데이트 실패: $e');
      rethrow;
    }
  }

  // 무드 스트림 (실시간 업데이트)
  static Stream<List<MoodModel>> getMoodsStream({required String userId}) {
    return _client
        .from('moods')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) =>
            data.map((json) => MoodModel.fromJson(json: json)).toList());
  }
}


