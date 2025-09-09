import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase_client.dart';
import 'user_utils.dart';

class ImageUploadUtils {
  static final SupabaseClient _client = SupabaseService.client;

  // 이미지 업로드
  static Future<String?> uploadImage(File imageFile) async {
    print('📸 [ImageUploadUtils] 이미지 업로드 시작');

    try {
      final user = UserUtils.getCurrentUser();
      if (user == null) {
        print('❌ [ImageUploadUtils] 사용자가 로그인되지 않았습니다');
        return null;
      }

      // 파일명 생성 (사용자ID_타임스탬프.확장자)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = imageFile.path.split('.').last;
      final fileName = '${user.id}_$timestamp.$extension';
      final filePath = 'posts/$fileName';

      print('📸 [ImageUploadUtils] 업로드할 파일: $filePath');

      // 이미지 파일을 바이트로 읽기
      final bytes = await imageFile.readAsBytes();
      print('📸 [ImageUploadUtils] 파일 크기: ${bytes.length} bytes');

      // Supabase Storage에 업로드
      final response =
          await _client.storage.from('medias').uploadBinary(filePath, bytes);

      print('📸 [ImageUploadUtils] 업로드 성공: $response');

      // 공개 URL 생성
      final publicUrl = _client.storage.from('medias').getPublicUrl(filePath);

      print('📸 [ImageUploadUtils] 공개 URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ [ImageUploadUtils] 이미지 업로드 실패: $e');
      return null;
    }
  }

  // 이미지 삭제
  static Future<bool> deleteImage(String imageUrl) async {
    print('🗑️ [ImageUploadUtils] 이미지 삭제 시작: $imageUrl');

    try {
      // URL에서 파일 경로 추출
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length < 3) {
        print('❌ [ImageUploadUtils] 잘못된 이미지 URL 형식');
        return false;
      }

      // 'storage/v1/object/public/medias/posts/...' 에서 'posts/...' 부분 추출
      final filePath =
          pathSegments.sublist(pathSegments.indexOf('medias') + 1).join('/');

      print('🗑️ [ImageUploadUtils] 삭제할 파일 경로: $filePath');

      await _client.storage.from('medias').remove([filePath]);

      print('✅ [ImageUploadUtils] 이미지 삭제 성공');
      return true;
    } catch (e) {
      print('❌ [ImageUploadUtils] 이미지 삭제 실패: $e');
      return false;
    }
  }

  // 이미지 압축 (선택사항)
  static Future<File?> compressImage(File imageFile) async {
    print('🗜️ [ImageUploadUtils] 이미지 압축 시작');

    try {
      // 현재는 원본 파일을 그대로 반환
      // 필요시 image 패키지를 사용하여 압축 로직 구현 가능
      print('🗜️ [ImageUploadUtils] 이미지 압축 완료 (원본 사용)');
      return imageFile;
    } catch (e) {
      print('❌ [ImageUploadUtils] 이미지 압축 실패: $e');
      return null;
    }
  }
}
