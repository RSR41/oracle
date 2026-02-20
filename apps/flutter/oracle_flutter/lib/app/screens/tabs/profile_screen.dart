import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/models/saju_profile.dart';
import 'package:oracle_flutter/app/services/saju/saju_service.dart';
import 'package:oracle_flutter/app/services/saju/saju_models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _sajuService = SajuService();

  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  String _gender = 'M';
  bool _isEditing = false;
  bool _isTimeUnknown = false;
  SajuResult? _sajuResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingProfile();
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _loadExistingProfile() {
    final appState = context.read<AppState>();
    if (appState.hasSajuProfile) {
      final profile = appState.profile!;
      _nicknameController.text = profile.nickname;
      _gender = profile.gender;
      _birthDate = DateTime.tryParse(profile.birthDate);
      _birthDate = DateTime.tryParse(profile.birthDate);
      if (profile.birthTime != null && profile.birthTime!.isNotEmpty) {
        final parts = profile.birthTime!.split(':');
        if (parts.length >= 2) {
          _birthTime = TimeOfDay(
            hour: int.tryParse(parts[0]) ?? 0,
            minute: int.tryParse(parts[1]) ?? 0,
          );
          _isTimeUnknown = false;
        }
      } else {
        _birthTime = null;
        _isTimeUnknown = true;
      }
      _calculateSaju();
      setState(() {});
    }
  }

  void _calculateSaju() {
    if (_birthDate != null) {
      final timeStr = _birthTime != null
          ? '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}'
          : null;
      _sajuResult = _sajuService.calculate(
        birthDate: _birthDate!,
        birthTime: timeStr,
        gender: _gender,
      );
    }
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _calculateSaju();
      });
    }
  }

  Future<void> _selectBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _birthTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _birthTime = picked;
        _calculateSaju();
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 필수 정보를 입력해주세요')));
      return;
    }

    final profile = SajuProfile(
      nickname: _nicknameController.text.trim(),
      gender: _gender,
      birthDate: DateFormat('yyyy-MM-dd').format(_birthDate!),
      birthTime: (_isTimeUnknown || _birthTime == null)
          ? null
          : '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}',
    );

    await context.read<AppState>().saveProfile(profile);
    setState(() => _isEditing = false);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필이 저장되었습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final hasProfile = appState.hasSajuProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('nav.profile')),
        centerTitle: true,
        actions: [
          if (hasProfile && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: hasProfile && !_isEditing
            ? _buildProfileDisplay(theme, appState)
            : _buildProfileForm(theme, appState),
      ),
    );
  }

  Widget _buildProfileDisplay(ThemeData theme, AppState appState) {
    final profile = appState.profile!;

    return Column(
      children: [
        // Profile Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.caramel.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: Text(
                  profile.nickname.isNotEmpty
                      ? profile.nickname[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.nickname,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${profile.birthDate} ${profile.birthTime ?? ''}'.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    profile.gender == 'M' ? Icons.male : Icons.female,
                    color: profile.gender == 'M' ? Colors.blue : Colors.pink,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    profile.gender == 'M' ? '남성' : '여성',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Saju Result
        if (_sajuResult != null) ...[_buildSajuResultCard(theme, appState)],
      ],
    );
  }

  Widget _buildSajuResultCard(ThemeData theme, AppState appState) {
    final result = _sajuResult!;

    return Column(
      children: [
        // 사주 팔자 (Four Pillars)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: [
              Text(
                '사주 팔자',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPillarColumn('년주', result.yearPillar, theme),
                  _buildPillarColumn('월주', result.monthPillar, theme),
                  _buildPillarColumn('일주', result.dayPillar, theme),
                  if (result.hourPillar != null)
                    _buildPillarColumn('시주', result.hourPillar!, theme),
                ],
              ),
              const SizedBox(height: 16),
              // Zodiac Animal Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(color: AppColors.primary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/zodiac/${SajuService.getZodiacEnglish(result.zodiac)}.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.pets,
                              size: 60,
                              color: AppColors.primary,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${result.zodiac} (${result.zodiacHanja})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.nightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 오행 분포
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오행 분포',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...result.elements.entries.map((e) {
                // Map Korean element name to English filename
                final elementEng = SajuService.getElementEnglish(e.key);
                final percentage = (e.value / 4 * 100).toStringAsFixed(0);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/five_elements/${elementEng}.png',
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to Icon if image missing (e.g. earth.png)
                            return Container(
                              decoration: BoxDecoration(
                                color: _getElementColor(e.key),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  e.key,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${e.key} (${SajuService.elementHanja[e.key]})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '$percentage%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.nightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: e.value / 4,
                                backgroundColor: Colors.grey.withValues(
                                  alpha: 0.2,
                                ),
                                valueColor: AlwaysStoppedAnimation(
                                  _getElementColor(e.key),
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 종합 점수
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getScoreColor(result.overallScore).withValues(alpha: 0.1),
                _getScoreColor(result.overallScore).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getScoreColor(result.overallScore).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                '종합 운세 점수',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${result.overallScore}',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(result.overallScore),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: result.luckyColors.map((colorHex) {
                  final color = Color(
                    int.parse(colorHex.replaceFirst('#', '0xFF')),
                  );
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text(
                '행운의 숫자: ${result.luckyNumbers.join(", ")}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 상세 해석
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '상세 해석',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                result.interpretation,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPillarColumn(String label, Pillar pillar, ThemeData theme) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                pillar.stemHanja,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pillar.branchHanja,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(pillar.ganji, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildProfileForm(ThemeData theme, AppState appState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _isEditing ? '프로필 수정' : '프로필 입력',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '사주 분석을 위해 정보를 입력해주세요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 24),

          // Name (formerly Nickname)
          TextFormField(
            controller: _nicknameController,
            style: const TextStyle(color: AppColors.nightTextPrimary),
            decoration: InputDecoration(
              labelText: '성함',
              labelStyle: const TextStyle(color: AppColors.nightTextSecondary),
              hintText: '성함을 입력해주세요',
              hintStyle: const TextStyle(color: AppColors.nightTextMuted),
              prefixIcon: const Icon(
                Icons.person,
                color: AppColors.nightTextSecondary,
              ),
              filled: true,
              fillColor: AppColors.nightSkyCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '성함을 입력해주세요';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Gender
          Text(
            '성별',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.nightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton(
                  'M',
                  '남성',
                  Icons.male,
                  Colors.blue,
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderButton(
                  'F',
                  '여성',
                  Icons.female,
                  Colors.pink,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Birth Date
          Text(
            '생년월일',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.nightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectBirthDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.nightSkyCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.nightBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.nightTextSecondary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _birthDate != null
                        ? DateFormat('yyyy년 MM월 dd일').format(_birthDate!)
                        : '생년월일을 선택해주세요',
                    style: TextStyle(
                      color: _birthDate != null
                          ? AppColors.nightTextPrimary
                          : AppColors.nightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Birth Time (Optional)
          Text(
            '출생 시간',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.nightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _isTimeUnknown
                      ? null
                      : _selectBirthTime, // Disable tap if unknown
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isTimeUnknown
                          ? AppColors.nightSkyCard.withValues(alpha: 0.5)
                          : AppColors.nightSkyCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.nightBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: _isTimeUnknown
                              ? AppColors.nightTextMuted
                              : AppColors.nightTextSecondary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isTimeUnknown
                              ? '출생 시간 모름'
                              : (_birthTime != null
                                    ? '${_birthTime!.hour.toString().padLeft(2, '0')}:${_birthTime!.minute.toString().padLeft(2, '0')}'
                                    : '출생 시간을 선택해주세요'),
                          style: TextStyle(
                            color: _isTimeUnknown
                                ? AppColors.nightTextMuted
                                : (_birthTime != null
                                      ? AppColors.nightTextPrimary
                                      : AppColors.nightTextMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Time Unknown Toggle Button
              InkWell(
                onTap: () {
                  setState(() {
                    _isTimeUnknown = !_isTimeUnknown;
                    if (_isTimeUnknown) {
                      _birthTime = null; // Reset time if unknown
                    }
                    _calculateSaju();
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: _isTimeUnknown
                        ? AppColors.starGold.withValues(alpha: 0.2)
                        : AppColors.nightSkyCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isTimeUnknown
                          ? AppColors.starGold
                          : AppColors.nightBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '시간 모름',
                      style: TextStyle(
                        color: _isTimeUnknown
                            ? AppColors.starGold
                            : AppColors.nightTextSecondary,
                        fontWeight: _isTimeUnknown
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Preview (if date selected)
          if (_sajuResult != null) ...[
            Text(
              '사주 미리보기',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.nightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.nightSkySurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.nightBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMiniPillar('년', _sajuResult!.yearPillar),
                  _buildMiniPillar('월', _sajuResult!.monthPillar),
                  _buildMiniPillar('일', _sajuResult!.dayPillar),
                  if (_sajuResult!.hourPillar != null)
                    _buildMiniPillar('시', _sajuResult!.hourPillar!),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Save Button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saveProfile,
              style:
                  FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.starGold,
                    foregroundColor:
                        AppColors.nightSkyDark, // Dark text on gold button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.black.withValues(
                          alpha: 0.2,
                        ); // Darken on press
                      }
                      return null;
                    }),
                  ),
              child: Text(
                _isEditing ? '수정 완료' : '저장하기',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel Button (if editing)
          if (_isEditing)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _loadExistingProfile();
                  setState(() => _isEditing = false);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.nightBorder),
                  foregroundColor: AppColors.nightTextSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('취소'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(
    String value,
    String label,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    final isSelected = _gender == value;
    return InkWell(
      onTap: () => setState(() => _gender = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppColors.nightSkyCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.nightBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.nightTextSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : AppColors.nightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPillar(String label, Pillar pillar) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          pillar.ganjiHanja,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getElementColor(String element) {
    switch (element) {
      case '목':
        return Colors.green;
      case '화':
        return Colors.red;
      case '토':
        return Colors.brown;
      case '금':
        return Colors.amber;
      case '수':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}
