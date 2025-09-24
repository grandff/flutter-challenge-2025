import 'package:flutter/material.dart';

class ExplicitAnimationView extends StatefulWidget {
  const ExplicitAnimationView({super.key});

  @override
  State<ExplicitAnimationView> createState() => _ExplicitAnimationViewState();
}

class _ExplicitAnimationViewState extends State<ExplicitAnimationView>
    with TickerProviderStateMixin {
  late List<List<AnimationController>> _controllers;
  late List<List<AnimationController>> _fadeOutControllers;
  late List<List<Animation<double>>> _animations;
  late List<List<Animation<double>>> _fadeOutAnimations;
  int _currentRow = 4; // 5번째 줄(맨 아래)부터 시작
  int _currentCol = 0;
  bool _isFadeInPhase = true; // true: fade in, false: fade out

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    // fade in용 컨트롤러 (빠르게)
    _controllers = List.generate(5, (row) {
      return List.generate(5, (col) {
        return AnimationController(
          duration: const Duration(milliseconds: 15), // 1초에 맞춰 조정
          vsync: this,
        );
      });
    });

    // fade out용 컨트롤러 (천천히)
    _fadeOutControllers = List.generate(5, (row) {
      return List.generate(5, (col) {
        return AnimationController(
          duration: const Duration(milliseconds: 25), // 1초에 맞춰 조정
          vsync: this,
        );
      });
    });

    _animations = _controllers.map((row) {
      return row.map((controller) {
        return Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ));
      }).toList();
    }).toList();

    _fadeOutAnimations = _fadeOutControllers.map((row) {
      return row.map((controller) {
        return Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ));
      }).toList();
    }).toList();

    // fade out 컨트롤러들을 먼저 forward()로 초기화
    for (int row = 0; row < 5; row++) {
      for (int col = 0; col < 5; col++) {
        _fadeOutControllers[row][col].forward();
      }
    }
  }

  void _startAnimation() {
    _animateRow();
  }

  void _animateRow() {
    if (_currentRow < 0) {
      if (_isFadeInPhase) {
        // fade in 완료, 즉시 fade out 시작
        _isFadeInPhase = false;
        _currentRow = 4;
        _currentCol = 0;
        _animateRowSquares();
      } else {
        // fade out 완료, 즉시 fade in 시작
        _isFadeInPhase = true;
        _currentRow = 4;
        _currentCol = 0;
        // fade in 컨트롤러들 리셋
        for (int row = 0; row < 5; row++) {
          for (int col = 0; col < 5; col++) {
            _controllers[row][col].reset();
          }
        }
        // fade out 컨트롤러들 다시 forward()로 초기화
        for (int row = 0; row < 5; row++) {
          for (int col = 0; col < 5; col++) {
            _fadeOutControllers[row][col].forward();
          }
        }
        _animateRowSquares();
      }
      return;
    }

    // 현재 줄의 모든 사각형을 방향에 따라 순차적으로 애니메이션
    _animateRowSquares();
  }

  void _animateRowSquares() {
    if (_currentCol >= 5) {
      // 현재 줄 완료, 다음 줄로 이동
      _currentRow--;
      _currentCol = 0;
      Future.delayed(const Duration(milliseconds: 0), () {
        if (mounted) {
          _animateRow();
        }
      });
      return;
    }

    // 방향에 따라 사각형 순서 결정
    int col = _isLeftDirection(_currentRow) ? _currentCol : (4 - _currentCol);

    if (_isFadeInPhase) {
      // fade in
      _controllers[_currentRow][col].forward().then((_) {
        Future.delayed(const Duration(milliseconds: 0), () {
          if (mounted) {
            _currentCol++;
            _animateRowSquares();
          }
        });
      });
    } else {
      // fade out (천천히)
      _fadeOutControllers[_currentRow][col].reverse().then((_) {
        Future.delayed(const Duration(milliseconds: 0), () {
          if (mounted) {
            _currentCol++;
            _animateRowSquares();
          }
        });
      });
    }
  }

  bool _isLeftDirection(int row) {
    // 5번째 줄(4): 왼쪽, 4번째 줄(3): 오른쪽, 3번째 줄(2): 왼쪽, 2번째 줄(1): 오른쪽, 1번째 줄(0): 왼쪽
    return row % 2 == 0;
  }

  @override
  void dispose() {
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    for (var row in _fadeOutControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 40; // 좌우 여백 20씩
    const squareSize = 25.0;
    final spacing = (availableWidth - (5 * squareSize)) / 6; // 사각형들 사이 간격 계산

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (row) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (col) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                      child: _buildAnimatedSquare(row, col),
                    );
                  }),
                ),
                if (row < 4) const SizedBox(height: 30), // 세로 간격 더 증가
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAnimatedSquare(int row, int col) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_animations[row][col], _fadeOutAnimations[row][col]]),
      builder: (context, child) {
        double fadeInOpacity = _animations[row][col].value;
        double fadeOutOpacity = _fadeOutAnimations[row][col].value;
        double finalOpacity = _isFadeInPhase ? fadeInOpacity : fadeOutOpacity;

        return Opacity(
          opacity: finalOpacity,
          child: Container(
            width: 25, // 1/2 크기 (50 -> 25)
            height: 25, // 1/2 크기 (50 -> 25)
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
