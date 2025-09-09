import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import '../../../../core/supabase_client.dart';

class PostRepo {
  final SupabaseClient _client = SupabaseService.client;

  // 게시글 생성
  Future<PostModel> createPost({
    required String content,
    String? imageUrl,
  }) async {
    print(
        '📝 [PostRepo] 게시글 생성 시작 - Content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...');

    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        throw Exception('사용자가 로그인되지 않았습니다');
      }

      print('📝 [PostRepo] 현재 사용자 ID: ${user.id}');

      final postData = {
        'user_id': user.id,
        'content': content,
        'image_url': imageUrl,
      };

      print('📝 [PostRepo] 삽입할 데이터: $postData');

      final response =
          await _client.from('posts').insert(postData).select().single();

      print('📝 [PostRepo] 게시글 생성 성공: ${response['id']}');

      return PostModel.fromJson(json: response);
    } catch (e) {
      print('❌ [PostRepo] 게시글 생성 실패: $e');
      rethrow;
    }
  }

  // 모든 게시글 조회 (최신순) - 사용자 정보 포함
  Future<List<PostModel>> getAllPosts() async {
    print('📋 [PostRepo] 모든 게시글 조회 시작');

    try {
      final response = await _client
          .from('posts')
          .select('*')
          .order('created_at', ascending: false);

      print('📋 [PostRepo] 게시글 조회 성공: ${response.length}개');

      // 각 게시글에 대해 사용자 정보를 별도로 조회
      final postsWithUserInfo = <PostModel>[];

      for (final postData in response) {
        try {
          // 사용자 정보 조회
          final userResponse = await _client
              .from('members')
              .select('email, name')
              .eq('id', postData['user_id'])
              .single();

          print('👤 [PostRepo] 사용자 정보 조회: ${userResponse['email']}');

          // 사용자 정보를 postData에 추가
          postData['username'] = userResponse['email'] ?? '';
          postData['user_profile_image'] = '';
          postData['is_verified'] = false;

          postsWithUserInfo.add(PostModel.fromJson(json: postData));
        } catch (userError) {
          print('❌ [PostRepo] 사용자 정보 조회 실패: $userError');
          // 사용자 정보가 없어도 게시글은 표시
          postData['username'] = 'Unknown User';
          postData['user_profile_image'] = '';
          postData['is_verified'] = false;
          postsWithUserInfo.add(PostModel.fromJson(json: postData));
        }
      }

      return postsWithUserInfo;
    } catch (e) {
      print('❌ [PostRepo] 게시글 조회 실패: $e');
      rethrow;
    }
  }

  // 특정 사용자의 게시글 조회
  Future<List<PostModel>> getPostsByUserId(String userId) async {
    print('📋 [PostRepo] 사용자 게시글 조회 시작 - UserID: $userId');

    try {
      final response = await _client
          .from('posts')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('📋 [PostRepo] 사용자 게시글 조회 성공: ${response.length}개');

      return response.map((json) => PostModel.fromJson(json: json)).toList();
    } catch (e) {
      print('❌ [PostRepo] 사용자 게시글 조회 실패: $e');
      rethrow;
    }
  }

  // 게시글 삭제
  Future<void> deletePost(String postId) async {
    print('🗑️ [PostRepo] 게시글 삭제 시작 - PostID: $postId');

    try {
      await _client.from('posts').delete().eq('id', postId);
      print('🗑️ [PostRepo] 게시글 삭제 성공');
    } catch (e) {
      print('❌ [PostRepo] 게시글 삭제 실패: $e');
      rethrow;
    }
  }

  // 게시글 수정
  Future<PostModel> updatePost({
    required String postId,
    required String content,
    String? imageUrl,
  }) async {
    print('✏️ [PostRepo] 게시글 수정 시작 - PostID: $postId');

    try {
      final updateData = {
        'content': content,
        'image_url': imageUrl,
      };

      final response = await _client
          .from('posts')
          .update(updateData)
          .eq('id', postId)
          .select()
          .single();

      print('✏️ [PostRepo] 게시글 수정 성공');

      return PostModel.fromJson(json: response);
    } catch (e) {
      print('❌ [PostRepo] 게시글 수정 실패: $e');
      rethrow;
    }
  }
}
