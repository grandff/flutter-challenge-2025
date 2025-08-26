import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_study/constants/gaps.dart';
import 'package:flutter_study/constants/sizes.dart';

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
                            // TODO: Implement attachment functionality
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
