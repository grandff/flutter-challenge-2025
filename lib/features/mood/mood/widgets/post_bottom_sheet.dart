import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../view_model/mood_view_model.dart';
import '../../common/widgets/common_button_widget.dart';

class PostBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback? onMoodCreated;

  const PostBottomSheet({
    super.key,
    this.onMoodCreated,
  });

  @override
  ConsumerState<PostBottomSheet> createState() => _PostBottomSheetState();
}

class _PostBottomSheetState extends ConsumerState<PostBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _selectedEmoji = '';
  bool _isLoading = false;

  // 사용 가능한 이모지 목록
  final List<String> _emojis = [
    '😊',
    '😢',
    '😡',
    '😍',
    '🤔',
    '😴',
    '😎',
    '🥳',
    '😰',
    '😤',
    '😭',
    '🤗',
    '😏',
    '😌',
    '🤩',
    '😔',
    '😋',
    '😳',
    '🤯',
    '🥺',
    '😇',
    '🤢',
    '😈',
    '🤠',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _descriptionController.text.trim().isNotEmpty &&
        _selectedEmoji.isNotEmpty;
  }

  Future<void> _createMood() async {
    if (!_formKey.currentState!.validate() || !_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(moodViewModelProvider.notifier).createMood(
            emoji: _selectedEmoji,
            description: _descriptionController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onMoodCreated?.call();
        CherryToast.success(
          title: const Text('무드가 등록되었습니다!'),
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        CherryToast.error(
          title: const Text('오류'),
          description: Text(e.toString()),
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sheet(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F7E9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'How do you feel?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 감정 설명 입력
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    onChanged: (value) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '감정을 설명해주세요';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: '오늘의 감정을 자유롭게 표현해보세요...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 이모지 선택 섹션
                const Text(
                  'What\'s your mood?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // 이모지 그리드
                SizedBox(
                  height: 200, // 높이를 120에서 200으로 증가
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _emojis.length,
                    itemBuilder: (context, index) {
                      final emoji = _emojis[index];
                      final isSelected = _selectedEmoji == emoji;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmoji = emoji;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF9A8D4)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected ? Colors.black : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Post 버튼
                CommonButtonWidget(
                  text: 'Post',
                  onPressed: _isFormValid ? _createMood : null,
                  isLoading: _isLoading,
                  isEnabled: _isFormValid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
