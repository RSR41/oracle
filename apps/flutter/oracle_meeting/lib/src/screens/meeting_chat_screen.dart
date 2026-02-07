import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meeting_match_models.dart';
import '../repository/meeting_repository.dart';
import '../services/meeting_service.dart';

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
    _pollingTimer?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initChat() async {
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
    // C-3-1에서 변경된 limit/offset API 사용 (기본값 사용)
    final msgs = await _service.getMessages(widget.matchId);

    if (!mounted) return;

    // 변경사항이 있을 때만 UI 업데이트 (개수가 같더라도 내용(시간)이 다를 수 있지만 MVP에선 개수로 충분)
    // 실제 운영 환경에선 마지막 메시지 ID 등으로 체크 권장
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

      // 읽음 처리
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

    // Optimistic Update (UI에 즉시 반영)
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempMsg = MeetingMessage(
      id: tempId,
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
      // Polling에 의해 최종 상태로 업데이트됨
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('메시지 전송 실패: $e')),
      );
      _loadMessages(); // 상태 롤백/새로고침
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

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('신고하기'),
        content: const Text('부적절한 사용자입니까? 신고 시 상대방과의 대화가 차단될 수 있습니다.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () async {
              // TODO: 실제 신고 API 호출 (Repository 연동)
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('신고가 접수되었습니다.')),
              );
            },
            child: const Text('신고', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'report') _showReportDialog();
              if (v == 'exit') Navigator.pop(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'report',
                  child: Text('신고/차단', style: TextStyle(color: Colors.red))),
              const PopupMenuItem(value: 'exit', child: Text('대화 종료')),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
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
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('반갑게 인사를 건네보세요!', style: TextStyle(color: Colors.grey)),
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

        // 날짜 구분선 표시 여부 (생략 가능, MVP에선 없이 진행)

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
          color: isMe ? Colors.indigoAccent : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMe && msg.readAt == null)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Text('1',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.bold)),
                  ),
                Text(
                  _formatTime(msg.createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.black45,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _textController,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  hintStyle: const TextStyle(fontSize: 14),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.indigoAccent),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
