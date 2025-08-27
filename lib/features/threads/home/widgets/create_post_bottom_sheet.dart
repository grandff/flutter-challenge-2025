import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

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
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
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
              color: Colors.grey[300],
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
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'New thread',
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                      color: _canPost ? Colors.black : Colors.grey[400],
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
                          color: Colors.blue[100],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/face1.jpeg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue[100],
                                ),
                                child: Icon(
                                  Icons.eco,
                                  color: Colors.green[600],
                                  size: Sizes.size20,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Gaps.h12,
                      // Username and input field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'jane_mobbin',
                              style: TextStyle(
                                fontSize: Sizes.size16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Gaps.v8,
                            TextField(
                              controller: _textController,
                              maxLines: null,
                              maxLength: 500,
                              decoration: const InputDecoration(
                                hintText: 'Start a thread...',
                                hintStyle: TextStyle(
                                  fontSize: Sizes.size16,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                                height: 1.4,
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
                  if (_attachedImage != null)
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
                              child: Image.file(
                                _attachedImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.circular(Sizes.size12),
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

  void _handlePost() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      // TODO: Implement post creation logic
      print('Creating post: $text');
      if (_attachedImage != null) {
        print('With attached image: ${_attachedImage!.path}');
      }

      // Close the bottom sheet
      Navigator.of(context).pop();

      // Call the callback if provided
      widget.onPostCreated?.call();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
