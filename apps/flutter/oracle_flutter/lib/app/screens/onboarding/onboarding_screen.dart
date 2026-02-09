import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../state/app_state.dart';
import '../../models/saju_profile.dart';
import '../../widgets/starry_background.dart';
import '../../theme/app_colors.dart';

/// 생년월일 입력 화면 (밤하늘 테마)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nickname = '';
  String _gender = 'M';

  // 년/월/일 드롭다운용
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;
  String? _selectedTime;

  final List<int> _years = List.generate(100, (i) => DateTime.now().year - i);
  final List<int> _months = List.generate(12, (i) => i + 1);
  final List<String> _times = [
    '모름',
    '00:00~02:00 (子시)',
    '02:00~04:00 (丑시)',
    '04:00~06:00 (寅시)',
    '06:00~08:00 (卯시)',
    '08:00~10:00 (辰시)',
    '10:00~12:00 (巳시)',
    '12:00~14:00 (午시)',
    '14:00~16:00 (未시)',
    '16:00~18:00 (申시)',
    '18:00~20:00 (酉시)',
    '20:00~22:00 (戌시)',
    '22:00~24:00 (亥시)',
  ];

  List<int> get _days {
    if (_selectedYear == null || _selectedMonth == null) {
      return List.generate(31, (i) => i + 1);
    }
    final daysInMonth = DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
    return List.generate(daysInMonth, (i) => i + 1);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedYear == null ||
        _selectedMonth == null ||
        _selectedDay == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('생년월일을 선택해주세요')));
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);

    // 시간 파싱
    String? birthTime;
    if (_selectedTime != null && _selectedTime != '모름') {
      final match = RegExp(r'(\d{2}):(\d{2})').firstMatch(_selectedTime!);
      if (match != null) {
        birthTime = '${match.group(1)}:${match.group(2)}';
      }
    }

    final birthDate = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);

    await appState.saveProfile(
      SajuProfile(
        nickname: _nickname.isEmpty ? '사용자' : _nickname,
        gender: _gender,
        birthDate: birthDate.toIso8601String().split('T')[0],
        birthTime: birthTime,
      ),
    );

    // 첫 실행 완료 표시
    await appState.completeFirstRun();

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        showCentralStar: false,
        animated: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 뒤로가기
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () =>
                          context.go('/welcome'), // Go back to Welcome screen
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.nightTextPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 생 아이콘
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.starGold, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '生',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.starGold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 제목
                  const Text(
                    '정보 입력',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.nightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '정확한 사주를 위해 성함과 생년월일을 입력해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.nightTextMuted,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 입력 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.nightSkyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.nightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 성함 입력
                        const Text(
                          '성함',
                          style: TextStyle(
                            color: AppColors.nightTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _nickname,
                          style: const TextStyle(
                            color: AppColors.nightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: '성함을 입력해주세요',
                            hintStyle: const TextStyle(
                              color: AppColors.nightTextMuted,
                            ),
                            filled: true,
                            fillColor: AppColors.nightSkySurface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) =>
                              setState(() => _nickname = value),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '성함을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // 년/월/일 행
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '년',
                                    style: TextStyle(
                                      color: AppColors.nightTextSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildDropdown<int>(
                                    value: _selectedYear,
                                    hint: '년',
                                    items: _years,
                                    onChanged: (v) =>
                                        setState(() => _selectedYear = v),
                                    labelBuilder: (v) => '$v',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '월',
                                    style: TextStyle(
                                      color: AppColors.nightTextSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildDropdown<int>(
                                    value: _selectedMonth,
                                    hint: '월',
                                    items: _months,
                                    onChanged: (v) => setState(() {
                                      _selectedMonth = v;
                                      // 일 재검증
                                      if (_selectedDay != null &&
                                          _selectedDay! > _days.length) {
                                        _selectedDay = null;
                                      }
                                    }),
                                    labelBuilder: (v) => '$v',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '일',
                                    style: TextStyle(
                                      color: AppColors.nightTextSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  _buildDropdown<int>(
                                    value: _selectedDay,
                                    hint: '일',
                                    items: _days,
                                    onChanged: (v) =>
                                        setState(() => _selectedDay = v),
                                    labelBuilder: (v) => '$v',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 태어난 시간
                        const Text(
                          '태어난 시간',
                          style: TextStyle(
                            color: AppColors.nightTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildDropdown<String>(
                          value: _selectedTime,
                          hint: '12:00',
                          items: _times,
                          onChanged: (v) => setState(() => _selectedTime = v),
                          labelBuilder: (v) => v,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '시주를 정확하게 보기 위해 필요합니다',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.nightTextMuted,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 성별
                        const Text(
                          '성별',
                          style: TextStyle(
                            color: AppColors.nightTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _GenderButton(
                                label: '남자 (男)',
                                isSelected: _gender == 'M',
                                onTap: () => setState(() => _gender = 'M'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _GenderButton(
                                label: '여자 (女)',
                                isSelected: _gender == 'F',
                                onTap: () => setState(() => _gender = 'F'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // 사주 분석하기 버튼
                        GestureDetector(
                          onTap: _submit,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldButtonGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.starGold.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              '사주 분석하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.nightSkyDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 안내 문구
                  Text(
                    '입력된 정보는 사주 분석에만 사용됩니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.nightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) labelBuilder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.nightSkySurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.nightBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.nightTextMuted),
          ),
          isExpanded: true,
          dropdownColor: AppColors.nightSkyCard,
          style: const TextStyle(color: AppColors.nightTextPrimary),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.nightTextSecondary,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(labelBuilder(item)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.starGold.withValues(alpha: 0.2)
              : AppColors.nightSkySurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.starGold : AppColors.nightBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? AppColors.starGold
                : AppColors.nightTextSecondary,
          ),
        ),
      ),
    );
  }
}
