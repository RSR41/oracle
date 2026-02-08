import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 밤하늘 별 애니메이션 배경 위젯
/// - 중앙 큰 별: 360도 회전
/// - 작은 노란 별들: 은하수처럼 공전
/// - 흰 별들: 깜빡임 (밝아졌다 흐려졌다)
class StarryBackground extends StatefulWidget {
  final Widget? child;
  final bool showCentralStar;
  final bool animated;

  const StarryBackground({
    super.key,
    this.child,
    this.showCentralStar = true,
    this.animated = true,
  });

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _orbitController;
  late AnimationController _pulseController;

  late List<_Star> _whiteStars;
  late List<_OrbitingStar> _orbitingStars;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // 중앙 별 360도 회전 (12초에 한 바퀴)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    // 작은 별들 공전 (20초에 한 바퀴)
    _orbitController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    // 흰 별 깜빡임 (3초 주기)
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 흰 별들 생성 (깜빡이는 별 50개)
    _whiteStars = List.generate(
      50,
      (index) => _Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 1,
        pulseOffset: _random.nextDouble() * 2 * pi,
      ),
    );

    // 공전하는 노란 별들 생성 (15개)
    _orbitingStars = List.generate(
      15,
      (index) => _OrbitingStar(
        orbitRadius: 80 + _random.nextDouble() * 60,
        angle: _random.nextDouble() * 2 * pi,
        speed: 0.5 + _random.nextDouble() * 0.5,
        size: _random.nextDouble() * 3 + 2,
      ),
    );

    if (widget.animated) {
      _rotationController.repeat();
      _orbitController.repeat();
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.nightSkyGradient),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _orbitController,
          _pulseController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: _StarryPainter(
              whiteStars: _whiteStars,
              orbitingStars: _orbitingStars,
              rotationValue: _rotationController.value,
              orbitValue: _orbitController.value,
              pulseValue: _pulseController.value,
              showCentralStar: widget.showCentralStar,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double pulseOffset;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.pulseOffset,
  });
}

class _OrbitingStar {
  final double orbitRadius;
  final double angle;
  final double speed;
  final double size;

  _OrbitingStar({
    required this.orbitRadius,
    required this.angle,
    required this.speed,
    required this.size,
  });
}

class _StarryPainter extends CustomPainter {
  final List<_Star> whiteStars;
  final List<_OrbitingStar> orbitingStars;
  final double rotationValue;
  final double orbitValue;
  final double pulseValue;
  final bool showCentralStar;

  _StarryPainter({
    required this.whiteStars,
    required this.orbitingStars,
    required this.rotationValue,
    required this.orbitValue,
    required this.pulseValue,
    required this.showCentralStar,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);

    // 1. 흰 별들 (깜빡임 효과)
    for (final star in whiteStars) {
      final pulsePhase = (pulseValue * 2 * pi + star.pulseOffset) % (2 * pi);
      final opacity = 0.3 + 0.7 * ((sin(pulsePhase) + 1) / 2);

      final paint = Paint()
        ..color = AppColors.starWhite.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }

    // 2. 공전하는 노란 별들 (은하수 효과)
    for (final star in orbitingStars) {
      final currentAngle = star.angle + orbitValue * 2 * pi * star.speed;
      final x = center.dx + cos(currentAngle) * star.orbitRadius;
      final y = center.dy + sin(currentAngle) * star.orbitRadius * 0.4;

      final depth = (sin(currentAngle) + 1) / 2;
      final opacity = 0.4 + 0.6 * depth;
      final starSize = star.size * (0.7 + 0.3 * depth);

      final paint = Paint()
        ..color = AppColors.starYellow.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), starSize, paint);
    }

    // 3. 중앙 큰 별 (360도 회전)
    if (showCentralStar) {
      _drawCentralStar(canvas, center, rotationValue);
    }
  }

  void _drawCentralStar(Canvas canvas, Offset center, double rotation) {
    final starRadius = 35.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 2 * pi);

    final orbitPaint = Paint()
      ..color = AppColors.starGold.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset.zero, starRadius + 25, orbitPaint);
    canvas.drawCircle(
      Offset.zero,
      starRadius + 40,
      orbitPaint..color = AppColors.starGold.withValues(alpha: 0.15),
    );

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final x = cos(angle) * (starRadius + 25);
      final y = sin(angle) * (starRadius + 25);
      canvas.drawCircle(
        Offset(x, y),
        2,
        Paint()..color = AppColors.starGold.withValues(alpha: 0.5),
      );
    }

    canvas.restore();

    final bgPaint = Paint()
      ..color = AppColors.nightSkySurface
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, starRadius, bgPaint);

    final borderPaint = Paint()
      ..color = AppColors.starGold.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, starRadius, borderPaint);

    _drawStarShape(canvas, center, starRadius * 0.6, AppColors.starGold);
  }

  void _drawStarShape(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final path = Path();
    final innerRadius = radius * 0.4;

    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? radius : innerRadius;
      final angle = (i * pi / 5) - pi / 2;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(
      path.shift(const Offset(2, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.3),
    );

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _StarryPainter oldDelegate) {
    return rotationValue != oldDelegate.rotationValue ||
        orbitValue != oldDelegate.orbitValue ||
        pulseValue != oldDelegate.pulseValue;
  }
}
