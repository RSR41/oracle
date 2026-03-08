import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/widgets/starry_background.dart';
import 'package:oracle_flutter/app/services/fortune_daily_service.dart';
import 'package:oracle_flutter/app/config/feature_flags.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FortuneDailyService _dailyService = FortuneDailyService();
  DailyFortuneData? _fortuneData;
  bool _notificationVisible = false;
  bool _notificationDismissed = false;

  @override
  void initState() {
    super.initState();
    _loadFortune();
    // Delay notification appearance for a natural "push notification" feel
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _notificationVisible = true);
    });
  }

  Future<void> _loadFortune() async {
    final data = await _dailyService.getFortune(DateTime.now());
    if (!mounted) return;
    setState(() => _fortuneData = data);
  }

  String _scoreToStatus(int score, AppState appState) {
    if (score >= 70) return appState.t('home.status.good');
    if (score >= 40) return appState.t('home.status.normal');
    return appState.t('home.status.caution');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    final userName = appState.profile?.nickname ?? appState.t('home.guest');

    final now = DateTime.now();
    final dateStr = '${now.year}년 ${now.month}월 ${now.day}일';

    final data = _fortuneData;
    final overallScore = data?.overall ?? 0;
    final adviceText = data?.message ?? '운세를 불러오는 중...';
    final luckyColor = data?.luckyColor ?? '-';
    final luckyNumber = data?.luckyNumber.toString() ?? '-';

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
                    left: 20, right: 20, top: 20, bottom: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateStr,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.nightTextSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/profile'),
                        child: Container(
                          width: 42, height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.nightSkyCard,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.nightBorder),
                          ),
                          child: const Icon(Icons.person_outline,
                              color: AppColors.nightTextMuted),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Meeting Notification Banner ──
                if (FeatureFlags.canUseMeeting &&
                    appState.shouldShowMeetingNotification &&
                    _notificationVisible &&
                    !_notificationDismissed)
                  _buildMeetingNotificationBanner(appState, userName),

                // ── Meeting Unlocked Entry (subtle) ──
                if (FeatureFlags.canUseMeeting && appState.meetingUnlocked)
                  _buildMeetingUnlockedEntry(),

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
                        Text(
                          '오늘의 $userName님 운세',
                          style: const TextStyle(
                            color: AppColors.nightSkyDark,
                            fontWeight: FontWeight.w600, fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('$overallScore',
                                style: const TextStyle(
                                  fontSize: 56, fontWeight: FontWeight.bold,
                                  color: AppColors.nightSkyDark, height: 1.0,
                                )),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(appState.t('home.todayScore'),
                                  style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600,
                                    color: AppColors.nightSkyDark
                                        .withValues(alpha: 0.8),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _buildScoreItem(appState.t('home.love'),
                                _scoreToStatus(data?.love ?? 0, appState)),
                            const SizedBox(width: 12),
                            _buildScoreItem(appState.t('home.wealth'),
                                _scoreToStatus(data?.money ?? 0, appState)),
                            const SizedBox(width: 12),
                            _buildScoreItem(appState.t('home.health'),
                                _scoreToStatus(data?.health ?? 0, appState)),
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
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              '${appState.t('home.viewDetail')} →',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 오늘의 조언
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('오늘의 조언',
                          style: TextStyle(
                            color: AppColors.nightTextPrimary,
                            fontSize: 18, fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.nightSkyCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.nightBorder, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.format_quote,
                                color: AppColors.nightTextMuted, size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(adviceText,
                                  style: const TextStyle(
                                    color: AppColors.nightTextPrimary,
                                    fontSize: 15, height: 1.5,
                                  )),
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
                      const Text('바로가기',
                          style: TextStyle(
                            color: AppColors.nightTextPrimary,
                            fontSize: 18, fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildQuickAccessBtn(context,
                                  imagePath:
                                      'assets/images/icons/icon_manse.png',
                                  label: appState.t('home.calendar'),
                                  route: '/calendar')),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildQuickAccessBtn(context,
                                  imagePath:
                                      'assets/images/icons/icon_tarot.png',
                                  label: appState.t('home.tarot'),
                                  route: '/tarot')),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildQuickAccessBtn(context,
                                  imagePath:
                                      'assets/images/icons/icon_face.png',
                                  label: appState.t('home.face'),
                                  route: '/face')),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildQuickAccessBtn(context,
                                  imagePath:
                                      'assets/images/icons/icon_dream.png',
                                  label: appState.t('home.dream'),
                                  route: '/dream')),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 행운의 아이템
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('행운의 아이템',
                          style: TextStyle(
                            color: AppColors.nightTextPrimary,
                            fontSize: 18, fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: _buildLuckyItem(
                                  appState.t('fortune.luckyColor'),
                                  luckyColor,
                                  Icons.palette,
                                  AppColors.starGold)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildLuckyItem(
                                  appState.t('fortune.luckyNumber'),
                                  luckyNumber,
                                  Icons.looks_one,
                                  AppColors.starOrange)),
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
                      Text(appState.t('home.mainService'),
                          style: const TextStyle(
                            color: AppColors.nightTextPrimary,
                            fontSize: 18, fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 12),
                      _buildServiceCard(context,
                          title: appState.t('fortune.analysis'),
                          desc: appState.t('home.analysisDesc'),
                          icon: Icons.trending_up,
                          color: AppColors.nightSkySurface,
                          onTap: () => context.go('/profile')),
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

  // ── Meeting Notification Banner ──
  Widget _buildMeetingNotificationBanner(AppState appState, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          appState.markMeetingNotificationShown();
          setState(() => _notificationDismissed = true);
          context.push('/meeting-gateway');
        },
        child: AnimatedOpacity(
          opacity: _notificationVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7C4DFF).withValues(alpha: 0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C4DFF).withValues(alpha: 0.15),
                  blurRadius: 16, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C4DFF).withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$userName님의 사주와 맞는 인연이 도착했습니다.',
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: Colors.white, height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('탭하여 확인하기',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFB388FF)
                                .withValues(alpha: 0.8),
                          )),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    appState.markMeetingNotificationShown();
                    setState(() => _notificationDismissed = true);
                  },
                  child: Icon(Icons.close_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Subtle entry when meeting is already unlocked ──
  Widget _buildMeetingUnlockedEntry() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () => context.push('/meeting'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF7C4DFF).withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    const Color(0xFF7C4DFF).withValues(alpha: 0.3),
                    const Color(0xFFB388FF).withValues(alpha: 0.2),
                  ]),
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: Color(0xFFB388FF), size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('인연을 믿으십니까?',
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,
                      color: Color(0xFFB388FF), letterSpacing: 0.5,
                    )),
              ),
              Text('소개팅',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.3),
                  )),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.3)),
            ],
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
              color: AppColors.nightSkyDark.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.nightSkyDark.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold,
                  color: AppColors.nightSkyDark,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessBtn(BuildContext context,
      {required String imagePath,
      required String label,
      required String route}) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Container(
            width: double.infinity, height: 72,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.nightSkyCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.nightBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8, offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(imagePath, width: 48, height: 48),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500,
                color: AppColors.nightTextSecondary,
              )),
        ],
      ),
    );
  }

  Widget _buildLuckyItem(
      String title, String value, IconData icon, Color color) {
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.nightTextMuted)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold,
                    color: AppColors.nightTextPrimary,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context,
      {required String title,
      required String desc,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
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
              blurRadius: 8, offset: const Offset(0, 4),
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
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,
                        color: AppColors.nightTextPrimary,
                      )),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: const TextStyle(
                        fontSize: 13, color: AppColors.nightTextMuted,
                      )),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.nightTextMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
