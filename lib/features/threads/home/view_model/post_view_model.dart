import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repos/post_repo.dart';
import '../models/post_model.dart';

final postRepoProvider = Provider<PostRepo>((ref) => PostRepo());

final postsProvider = FutureProvider<List<PostModel>>((ref) async {
  final postRepo = ref.watch(postRepoProvider);
  return await postRepo.getAllPosts();
});

class PostViewModel extends StateNotifier<AsyncValue<void>> {
  final PostRepo _postRepo;

  PostViewModel(this._postRepo) : super(const AsyncValue.data(null));

  // 게시글 생성
  Future<PostModel?> createPost({
    required String content,
    String? imageUrl,
  }) async {
    print('🚀 [PostViewModel] createPost 호출 시작');
    state = const AsyncValue.loading();

    try {
      final post = await _postRepo.createPost(
        content: content,
        imageUrl: imageUrl,
      );

      print('✅ [PostViewModel] 게시글 생성 성공: ${post.id}');
      state = const AsyncValue.data(null);

      return post;
    } catch (error, stackTrace) {
      print('❌ [PostViewModel] 게시글 생성 실패: $error');
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  // 게시글 삭제
  Future<void> deletePost(String postId) async {
    print('🗑️ [PostViewModel] deletePost 호출 시작 - PostID: $postId');
    state = const AsyncValue.loading();

    try {
      await _postRepo.deletePost(postId);
      print('✅ [PostViewModel] 게시글 삭제 성공');
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      print('❌ [PostViewModel] 게시글 삭제 실패: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // 게시글 수정
  Future<PostModel?> updatePost({
    required String postId,
    required String content,
    String? imageUrl,
  }) async {
    print('✏️ [PostViewModel] updatePost 호출 시작 - PostID: $postId');
    state = const AsyncValue.loading();

    try {
      final post = await _postRepo.updatePost(
        postId: postId,
        content: content,
        imageUrl: imageUrl,
      );

      print('✅ [PostViewModel] 게시글 수정 성공');
      state = const AsyncValue.data(null);

      return post;
    } catch (error, stackTrace) {
      print('❌ [PostViewModel] 게시글 수정 실패: $error');
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }
}

final postViewModelProvider =
    StateNotifierProvider<PostViewModel, AsyncValue<void>>((ref) {
  final postRepo = ref.watch(postRepoProvider);
  return PostViewModel(postRepo);
});
