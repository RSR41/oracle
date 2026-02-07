import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  // Mock fortune data for dates
  final Map<int, int> _dailyFortune = {};

  @override
  void initState() {
    super.initState();
    _generateMockFortune();
  }

  void _generateMockFortune() {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    for (int i = 1; i <= daysInMonth; i++) {
      _dailyFortune[i] = 50 + (i * 7 + now.month * 3) % 50;
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
      _generateMockFortune();
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      _generateMockFortune();
    });
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
}
