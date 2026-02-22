import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/config/feature_flags.dart';

class HistoryScreen extends StatefulWidget {
  final String? initialFilter;
  final bool lockFilter;

  const HistoryScreen({super.key, this.initialFilter, this.lockFilter = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryRepository _historyRepo = HistoryRepository();
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 20;
  String _currentFilter = 'ALL'; // ALL, SAJU, TAROT, MEETING

  List<FortuneResult> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  int _offset = 0;

  bool get _isMeetingLocked =>
      widget.lockFilter && widget.initialFilter == 'MEETING';

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _currentFilter = widget.initialFilter!;
    }
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 초기 데이터 로드
  Future<void> _loadInitialData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _items = [];
        _offset = 0;
        _hasMore = true;
      });
    }

    try {
      final query = _buildFilterQuery();
      final data = await _historyRepo.getHistoryPaged(
        where: query.where,
        whereArgs: query.whereArgs,
        limit: _pageSize,
        offset: 0,
      );

      if (!mounted) return;
      setState(() {
        _items = data;
        _offset = data.length;
        _hasMore = data.length >= _pageSize;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
      debugPrint('Error loading initial history: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 스크롤 이벤트: 바닥 도달 시 추가 로드
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  /// 추가 데이터 로드
  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore || _hasError) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final query = _buildFilterQuery();
      final data = await _historyRepo.getHistoryPaged(
        where: query.where,
        whereArgs: query.whereArgs,
        limit: _pageSize,
        offset: _offset,
      );

      if (!mounted) return;
      setState(() {
        _items.addAll(data);
        _offset += data.length;
        _hasMore = data.length >= _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      debugPrint('Error loading more history: $e');
    }
  }

  /// 전체 삭제
  Future<void> _handleClearAll() async {
    await _historyRepo.clearAll();
    _loadInitialData();
  }

  ({String? where, List<Object?>? whereArgs}) _buildFilterQuery() {
    switch (_currentFilter) {
      case 'SAJU':
        return (
          where: 'type = ? OR type = ? OR type LIKE ?',
          whereArgs: ['saju', 'fortune', '%saju%'],
        );
      case 'TAROT':
        return (where: 'type = ?', whereArgs: ['tarot']);
      case 'MEETING':
        return (where: 'type LIKE ?', whereArgs: ['meeting_%']);
      case 'ALL':
      default:
        return (where: null, whereArgs: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lockFilter && _currentFilter == 'MEETING'
              ? 'Meeting 기록'
              : appState.t('nav.history'),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('전체 삭제'),
                  content: const Text('모든 기록을 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );
              if (confirm == true) _handleClearAll();
            },
          ),
        ],
      ),
      body: _buildBody(context, appState, theme),
    );
  }

  Widget _buildBody(BuildContext context, AppState appState, ThemeData theme) {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildFilterBar(theme),
        Expanded(
          child: _isMeetingLocked
              ? _buildMeetingSectionList(context, appState, theme, _items)
              : _buildListArea(context, appState, theme, _items),
        ),
      ],
    );
  }

  Widget _buildMeetingSectionList(
    BuildContext context,
    AppState appState,
    ThemeData theme,
    List<FortuneResult> items,
  ) {
    final seeds = items.where((i) => i.type == 'meeting_seed').toList();
    final matches = items.where((i) => i.type == 'meeting_match').toList();
    final messages = items.where((i) => i.type == 'meeting_message').toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _buildMeetingSection('Seed', seeds, theme),
        const SizedBox(height: 12),
        _buildMeetingSection('Match', matches, theme),
        const SizedBox(height: 12),
        _buildMeetingSection('Message', messages, theme),
      ],
    );
  }

  Widget _buildMeetingSection(
    String title,
    List<FortuneResult> items,
    ThemeData theme,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          '$title (${items.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: items.isEmpty
            ? Text('기록 없음', style: TextStyle(color: theme.disabledColor))
            : null,
        children: items.map((i) => _buildHistoryCard(context, i)).toList(),
      ),
    );
  }

  Widget _buildFilterBar(ThemeData theme) {
    if (widget.lockFilter) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _filterChip('전체', 'ALL'),
          const SizedBox(width: 8),
          _filterChip('사주', 'SAJU'),
          const SizedBox(width: 8),
          _filterChip('타로', 'TAROT'),
          // Phase 2+: Meeting filter
          if (FeatureFlags.showBetaFeatures) ...[
            const SizedBox(width: 8),
            _filterChip('Meeting', 'MEETING'),
          ],
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _currentFilter == value;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (!selected || _currentFilter == value) return;
        setState(() {
          _currentFilter = value;
          _items = [];
          _offset = 0;
          _hasMore = true;
          _hasError = false;
        });
        _loadInitialData();
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.white,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildListArea(
    BuildContext context,
    AppState appState,
    ThemeData theme,
    List<FortuneResult> displayItems,
  ) {
    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: displayItems.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index < displayItems.length) {
            return _buildHistoryCard(context, displayItems[index]);
          }

          if (_hasError && _items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  const Text('데이터를 불러오지 못했습니다.'),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _loadInitialData, child: const Text('다시 시도')),
                ],
              ),
            );
          }

          if (displayItems.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 60, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text(appState.t('history.empty'), style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          if (_hasError) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Text('추가 데이터를 불러오지 못했습니다.'),
                  TextButton(onPressed: _loadMore, child: const Text('다시 시도')),
                ],
              ),
            );
          }

          if (_hasMore) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                '모든 기록을 불러왔습니다.',
                style: TextStyle(color: theme.disabledColor, fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, FortuneResult item) {
    final isMeeting = item.type.startsWith('meeting_');
    return GestureDetector(
      onTap: () {
        if (_isMeetingLocked) {
          context.push('/meeting/history/detail/${item.id}', extra: item);
        } else if (item.type.startsWith('meeting_')) {
          _showMeetingHistoryDetail(context, item);
        } else if (item.type == 'tarot') {
          context.push('/tarot-history-detail', extra: item);
        } else if (item.type == 'fortune' || item.type.contains('saju')) {
          context.push('/fortune-detail', extra: item);
        } else {
          context.push('/fortune-detail', extra: item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isMeeting)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Meeting',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Flexible(
                        child: Text(
                          item.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(item.date, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.overallScore}점',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMeetingHistoryDetail(
    BuildContext context,
    FortuneResult item,
  ) async {
    // HistoryRepository에서 실제 페이로드 로드
    final payload = await _historyRepo.getPayload(item.id);
    final String jsonText = payload != null
        ? const JsonEncoder.withIndent('  ').convert(payload)
        : item.content; // fallback

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '상세 정보',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow('ID', item.id),
                      _detailRow('Type', item.type),
                      _detailRow('Created', item.createdAt),
                      _detailRow('Summary', item.summary),
                      const SizedBox(height: 16),
                      const Text(
                        'Payload (JSON)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SelectableText(
                          jsonText.isEmpty ? '(내용 없음)' : jsonText,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('복사'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: jsonText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('JSON이 클립보드에 복사되었습니다.')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('닫기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
