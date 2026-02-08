import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/widgets/oracle_card.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/config/feature_flags.dart';
import 'package:oracle_flutter/app/widgets/starry_background.dart';

class FortuneScreen extends StatelessWidget {
  const FortuneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    // 오늘 날짜
    final now = DateTime.now();
    final dateStr = '${now.year}년 ${now.month}월 ${now.day}일';

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: StarryBackground(
        animated: true,
        showCentralStar: false,
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
                      Text(
                        appState.t('nav.fortune'),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.nightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appState.t('fortune.subtitle'),
                        style: const TextStyle(
                          color: AppColors.nightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Today's Fortune
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => context.push('/fortune-today'),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                      color: AppColors.nightSkyDark.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    appState.t('fortune.today'),
                                    style: const TextStyle(
                                      color: AppColors.nightSkyDark,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.nightSkyDark,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Quote
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      color: AppColors.nightSkyDark.withValues(
                                        alpha: 0.6,
                                      ),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      appState.t('fortune.todayMessage'),
                                      style: TextStyle(
                                        color: AppColors.nightSkyDark
                                            .withValues(alpha: 0.8),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  appState.t('fortune.sampleMessage'),
                                  style: const TextStyle(
                                    color: AppColors.nightSkyDark,
                                    fontSize: 15,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Grid
                          Row(
                            children: [
                              _buildFortuneItem(
                                appState.t('fortune.love'),
                                '85',
                              ),
                              const SizedBox(width: 12),
                              _buildFortuneItem(
                                appState.t('fortune.wealth'),
                                '72',
                              ),
                              const SizedBox(width: 12),
                              _buildFortuneItem(
                                appState.t('fortune.health'),
                                '68',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Calendar / Manseryeok
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.t('fortune.calendar'),
                        style: const TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OracleCard(
                        title: appState.t('fortune.calendar'),
                        description: appState.t('fortune.calendarDesc'),
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                        accentColor: AppColors.sage,
                        onTap: () => context.push('/calendar'),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.nightSkyDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.nightBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.t('fortune.weekFortune'),
                                  style: const TextStyle(
                                    color: AppColors.nightTextSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children:
                                      [
                                        appState.t('common.mon'),
                                        appState.t('common.tue'),
                                        appState.t('common.wed'),
                                        appState.t('common.thu'),
                                        appState.t('common.fri'),
                                      ].asMap().entries.map((entry) {
                                        final idx = entry.key;
                                        final day = entry.value;
                                        final isToday = idx == now.weekday - 1;
                                        return Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                day,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isToday
                                                      ? AppColors.starGold
                                                      : AppColors
                                                            .nightTextMuted,
                                                  fontWeight: isToday
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                height: 4,
                                                width: double.infinity,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isToday
                                                      ? AppColors.starGold
                                                      : AppColors.nightBorder,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Saju Analysis - Profile 탭으로 이동
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.t('fortune.analysis'),
                        style: const TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OracleCard(
                        title: appState.t('fortune.analysis'),
                        description: appState.t('fortune.analysisDesc'),
                        icon: const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                        ),
                        accentColor: AppColors.primary,
                        onTap: () =>
                            context.go('/profile'), // Profile 탭으로 이동하여 사주 결과 표시
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              _buildSajuInfo(
                                theme,
                                appState.t('fortune.fiveElements'),
                                '목(木)',
                              ),
                              const SizedBox(width: 8),
                              _buildSajuInfo(
                                theme,
                                appState.t('fortune.tenGods'),
                                '편관',
                              ),
                              const SizedBox(width: 8),
                              _buildSajuInfo(
                                theme,
                                appState.t('fortune.majorCycle'),
                                '길운',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 타로 섹션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.t('fortune.tarot'),
                        style: const TextStyle(
                          color: AppColors.nightTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OracleCard(
                        title: appState.t('fortune.tarot'),
                        description: appState.t('fortune.tarotDesc'),
                        icon: const Icon(Icons.shuffle, color: Colors.white),
                        accentColor: AppColors.skyPastel,
                        onTap: () => context.push('/tarot'),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: SizedBox(
                            height: 100, // 높이 제한
                            child: Row(
                              children: [1, 2, 3].map((cardNumber) {
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: cardNumber == 3 ? 0 : 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.nightSkyDark,
                                      border: Border.all(
                                        color: AppColors.starGold.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.shuffle,
                                        color: AppColors.starGold.withValues(
                                          alpha: 0.5,
                                        ),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Phase 2+: 꿈해몽 섹션
                if (FeatureFlags.showBetaFeatures) ...[
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.t('fortune.dream'),
                          style: const TextStyle(
                            color: AppColors.nightTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OracleCard(
                          title: appState.t('fortune.dream'),
                          description: appState.t('fortune.dreamDesc'),
                          icon: const Icon(Icons.bedtime, color: Colors.white),
                          accentColor: AppColors.caramel,
                          onTap: () => context.push('/dream'),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.nightSkyDark.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.nightSkyDark.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.nightSkyDark.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.nightSkyDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSajuInfo(ThemeData theme, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.nightSkyDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.nightBorder),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.nightTextMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.starGold,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
