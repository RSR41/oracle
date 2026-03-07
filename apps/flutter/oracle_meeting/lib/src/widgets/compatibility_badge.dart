import 'package:flutter/material.dart';
import '../theme/meeting_theme.dart';

/// Circular badge showing compatibility score with color bands
class CompatibilityBadge extends StatelessWidget {
  final int score;
  final double size;

  const CompatibilityBadge({
    super.key,
    required this.score,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final band = _bandFromScore(score);
    final bandColor = MeetingTheme.bandColor(band);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bandColor, bandColor.withValues(alpha: 0.7)],
        ),
        boxShadow: [
          BoxShadow(
            color: bandColor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score',
            style: TextStyle(
              fontSize: size * 0.32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            _bandLabelKo(band),
            style: TextStyle(
              fontSize: size * 0.17,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  String _bandFromScore(int score) {
    if (score >= 90) return 'EXCELLENT';
    if (score >= 75) return 'GOOD';
    if (score >= 60) return 'NORMAL';
    return 'CAUTION';
  }

  String _bandLabelKo(String band) {
    switch (band) {
      case 'EXCELLENT':
        return '최고';
      case 'GOOD':
        return '좋음';
      case 'NORMAL':
        return '보통';
      default:
        return '보통';
    }
  }
}

/// Small inline compatibility chip
class CompatibilityChip extends StatelessWidget {
  final int score;

  const CompatibilityChip({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final band = score >= 90
        ? 'EXCELLENT'
        : score >= 75
            ? 'GOOD'
            : score >= 60
                ? 'NORMAL'
                : 'CAUTION';
    final color = MeetingTheme.bandColor(band);
    final label = score >= 90
        ? '💜 최고 궁합'
        : score >= 75
            ? '💕 좋은 궁합'
            : score >= 60
                ? '✨ 보통 궁합'
                : '궁합';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label $score점',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
