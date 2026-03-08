import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/meeting_match_models.dart';
import '../repository/meeting_repository.dart';
import '../services/meeting_service.dart';
import '../theme/meeting_theme.dart';

class MeetingChatScreen extends StatefulWidget {
  final String matchId;
  final String myUserId;
  final String otherUserName;
  final String otherUserId;

  const MeetingChatScreen({
    super.key,
    required this.matchId,
    required this.myUserId,
    required this.otherUserName,
    required this.otherUserId,
  });

  @override
  State<MeetingChatScreen> createState() => _MeetingChatScreenState();
}

class _MeetingChatScreenState extends State<MeetingChatScreen> {
  late MeetingService _service;
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MeetingMessage> _messages = [];
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = Provider.of<MeetingRepository>(context);
    _service = MeetingService(repo);
    _initChat();
  }

  @override
  void dispose() {
    if (MeetingService.activeForegroundMatchId == widget.matchId) {
      MeetingService.activeForegroundMatchId = null;
    }
    _pollingTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {
    MeetingService.activeForegroundMatchId = widget.matchId;
    await _loadMessages(initial: true);
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loadMessages();
    });
  }

  Future<void> _loadMessages({bool initial = false}) async {
    final msgs = await _service.getMessages(widget.matchId);
    if (!mounted) return;

    if (initial || msgs.length != _messages.length) {
      setState(() {
        _messages = msgs;
        _isLoading = false;
      });

      if (initial) {
        _scrollToBottom(immediate: true);
      } else {
        _scrollToBottom();
      }
      _markAsRead();
    }
  }

  Future<void> _markAsRead() async {
    await _service.markAsRead(widget.matchId, widget.myUserId);
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    final tempMsg = MeetingMessage(
      id: const Uuid().v4(),
      matchId: widget.matchId,
      senderId: widget.myUserId,
      text: text,
      createdAt: DateTime.now().toIso8601String(),
    );

    setState(() {
      _messages.add(tempMsg);
    });
    _scrollToBottom();

    try {
      await _service.sendMessage(
        matchId: widget.matchId,
        myUserId: widget.myUserId,
        content: text,
        otherUserId: widget.otherUserId,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지 전송 실패: $e')),
      );
      _loadMessages();
    }
  }

  void _scrollToBottom({bool immediate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (immediate) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _showReportSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('신고/차단', style: MeetingTheme.headingMedium),
              const SizedBox(height: 16),
              _buildReportOption(
                icon: Icons.flag_outlined,
                label: '스팸/광고',
                reason: 'spam',
              ),
              _buildReportOption(
                icon: Icons.warning_amber_rounded,
                label: '욕설/비하',
                reason: 'abuse',
              ),
              _buildReportOption(
                icon: Icons.no_adult_content,
                label: '부적절한 콘텐츠',
                reason: 'sexual_content',
              ),
              _buildReportOption(
                icon: Icons.person_off_outlined,
                label: '사기/사칭',
                reason: 'scam',
              ),
              const Divider(height: 24),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('이 사용자 차단',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(context);
                  await _service.blockUser(
                      widget.myUserId, widget.otherUserId);
                  if (mounted) {
                    Navigator.pop(context); // Exit chat
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('사용자가 차단되었습니다.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportOption({
    required IconData icon,
    required String label,
    required String reason,
  }) {
    return ListTile(
      leading: Icon(icon, color: MeetingTheme.textSecondary),
      title: Text(label),
      onTap: () async {
        Navigator.pop(context); // Close sheet
        await _service.reportUser(
          matchId: widget.matchId,
          reporterId: widget.myUserId,
          reason: reason,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('신고가 접수되었습니다. 검토 후 조치하겠습니다.'),
              backgroundColor: MeetingTheme.primary,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeetingTheme.background,
      appBar: AppBar(
        title: Text(widget.otherUserName,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: MeetingTheme.textPrimary)),
        centerTitle: true,
        backgroundColor: MeetingTheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: MeetingTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                color: MeetingTheme.textSecondary),
            onPressed: _showReportSheet,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: MeetingTheme.primary))
                : _messages.isEmpty
                    ? _buildEmptyView()
                    : _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MeetingTheme.primary.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.chat_bubble_outline,
                size: 32, color: MeetingTheme.primary),
          ),
          const SizedBox(height: 16),
          const Text('반갑게 인사를 건네보세요! 💜',
              style: TextStyle(color: MeetingTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isMe = msg.senderId == widget.myUserId;
        return _buildChatBubble(msg, isMe);
      },
    );
  }

  Widget _buildChatBubble(MeetingMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? MeetingTheme.primary : MeetingTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : MeetingTheme.textPrimary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMe && msg.readAt == null)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text('1',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold)),
                  ),
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.6)
                        : MeetingTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
      final period = dt.hour >= 12 ? '오후' : '오전';
      final min = dt.minute.toString().padLeft(2, '0');
      return '$period $hour:$min';
    } catch (_) {
      return '';
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: MeetingTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: MeetingTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: '메시지를 입력하세요...',
                    hintStyle: TextStyle(fontSize: 14, color: MeetingTheme.textSecondary),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: MeetingTheme.headerGradient,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
