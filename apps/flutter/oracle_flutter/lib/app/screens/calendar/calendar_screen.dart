import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/services/saju/saju_service.dart';
import 'package:oracle_flutter/app/services/saju/saju_models.dart';
import 'package:oracle_flutter/app/services/fortune_daily_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final SajuService _sajuService = SajuService();
  final FortuneDailyService _dailyService = FortuneDailyService();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  bool _isLoadingMonth = false;

  // Daily fortune + ganji cache
  final Map<int, int> _dailyFortune = {};
  final Map<int, DailyFortuneData> _dailyFortuneData = {};
  final Map<int, Pillar> _dailyGanji = {};

  @override
  void initState() {
    super.initState();
    _loadMonthData();
  }

  Future<void> _loadMonthData() async {
    setState(() => _isLoadingMonth = true);

    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );

    if (_selectedDate.year != _focusedMonth.year ||
        _selectedDate.month != _focusedMonth.month ||
        _selectedDate.day > daysInMonth) {
      final safeDay = _selectedDate.day.clamp(1, daysInMonth).toInt();
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, safeDay);
    }

    _dailyFortune.clear();
    _dailyFortuneData.clear();
    _dailyGanji.clear();

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, i);
      final fortune = await _dailyService.getFortune(date);
      _dailyFortune[i] = fortune.overall;
      _dailyFortuneData[i] = fortune;
      _dailyGanji[i] = _sajuService.getDayGanji(date);
    }

    if (mounted) {
      setState(() => _isLoadingMonth = false);
    }
  }

  Color _getFortuneColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getFortuneLabel(int score, AppState appState) {
    if (score >= 80) return appState.t('home.status.good');
    if (score >= 60) return appState.t('home.status.normal');
    return appState.t('home.status.caution');
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
    _loadMonthData();
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
    _loadMonthData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    final daysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final selectedScore = _dailyFortune[_selectedDate.day] ?? 70;
    final selectedData = _dailyFortuneData[_selectedDate.day];
    final selectedGanji = _dailyGanji[_selectedDate.day];

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('fortune.calendar')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Month Navigation
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    DateFormat('yyyy년 M월').format(_focusedMonth),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weekday Headers
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: ['일', '월', '화', '수', '목', '금', '토'].map((day) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: day == '일'
                              ? Colors.red
                              : day == '토'
                              ? Colors.blue
                              : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Calendar Grid
            if (_isLoadingMonth)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              )
            else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday) {
                  return const SizedBox();
                }

                final day = index - firstWeekday + 1;
                final isSelected =
                    _selectedDate.day == day &&
                    _selectedDate.month == _focusedMonth.month &&
                    _selectedDate.year == _focusedMonth.year;
                final isToday =
                    day == DateTime.now().day &&
                    _focusedMonth.month == DateTime.now().month &&
                    _focusedMonth.year == DateTime.now().year;
                final score = _dailyFortune[day] ?? 70;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month,
                        day,
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isToday
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.primary)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : null,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : _getFortuneColor(score),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Selected Date Fortune
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getFortuneColor(selectedScore).withValues(alpha: 0.1),
                    _getFortuneColor(selectedScore).withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getFortuneColor(selectedScore).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('M월 d일').format(_selectedDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selectedGanji != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '일간지: ${selectedGanji.ganji} (${selectedGanji.ganjiHanja})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$selectedScore',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: _getFortuneColor(selectedScore),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appState.t('fortune.scorePoint'),
                        style: TextStyle(
                          fontSize: 16,
                          color: _getFortuneColor(selectedScore),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getFortuneColor(
                        selectedScore,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getFortuneLabel(selectedScore, appState),
                      style: TextStyle(
                        color: _getFortuneColor(selectedScore),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (selectedData != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      selectedData.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _badge('흐름', selectedData.seasonalFlow),
                        _badge('주의', selectedData.riskFactor),
                        _badge('행동', selectedData.actionPlan),
                        _badge('행운색', selectedData.luckyColor),
                        _badge('행운시각', selectedData.luckyTime),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('관계: ${selectedData.relationshipAdvice}'),
                          const SizedBox(height: 4),
                          Text('업무: ${selectedData.workAdvice}'),
                          const SizedBox(height: 4),
                          Text('재정: ${selectedData.moneyAdvice}'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(Colors.green, appState.t('home.status.good')),
                const SizedBox(width: 16),
                _buildLegend(Colors.blue, appState.t('home.status.normal')),
                const SizedBox(width: 16),
                _buildLegend(Colors.orange, appState.t('home.status.caution')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _badge(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$title: $value',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
