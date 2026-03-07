import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/meeting_user.dart';
import '../models/meeting_match_models.dart';
import '../repository/meeting_repository.dart';
import '../services/meeting_service.dart';
import '../theme/meeting_theme.dart';
import '../widgets/meeting_profile_card.dart';
import '../widgets/compatibility_badge.dart';

class MeetingHomeScreen extends StatefulWidget {
  final String myUserId;
  final String myNickname;
  final Future<void> Function(Map<String, dynamic> payload)? onHistoryRecord;
  final VoidCallback? onOpenMeetingHistory;

  const MeetingHomeScreen({
    super.key,
    this.myUserId = 'me',
    this.myNickname = '나',
    this.onHistoryRecord,
    this.onOpenMeetingHistory,
  });

  @override
  State<MeetingHomeScreen> createState() => _MeetingHomeScreenState();
}

class _MeetingHomeScreenState extends State<MeetingHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MeetingService _service;
  List<MeetingUser> _recommendations = [];
  List<MeetingMatch> _matches = [];
  bool _isLoading = true;
  int _currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = Provider.of<MeetingRepository>(context);
    _service = MeetingService(repo, onHistoryRecord: widget.onHistoryRecord);
    if (widget.onHistoryRecord != null) {
      MeetingService.globalOnHistoryRecord = widget.onHistoryRecord;
    }
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  MeetingRepository get _repo =>
      Provider.of<MeetingRepository>(context, listen: false);

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _service.initializeMockUsers();

    final recs = await _repo.getRecommendations(widget.myUserId);
    recs.sort((a, b) {
      final scoreA = _service.calculateScore(widget.myUserId, a.id);
      final scoreB = _service.calculateScore(widget.myUserId, b.id);
      return scoreB.compareTo(scoreA);
    });

    final matches = await _service.getMatches(widget.myUserId);

    if (mounted) {
      setState(() {
        _recommendations = recs;
        _matches = matches;
        _isLoading = false;
        _currentCardIndex = 0;
      });
    }
  }

  Future<void> _handleLike(MeetingUser target) async {
    final isMatch = await _service.likeUser(widget.myUserId, target.id);
    if (!mounted) return;

    if (isMatch) {
      final score = _service.calculateScore(widget.myUserId, target.id);
      await _showMatchCelebration(target, score);
    } else {
      _showLikeSnackbar(target.nickname);
    }
    _advanceCard();
  }

  Future<void> _handlePass(MeetingUser target) async {
    await _service.passUser(widget.myUserId, target.id);
    _advanceCard();
  }

  void _advanceCard() {
    setState(() {
      if (_currentCardIndex < _recommendations.length - 1) {
        _currentCardIndex++;
      } else {
        _loadData();
      }
    });
  }

  void _showLikeSnackbar(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name님에게 좋아요를 보냈습니다 💜'),
        backgroundColor: MeetingTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _showMatchCelebration(MeetingUser target, int score) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _MatchCelebrationDialog(
        targetName: target.nickname,
        score: score,
        onChat: () {
          Navigator.pop(context);
          _goToChat(target.id, target.nickname);
        },
        onLater: () => Navigator.pop(context),
      ),
    );
  }

  void _goToChat(String targetId, String targetName) async {
    final match = await _repo.findMatchBetween(widget.myUserId, targetId);
    if (match != null && mounted) {
      context.push('/meeting/chat', extra: {
        'matchId': match.id,
        'myUserId': widget.myUserId,
        'otherUserId': targetId,
        'otherUserName': targetName,
      }).then((_) => _loadData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeetingTheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(),
        ],
        body: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(color: MeetingTheme.primary))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildRecommendationsTab(),
                  _buildChatsTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: MeetingTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: MeetingTheme.headerGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '오늘의 인연',
                    style: MeetingTheme.headingLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '사주 궁합으로 찾는 나만의 인연 💜',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          tooltip: 'Meeting 기록',
          onPressed: widget.onOpenMeetingHistory,
        ),
        if (kDebugMode)
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.white),
            tooltip: '데모 초기화',
            onPressed: _showResetDialog,
          ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        tabs: const [
          Tab(text: '추천'),
          Tab(text: '대화'),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    if (_recommendations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.favorite_border_rounded,
        title: '추천할 인연이 없어요',
        subtitle: '새로운 인연이 나타나면 알려드릴게요!',
      );
    }

    if (_currentCardIndex >= _recommendations.length) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: '오늘의 추천을 모두 확인했어요',
        subtitle: '내일 새로운 인연을 만나보세요! 💜',
      );
    }

    final user = _recommendations[_currentCardIndex];
    final score = _service.calculateScore(widget.myUserId, user.id);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Card counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text(
                  '${_currentCardIndex + 1} / ${_recommendations.length}',
                  style: MeetingTheme.caption.copyWith(
                    color: MeetingTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                CompatibilityChip(score: score),
              ],
            ),
          ),
          // Profile Card
          MeetingProfileCard(
            user: user,
            compatibilityScore: score,
            onLike: () => _handleLike(user),
            onPass: () => _handlePass(user),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildChatsTab() {
    if (_matches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: '아직 매칭된 인연이 없어요',
        subtitle: '마음에 드는 상대에게 좋아요를 보내보세요!',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _matches.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final match = _matches[index];
        final otherId =
            match.userA == widget.myUserId ? match.userB : match.userA;

        return FutureBuilder<MeetingUser?>(
          future: _service.getUser(otherId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final user = snapshot.data!;

            return FutureBuilder<int>(
              future: _service.getUnreadCount(match.id, widget.myUserId),
              builder: (context, unreadSnap) {
                final unread = unreadSnap.data ?? 0;

                return FutureBuilder<MeetingMessage?>(
                  future: _service.getLastMessage(match.id),
                  builder: (context, lastMsgSnap) {
                    final lastMsg = lastMsgSnap.data;

                    return _buildChatTile(
                      user: user,
                      unread: unread,
                      lastMessage: lastMsg?.text,
                      lastTime: lastMsg?.createdAt,
                      score: match.compatibilityScore ??
                          _service.calculateScore(widget.myUserId, otherId),
                      onTap: () => _goToChat(otherId, user.nickname),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildChatTile({
    required MeetingUser user,
    required int unread,
    String? lastMessage,
    String? lastTime,
    required int score,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: MeetingTheme.cardGradient,
                  ),
                  child: Center(
                    child: Text(
                      user.nickname.isNotEmpty ? user.nickname[0] : '?',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: MeetingTheme.match,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Name & last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.nickname,
                        style: MeetingTheme.bodyLarge.copyWith(
                          fontWeight:
                              unread > 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CompatibilityChip(score: score),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage ?? '대화를 시작해보세요',
                    style: MeetingTheme.bodyMedium.copyWith(
                      fontWeight:
                          unread > 0 ? FontWeight.w600 : FontWeight.w400,
                      color: unread > 0
                          ? MeetingTheme.textPrimary
                          : MeetingTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Time
            if (lastTime != null)
              Text(
                _formatTimeShort(lastTime),
                style: MeetingTheme.caption,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MeetingTheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(icon, size: 40, color: MeetingTheme.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: MeetingTheme.headingMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: MeetingTheme.bodyMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String _formatTimeShort(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) return '방금';
      if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
      if (diff.inHours < 24) return '${diff.inHours}시간 전';
      return '${diff.inDays}일 전';
    } catch (_) {
      return '';
    }
  }

  void _showResetDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('데모 시뮬레이션'),
        content: const Text('모든 데이터를 초기화하시겠습니까?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
                backgroundColor: MeetingTheme.primary),
            child: const Text('초기화'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _service.resetAndSeedAll(myUserId: widget.myUserId);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('데모 환경이 재설정되었습니다 ✨'),
            backgroundColor: MeetingTheme.primary,
          ),
        );
      }
    }
  }
}

// ─────────────────── Match Celebration Dialog ───────────────────

class _MatchCelebrationDialog extends StatelessWidget {
  final String targetName;
  final int score;
  final VoidCallback onChat;
  final VoidCallback onLater;

  const _MatchCelebrationDialog({
    required this.targetName,
    required this.score,
    required this.onChat,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: MeetingTheme.matchCelebrationGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: MeetingTheme.primary.withValues(alpha: 0.3),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉',
              style: TextStyle(fontSize: 56),
            ),
            const SizedBox(height: 16),
            const Text(
              '매칭 성공!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$targetName님과 서로 좋아요!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 20),
            // Score badge
            CompatibilityBadge(score: score, size: 72),
            const SizedBox(height: 12),
            Text(
              '사주 궁합 $score점',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 28),
            // Primary CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: MeetingTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  '채팅 시작하기 💬',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onLater,
              child: Text(
                '나중에 하기',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
