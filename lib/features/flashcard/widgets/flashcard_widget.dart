import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flashcard_model.dart';

class FlashcardWidget extends ConsumerStatefulWidget {
  final FlashcardModel card;
  final FlashcardModel? nextCard;
  final VoidCallback? onTap;
  final Function(double)? onDragUpdate;
  final Function(double)? onDragEnd;

  const FlashcardWidget({
    super.key,
    required this.card,
    this.nextCard,
    this.onTap,
    this.onDragUpdate,
    this.onDragEnd,
  });

  @override
  ConsumerState<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends ConsumerState<FlashcardWidget>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _flyOffController;
  late Animation<double> _flipAnimation;
  late Animation<double> _flyOffAnimation;
  double _dragOffset = 0.0;
  bool _isDragging = false;
  bool _showReviewText = false;
  bool _isFlyingOff = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _flyOffController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flyOffAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flyOffController,
      curve: Curves.easeInBack,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _flyOffController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 카드가 바뀌었을 때 애니메이션 리셋
    if (oldWidget.card.id != widget.card.id) {
      _flipController.reset();
      _flyOffController.reset();
      _dragOffset = 0.0;
      _isDragging = false;
      _showReviewText = false;
      _isFlyingOff = false;
    }

    // 뒤집기 상태 변경 시 애니메이션 업데이트
    if (oldWidget.card.isFlipped != widget.card.isFlipped) {
      if (widget.card.isFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  void _handleTap() {
    // 탭 시 애니메이션 직접 트리거
    if (_flipController.value < 0.5) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    widget.onTap?.call();
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _showReviewText = false;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    setState(() {
      _dragOffset += details.delta.dx;
      // 스와이프 시작부터 텍스트 표시 (5px 이상)
      _showReviewText = _dragOffset.abs() > 5;
    });

    widget.onDragUpdate?.call(_dragOffset);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    // 충분히 드래그되었으면 fly off 애니메이션 시작
    if (_dragOffset.abs() > 200) {
      setState(() {
        _isFlyingOff = true;
      });
      _flyOffController.forward().then((_) {
        widget.onDragEnd?.call(_dragOffset);
      });
    } else {
      widget.onDragEnd?.call(_dragOffset);
    }

    setState(() {
      _isDragging = false;
      if (_dragOffset.abs() <= 200) {
        _dragOffset = 0.0;
        _showReviewText = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.8; // 카드 너비 축소
    final cardHeight = cardWidth * 1.2; // 정사각형보다 살짝 세로가 긴 직사각형

    return GestureDetector(
      onTap: _handleTap,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        children: [
          // 다음 카드 (뒤에 표시)
          if (widget.nextCard != null && _dragOffset.abs() > 10)
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(
                  // 스와이프 강도에 따라 거리 조절 (최대 60px에서 최소 5px까지)
                  (_dragOffset > 0 ? -1 : 1) *
                      (60 - (_dragOffset.abs() / 5).clamp(0, 55)),
                  10 - (_dragOffset.abs() / 20).clamp(0, 5), // Y축도 살짝 조절
                ),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        widget.nextCard!.question,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 스와이프 방향별 텍스트 (애니메이션 추가)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            top: _showReviewText
                ? (screenSize.height - 120) // progress bar 상단에서 60px 위
                : (screenSize.height - 100), // progress bar 상단에서 40px 위
            left: 20,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _showReviewText ? 1.0 : 0.0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: _showReviewText ? 1.0 : 0.8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _dragOffset < 0
                        ? Colors.red.shade400
                        : Colors.green.shade400,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _dragOffset < 0 ? 'Need to Review' : 'I got it right',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // 플래시 카드
          AnimatedBuilder(
            animation: Listenable.merge([_flipAnimation, _flyOffAnimation]),
            builder: (context, child) {
              final flyOffOffset = _isFlyingOff
                  ? (_dragOffset > 0 ? screenSize.width : -screenSize.width) *
                      _flyOffAnimation.value
                  : 0.0;

              return Transform.translate(
                offset: Offset(_dragOffset + flyOffOffset, 0),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_flipAnimation.value * 3.14159),
                  child: Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: _flipAnimation.value < 0.5
                        ? _buildFrontCard(theme)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(3.14159),
                            child: _buildBackCard(theme),
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFrontCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            widget.card.question,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.secondaryContainer,
            theme.colorScheme.secondaryContainer.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            widget.card.answer,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
