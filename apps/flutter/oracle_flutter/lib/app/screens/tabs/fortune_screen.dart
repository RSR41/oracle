import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/widgets/oracle_card.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
// FeatureFlags는 타로/꿈해몽이 MVP가 되어 더 이상 필요하지 않음

class FortuneScreen extends StatefulWidget {
  const FortuneScreen({super.key});

  @override
  State<FortuneScreen> createState() => _FortuneScreenState();
}

class _FortuneScreenState extends State<FortuneScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categoryKeys = [
    'common.all',
    'fortune.today',
    'fortune.calendar',
    // MVP: 타로/꿈해몽은 항상 노출
    'fortune.tarot',
    'fortune.dream',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    final categories = _categoryKeys.map((key) => appState.t(key)).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 60,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appState.t('nav.fortune'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '오늘의 운세부터 사주분석까지',
                    style: theme.textTheme.bodySmall,
                  ), // key missing in trans? keep for now or use generic
                ],
              ),
            ),

            // Category Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(categories.length, (index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.primaryForeground
                                : AppColors.secondaryForeground,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Today's Fortune
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: GestureDetector(
                onTap: () => context.push('/fortune-today'),
                child: Container(
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2026년 1월 30일',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '오늘의 운세', // t('fortune.today')
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Quote
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '오늘의 한마디',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '새로운 시작을 위한 준비가 필요한 날입니다. 작은 변화가 큰 결과를 가져올 수 있습니다.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Grid
                      Row(
                        children: [
                          _buildFortuneItem('애정운', '85', AppColors.peach),
                          const SizedBox(width: 8),
                          _buildFortuneItem('재물운', '72', AppColors.caramel),
                          const SizedBox(width: 8),
                          _buildFortuneItem('건강운', '68', AppColors.sage),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Calendar / Manseryeok
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OracleCard(
                    title: appState.t('fortune.calendar'),
                    description: '일/월/년 운세를 한눈에 확인하세요',
                    icon: const Icon(Icons.calendar_month, color: Colors.white),
                    accentColor: AppColors.sage,
                    onTap: () => context.push('/calendar'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이번 주 운세', style: theme.textTheme.bodySmall),
                            const SizedBox(height: 8),
                            Row(
                              children: ['월', '화', '수', '목', '금']
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final idx = entry.key;
                                    final day = entry.value;
                                    return Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            day,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 6,
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: idx == 2
                                                  ? AppColors.primary
                                                  : AppColors.primary
                                                        .withValues(alpha: 0.3),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Saju Analysis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OracleCard(
                    title: appState.t('fortune.analysis'),
                    description: '오행, 십성, 대운 등 자세한 분석',
                    icon: const Icon(Icons.trending_up, color: Colors.white),
                    accentColor: AppColors.primary,
                    onTap: () => context.push('/saju-analysis'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          _buildSajuInfo(theme, '오행', '목(木)'),
                          const SizedBox(width: 8),
                          _buildSajuInfo(theme, '십성', '편관'),
                          const SizedBox(width: 8),
                          _buildSajuInfo(theme, '대운', '길운'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // MVP: 타로 섹션 (항상 노출)
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '타로',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OracleCard(
                    title: appState.t('fortune.tarot'),
                    description: '오늘의 운세를 타로로 확인하세요',
                    icon: const Icon(Icons.shuffle, color: Colors.white),
                    accentColor: AppColors.skyPastel,
                    onTap: () => context.push('/tarot'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [1, 2, 3].map((cardNumber) {
                          return Expanded(
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: cardNumber == 3 ? 0 : 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.2),
                                      AppColors.primary.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.shuffle,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // MVP: 꿈해몽 섹션 (항상 노출)
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '꿈해몽',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OracleCard(
                    title: appState.t('fortune.dream'),
                    description: '꿈의 의미를 해석해드립니다',
                    icon: const Icon(Icons.bedtime, color: Colors.white),
                    accentColor: AppColors.caramel,
                    onTap: () => context.push('/dream'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
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
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
