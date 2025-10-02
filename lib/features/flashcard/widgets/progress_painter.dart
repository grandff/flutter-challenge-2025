import 'package:flutter/material.dart';

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  ProgressPainter({
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 배경 그리기
    paint.color = backgroundColor;
    paint.style = PaintingStyle.fill;

    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8.0),
    );
    canvas.drawRRect(backgroundRect, paint);

    // 진행률 그리기
    if (progress > 0) {
      paint.color = progressColor;

      final progressWidth = size.width * progress.clamp(0.0, 1.0);
      final progressRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, progressWidth, size.height),
        const Radius.circular(8.0),
      );
      canvas.drawRRect(progressRect, paint);
    }

    // 그라데이션 효과 추가
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          progressColor.withOpacity(0.8),
          progressColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    if (progress > 0) {
      final gradientRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * progress.clamp(0.0, 1.0), size.height),
        const Radius.circular(8.0),
      );
      canvas.drawRRect(gradientRect, Paint()..shader = gradientPaint.shader);
    }

    // 테두리 그리기
    paint.color = Colors.grey.shade300;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;

    final borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8.0),
    );
    canvas.drawRRect(borderRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ProgressPainter) {
      return oldDelegate.progress != progress ||
          oldDelegate.backgroundColor != backgroundColor ||
          oldDelegate.progressColor != progressColor;
    }
    return true;
  }
}

class ProgressBarWidget extends StatelessWidget {
  final double progress;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ProgressBarWidget({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.progressColor,
    this.height = 12.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      height: height,
      child: CustomPaint(
        painter: ProgressPainter(
          progress: progress,
          backgroundColor:
              backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
          progressColor: progressColor ?? theme.colorScheme.primary,
        ),
        size: Size.infinite,
      ),
    );
  }
}



