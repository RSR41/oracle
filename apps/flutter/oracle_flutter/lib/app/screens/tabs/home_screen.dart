import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/config/feature_flags.dart';
import 'package:oracle_flutter/app/widgets/starry_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    // 사용자 이름 (프로필 있으면 닉네임, 없으면 기본값)
    final userName = appState.profile?.nickname ?? appState.t('home.guest');

    // 오늘 날짜
    final now = DateTime.now();
    final dateStr = '${now.year}년 ${now.month}월 ${now.day}일';

    // 랜덤 조언 (데모용)
    final advices = [
      '새로운 시작을 하기에 좋은 날입니다.',
      '주변 사람들에게 친절을 베푸세요.',
      '오늘은 잠시 휴식을 취하는 것이 좋습니다.',
      '뜻밖의 행운이 찾아올 수 있습니다.',
      '자신의 직관을 믿고 나아가세요.',
    ];
    final randomAdvice = advices[now.day % advices.length];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StarryBackground(
        animated: true,
        showCentralStar: false, // 홈 화면에서는 중앙 별 끄기
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$userName님',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.nightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dateStr,
                                style: TextStyle(
                                  color: AppColors.nightTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          // 설정 버튼
                          IconButton(
                            onPressed: () => context.push('/settings'),
                            icon: const Icon(
                              Icons.settings,
                              color: AppColors.nightTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Today's Fortune Summary Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldButtonGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.starGold.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appState.t('home.todayFortune'),
                              style: const TextStyle(
                                color: AppColors.nightSkyDark,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: AppColors.nightSkyDark,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '85',
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: AppColors.nightSkyDark,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                appState.t('home.todayScore'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.nightSkyDark.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Score Grid
                        Row(
                          children: [
                            _buildScoreItem(
                              appState.t('home.love'),
                              appState.t('home.status.good'),
                            ),
                            const SizedBox(width: 12),
                            _buildScoreItem(
                              appState.t('home.wealth'),
                              appState.t('home.status.normal'),
                            ),
                            const SizedBox(width: 12),
                            _buildScoreItem(
                              appState.t('home.health'),
                              appState.t('home.status.caution'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push('/fortune-today'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.nightSkyDark,
                              foregroundColor: AppColors.starGold,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              '${appState.t('home.viewDetail')} →',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 오늘의 조언 (Daily Advice)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 조언',
                        style: TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.nightSkyCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.nightBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: AppColors.nightTextMuted,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                randomAdvice,
                                style: const TextStyle(
                                  color: AppColors.nightTextPrimary,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Quick Access Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '바로가기',
                        style: TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildQuickAccessBtn(
                            context,
                            icon: Icons.calendar_month,
                            label: appState.t('home.calendar'),
                            color: AppColors.sage,
                            route: '/calendar',
                          ),
                          _buildQuickAccessBtn(
                            context,
                            icon: Icons.shuffle,
                            label: appState.t('home.tarot'),
                            color: AppColors.skyPastel,
                            route: '/tarot',
                          ),
                          if (FeatureFlags.featureDream)
                            _buildQuickAccessBtn(
                              context,
                              icon: Icons.bedtime,
                              label: appState.t('home.dream'),
                              color: AppColors.caramel,
                              route: '/dream',
                            ),
                          if (FeatureFlags.featureCompatibility)
                            _buildQuickAccessBtn(
                              context,
                              icon: Icons.favorite,
                              label: appState.t('home.compatibility'),
                              color: AppColors.peach,
                              route: '/compatibility',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 행운의 아이템 (Lucky Items)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '행운의 아이템',
                        style: TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLuckyItem(
                              '행운의 색',
                              '골드',
                              Icons.palette,
                              AppColors.starGold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildLuckyItem(
                              '행운의 숫자',
                              '7',
                              Icons.looks_one,
                              AppColors.starOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 사주 분석 섹션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.t('home.mainService'),
                        style: const TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildServiceCard(
                        context,
                        title: appState.t('fortune.analysis'),
                        desc: appState.t('home.analysisDesc'),
                        icon: Icons.trending_up,
                        color: AppColors.nightSkySurface,
                        onTap: () => context.go('/profile'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.nightSkyDark.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.nightSkyDark.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.nightSkyDark.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.nightSkyDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessBtn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.nightSkyCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.nightBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.nightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nightSkyCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.nightBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.nightTextMuted,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.nightTextPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.nightBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.nightSkyDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.starGold, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.nightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.nightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.nightTextMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
