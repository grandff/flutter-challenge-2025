import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // 임시로 비활성화
import 'dart:io';
import '../view_model/post_view_model.dart';
import '../utils/user_utils.dart';
import '../utils/image_upload_utils.dart';

class CreatePostBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback? onPostCreated;

  const CreatePostBottomSheet({
    super.key,
    this.onPostCreated,
  });

  @override
  ConsumerState<CreatePostBottomSheet> createState() =>
      _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends ConsumerState<CreatePostBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  bool _canPost = false;
  File? _attachedImage;
  String? _uploadedImageUrl;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    print('👤 [CreatePostBottomSheet] 사용자 프로필 로드 시작');
    try {
      final profile = await UserUtils.getUserProfile();
      if (mounted) {
        setState(() {
          _userProfile = profile;
        });
        print(
            '👤 [CreatePostBottomSheet] 사용자 프로필 로드 완료: ${profile?['name']} (${profile?['email']})');
      }
    } catch (e) {
      print('❌ [CreatePostBottomSheet] 사용자 프로필 로드 실패: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _canPost = _textController.text.trim().isNotEmpty;
    });
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Sizes.size20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: Sizes.size12),
              width: Sizes.size40,
              height: Sizes.size4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Sizes.size2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Sizes.size20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이미지 첨부',
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v20,

                  // Camera option
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(Sizes.size8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(Sizes.size8),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.blue[600],
                        size: Sizes.size24,
                      ),
                    ),
                    title: const Text(
                      '카메라로 촬영',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImageFromCamera();
                    },
                  ),

                  // Gallery option
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(Sizes.size8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(Sizes.size8),
                      ),
                      child: Icon(
                        Icons.photo_library,
                        color: Colors.green[600],
                        size: Sizes.size24,
                      ),
                    ),
                    title: const Text(
                      '갤러리에서 선택',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImageFromGallery();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    // Check camera permission
    final cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      // Request camera permission
      final result = await Permission.camera.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        _showPermissionDeniedDialog('카메라');
        return;
      }
    } else if (cameraStatus.isPermanentlyDenied) {
      _showPermissionDeniedDialog('카메라');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _attachedImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle error
      print('Error picking image from camera: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    // Check photos permission
    final photosStatus = await Permission.photos.status;

    if (photosStatus.isDenied) {
      // Request photos permission
      final result = await Permission.photos.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        _showPermissionDeniedDialog('사진');
        return;
      }
    } else if (photosStatus.isPermanentlyDenied) {
      _showPermissionDeniedDialog('사진');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _attachedImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle error
      print('Error picking image from gallery: $e');
    }
  }

  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionType 권한 필요'),
          content:
              Text('$permissionType 기능을 사용하려면 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('설정으로 이동'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Sizes.size16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: Sizes.size12),
            width: Sizes.size40,
            height: Sizes.size4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(Sizes.size2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size20,
              vertical: Sizes.size16,
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'New thread',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _canPost ? _handlePost : null,
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w600,
                      color: _canPost
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
              child: Column(
                children: [
                  // Profile section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile image
                      Container(
                        width: Sizes.size40,
                        height: Sizes.size40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: _userProfile != null
                            ? Center(
                                child: Text(
                                  UserUtils.getUserAvatarText(),
                                  style: TextStyle(
                                    fontSize: Sizes.size18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  size: Sizes.size20,
                                ),
                              ),
                      ),
                      Gaps.h12,
                      // Username and input field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userProfile?['email'] ??
                                  UserUtils.getUserEmail(),
                              style: TextStyle(
                                fontSize: Sizes.size16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            Gaps.v8,
                            TextField(
                              controller: _textController,
                              maxLines: null,
                              maxLength: 500,
                              decoration: InputDecoration(
                                hintText: 'Start a thread...',
                                hintStyle: TextStyle(
                                  fontSize: Sizes.size16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.6),
                                ),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              style: TextStyle(
                                fontSize: Sizes.size16,
                                height: 1.4,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Attachment button
                  Padding(
                    padding: const EdgeInsets.only(left: Sizes.size20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _showImageSourceBottomSheet();
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Color(0xFF4B5563),
                            size: Sizes.size20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Attached image display
                  if (_attachedImage != null || _uploadedImageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.size60,
                        top: Sizes.size12,
                        right: Sizes.size20,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Sizes.size12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Sizes.size12),
                              child: _uploadedImageUrl != null
                                  ? Image.network(
                                      _uploadedImageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                                Sizes.size12),
                                          ),
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey[400],
                                            size: Sizes.size32,
                                          ),
                                        );
                                      },
                                    )
                                  : Image.file(
                                      _attachedImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                                Sizes.size12),
                                          ),
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey[400],
                                            size: Sizes.size32,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          // Remove button
                          Positioned(
                            top: Sizes.size8,
                            right: Sizes.size8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _attachedImage = null;
                                  _uploadedImageUrl = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(Sizes.size4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: Sizes.size16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Bottom section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size20,
                      vertical: Sizes.size16,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Anyone can reply',
                          style: TextStyle(
                            fontSize: Sizes.size14,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _canPost ? _handlePost : null,
                          child: Text(
                            'Post',
                            style: TextStyle(
                              fontSize: Sizes.size16,
                              fontWeight: FontWeight.w600,
                              color: _canPost
                                  ? Colors.black
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePost() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    print('📝 [CreatePostBottomSheet] 게시글 작성 시작');
    print(
        '📝 [CreatePostBottomSheet] 내용: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');
    if (_attachedImage != null) {
      print('📝 [CreatePostBottomSheet] 첨부 이미지: ${_attachedImage!.path}');
    }

    try {
      // 이미지 업로드
      String? imageUrl;
      if (_attachedImage != null) {
        print('📸 [CreatePostBottomSheet] 이미지 업로드 시작');
        imageUrl = await ImageUploadUtils.uploadImage(_attachedImage!);
        if (imageUrl != null) {
          print('✅ [CreatePostBottomSheet] 이미지 업로드 성공: $imageUrl');
          // 업로드된 이미지 URL을 저장하여 UI에서 네트워크 이미지로 표시
          setState(() {
            _uploadedImageUrl = imageUrl;
          });
        } else {
          print('❌ [CreatePostBottomSheet] 이미지 업로드 실패');
        }
      }

      // 게시글 생성
      final post = await ref.read(postViewModelProvider.notifier).createPost(
            content: text,
            imageUrl: imageUrl,
          );

      if (post != null) {
        print('✅ [CreatePostBottomSheet] 게시글 작성 성공: ${post.id}');

        // Close the bottom sheet
        Navigator.of(context).pop();

        // Call the callback if provided
        widget.onPostCreated?.call();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('게시글이 성공적으로 작성되었습니다!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print('❌ [CreatePostBottomSheet] 게시글 작성 실패');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('게시글 작성에 실패했습니다. 다시 시도해주세요.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ [CreatePostBottomSheet] 게시글 작성 중 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
