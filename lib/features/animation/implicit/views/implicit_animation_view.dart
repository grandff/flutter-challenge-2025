import 'package:flutter/material.dart';

class ImplicitAnimationView extends StatefulWidget {
  const ImplicitAnimationView({super.key});

  @override
  State<ImplicitAnimationView> createState() => _ImplicitAnimationViewState();
}

class _ImplicitAnimationViewState extends State<ImplicitAnimationView> {
  bool isScreen1 = true; // true: 화면1, false: 화면2
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _animateToRight();
      }
    });
  }

  void _animateToRight() {
    if (!mounted) return;
    setState(() {
      isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          isScreen1 = !isScreen1;
          isAnimating = false;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
          _animateToLeft();
        });
      }
    });
  }

  void _animateToLeft() {
    if (!mounted) return;
    setState(() {
      isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          isScreen1 = !isScreen1;
          isAnimating = false;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
          _animateToRight();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isScreen1 ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // 중앙 도형
          Center(
            child: Container(
              width: 250, // 2.5배 크기 (100 * 2.5)
              height: 250, // 2.5배 크기 (100 * 2.5)
              decoration: BoxDecoration(
                color: Colors.red,
                shape: isScreen1 ? BoxShape.rectangle : BoxShape.circle,
              ),
            ),
          ),
          // 이동하는 직사각형 (빨간색 도형 위에서만 이동)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            left: isAnimating
                ? (isScreen1
                    ? MediaQuery.of(context).size.width / 2 - 125
                    : MediaQuery.of(context).size.width / 2 +
                        125) // 빨간색 도형의 왼쪽 끝에서 시작, 오른쪽 끝으로 이동
                : (isScreen1
                    ? MediaQuery.of(context).size.width / 2 + 125
                    : MediaQuery.of(context).size.width / 2 -
                        125), // 빨간색 도형의 오른쪽 끝에서 시작, 왼쪽 끝으로 이동
            top: MediaQuery.of(context).size.height / 2 - 125, // 빨간색 도형의 중앙 높이
            child: Container(
              width: 20, // 가로길이 20px
              height: 250, // 빨간색 도형과 같은 세로길이
              color: isScreen1 ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
