import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/widgets/oracle_card.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/config/feature_flags.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 60, // Safe Area approx
                bottom: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appState.t('home.title')} 00님',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('2026년 1월 30일', style: theme.textTheme.bodySmall),
                ],
              ),
            ),

            // Today's Fortune Summary
            Transform.translate(
              offset: const Offset(0, -16), // -mt-4
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8B6F47), Color(0xFFC4A574)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 20,
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
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              appState.t('home.todayScore'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Score Grid
                      Row(
                        children: [
                          _buildScoreItem(
                            appState.t('home.love'),
                            appState.t('home.status.good'),
                          ),
                          const SizedBox(width: 8),
                          _buildScoreItem(
                            appState.t('home.wealth'),
                            appState.t('home.status.normal'),
                          ),
                          const SizedBox(width: 8),
                          _buildScoreItem(
                            appState.t('home.health'),
                            appState.t('home.status.caution'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.push('/fortune-today'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            '${appState.t('home.viewDetail')} →',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Access Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAccessBtn(
                    context,
                    icon: Icons.calendar_month,
                    label: appState.t('home.calendar'),
                    color: AppColors.sage,
                    route: '/calendar',
                  ),
                  // MVP: 타로/꿈해몽은 항상 노출
                  _buildQuickAccessBtn(
                    context,
                    icon: Icons.shuffle,
                    label: appState.t('home.tarot'),
                    color: AppColors.skyPastel,
                    route: '/tarot',
                  ),
                  _buildQuickAccessBtn(
                    context,
                    icon: Icons.bedtime,
                    label: appState.t('home.dream'),
                    color: AppColors.caramel,
                    route: '/dream',
                  ),
                  // 베타: 궁합만 조건부 노출
                  if (FeatureFlags.showBetaFeatures) ...[
                    _buildQuickAccessBtn(
                      context,
                      icon: Icons.favorite,
                      label: appState.t('home.compatibility'),
                      color: AppColors.peach,
                      route: '/compatibility',
                    ),
                  ],
                ],
              ),
            ),

            if (FeatureFlags.showBetaFeatures)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: OracleCard(
                  title: appState.t('home.todayConnection'),
                  description: appState.t('home.connectionDesc'),
                  icon: const Icon(Icons.people, color: Colors.white),
                  badge: 'Beta',
                  accentColor: AppColors.sage,
                  onTap: () => context.push('/connection'),
                ),
              ),

            if (FeatureFlags.showBetaFeatures)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상담',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OracleCard(
                      title: appState.t('home.consultation'),
                      description: appState.t('home.consultationDesc'),
                      icon: const Icon(Icons.chat_bubble, color: Colors.white),
                      accentColor: AppColors.primary,
                      onTap: () => context.push('/consultation'),
                    ),
                  ],
                ),
              ),

            // MVP: 관상 얼굴분석은 항상 노출 (이상형 생성만 베타)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '추천 서비스',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OracleCard(
                    title: appState.t('home.face'),
                    description: 'AI로 내 관상을 분석해보세요',
                    icon: const Icon(Icons.face, color: Colors.white),
                    accentColor: AppColors.peach,
                    onTap: () => context.push('/face'),
                  ),
                  const SizedBox(height: 12),
                  OracleCard(
                    title: '2026년 신년운세',
                    description: '새해의 운세를 미리 확인하세요',
                    icon: const Icon(Icons.trending_up, color: Colors.white),
                    badge: 'NEW',
                    accentColor: AppColors.skyPastel,
                    onTap: () => context.push('/yearly-fortune'),
                  ),
                ],
              ),
            ),

            // Disclaimer
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 40),
              child: Center(
                child: Text(
                  appState.t('common.entertainment'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
      child: Container(
        width: 80, // Approx
        decoration: BoxDecoration(
          color:
              Theme.of(context).cardTheme.color ??
              Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
