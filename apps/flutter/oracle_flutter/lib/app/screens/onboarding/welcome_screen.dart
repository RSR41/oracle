import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/starry_background.dart';
import '../../theme/app_colors.dart';

/// 첫 실행 시 나오는 웰컴 화면
/// - 밤하늘 별 애니메이션 배경
/// - 중앙 회전하는 별 로고
/// - "四柱命理 / 사주명리" 타이틀
/// - "운세 보기" 버튼 → 온보딩으로 이동
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // 0.5초 후 페이드인 시작
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        showCentralStar: true,
        animated: true,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 중앙 별 영역 (StarryBackground에서 그림)
              const SizedBox(height: 180),

              // 타이틀 영역
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // 한자 타이틀
                    const Text(
                      '四柱命理',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: AppColors.nightTextPrimary,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 한글 타이틀
                    const Text(
                      '사주명리',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppColors.nightTextSecondary,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 설명
                    Text(
                      '음양오행의 원리로 당신의 운명을 밝힙니다',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.nightTextMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 연도 링크
                    Text(
                      '${DateTime.now().year}년 운세 확인하기',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.starOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 운세 보기 버튼
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: _GoldButton(
                    text: '운세 보기',
                    onPressed: () => context.go('/onboarding'),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 오행 아이콘
              FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FiveElementIcon(
                      '木',
                      AppColors.starGold.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 16),
                    _FiveElementIcon(
                      '火',
                      AppColors.starGold.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 16),
                    _FiveElementIcon(
                      '土',
                      AppColors.starGold.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 16),
                    _FiveElementIcon(
                      '金',
                      AppColors.starGold.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 16),
                    _FiveElementIcon(
                      '水',
                      AppColors.starGold.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// 골드 그라디언트 버튼
class _GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _GoldButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.goldButtonGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.starGold.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.nightSkyDark,
          ),
        ),
      ),
    );
  }
}

/// 오행 아이콘
class _FiveElementIcon extends StatelessWidget {
  final String text;
  final Color color;

  const _FiveElementIcon(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
    );
  }
}
