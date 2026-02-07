import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/meeting_user.dart';
import '../models/meeting_match_models.dart';
import '../repository/meeting_repository.dart';
import '../services/meeting_service.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = Provider.of<MeetingRepository>(context);

    _service = MeetingService(
      repo,
      onHistoryRecord: widget.onHistoryRecord,
    );

    // Set global callback for ChatScreen or other instances if needed
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

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _service.initializeMockUsers();

    // Load Recs
    final recs = await _repo.getRecommendations(widget.myUserId);
    // Sort by score
    recs.sort((a, b) {
      final scoreA = _service.calculateScore(widget.myUserId, a.id);
      final scoreB = _service.calculateScore(widget.myUserId, b.id);
      return scoreB.compareTo(scoreA); // Descending
    });

    // Load Matches
    final matches = await _service.getMatches(widget.myUserId);

    if (mounted) {
      setState(() {
        _recommendations = recs;
        _matches = matches;
        _isLoading = false;
      });
    }
  }

  // Helper to get repo from provider comfortably in async methods if needed,
  // but we used _service which has repo. _repo getter below for consistency.
  MeetingRepository get _repo =>
      Provider.of<MeetingRepository>(context, listen: false);

  Future<void> _handleLike(MeetingUser target) async {
    final isMatch = await _service.likeUser(widget.myUserId, target.id);

    if (!mounted) return;

    if (isMatch) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 매칭 성공!'),
          content: Text('${target.nickname}님과 매칭되었습니다.\n채팅방으로 이동할까요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('나중에'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _goToChat(target.id, target.nickname);
              },
              child: const Text('채팅하기'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${target.nickname}님에게 좋아요를 보냈습니다!')),
      );
    }

    _loadData(); // Refresh list
  }

  void _goToChat(String targetId, String targetName) async {
    // Find match ID first
    final match = await _repo.findMatchBetween(widget.myUserId, targetId);
    if (match != null && mounted) {
      context.push('/meeting/chat', extra: {
        'matchId': match.id,
        'myUserId': widget.myUserId,
        'otherUserId': targetId,
        'otherUserName': targetName,
      }).then((_) => _loadData()); // Refresh on return
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 인연'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Meeting 기록',
            onPressed: widget.onOpenMeetingHistory,
          ),
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.restart_alt),
              tooltip: '데모 데이터 초기화 (Debug Only)',
              onPressed: () async {
                // 1차 확인
                final confirm1 = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('데모 시뮬레이션'),
                    content: const Text('현재 모든 데이터를 초기화하고 시연용 데이터를 생성하시겠습니까?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('취소')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('시작')),
                    ],
                  ),
                );
                if (confirm1 != true) return;

                // 2차 확인 (데이터 유실 경고)
                if (!mounted) return;
                final confirm2 = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('⚠️ 데이터 초기화 경고'),
                    content:
                        const Text('기존 모든 대화 내역과 매칭 정보가 영구 삭제됩니다. 정말 진행할까요?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('유지')),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style:
                            FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('삭제 후 생성'),
                      ),
                    ],
                  ),
                );

                if (confirm2 == true) {
                  await _service.resetAndSeedAll(myUserId: widget.myUserId);
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('데모 환경이 재설정되었습니다.')),
                    );
                  }
                }
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '추천'),
            Tab(text: '대화'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRecommendationsList(),
                _buildMatchesList(),
              ],
            ),
    );
  }

  Widget _buildRecommendationsList() {
    if (_recommendations.isEmpty) {
      return const Center(child: Text('더 이상 추천할 사용자가 없습니다.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _recommendations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = _recommendations[index];
        final score = _service.calculateScore(widget.myUserId, user.id);

        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.indigoAccent.withValues(alpha: 0.1),
                  child: Text(user.nickname[0],
                      style:
                          const TextStyle(fontSize: 20, color: Colors.indigo)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${user.nickname} • ${user.gender == 'F' ? '여성' : '남성'}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('궁합 점수: $score점',
                          style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_border,
                      color: Colors.pink, size: 30),
                  onPressed: () => _handleLike(user),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatchesList() {
    if (_matches.isEmpty) {
      return const Center(child: Text('아직 매칭된 인연이 없습니다.'));
    }
    return ListView.builder(
      itemCount: _matches.length,
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
              builder: (context, unreadSnapshot) {
                final unread = unreadSnapshot.data ?? 0;

                return ListTile(
                  leading: CircleAvatar(child: Text(user.nickname[0])),
                  title: Text(user.nickname,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('대화를 시작해보세요'),
                  trailing: unread > 0
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: Text('$unread',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        )
                      : null,
                  onTap: () => _goToChat(otherId, user.nickname),
                );
              },
            );
          },
        );
      },
    );
  }
}
