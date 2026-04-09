import 'package:flutter/material.dart';
import 'package:moitube_app/models/comment.dart';
import 'package:moitube_app/services/comment_service.dart';

class CommentSection extends StatefulWidget {
  final String videoId;

  const CommentSection({super.key, required this.videoId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final CommentService _commentService = CommentService();
  final TextEditingController _controller = TextEditingController();

  bool _loading = true;
  bool _posting = false;
  bool _expanded = false;
  String? _currentUserId;
  List<CommentModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant CommentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _controller.clear();
      _expanded = false;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await _commentService.getCommentsByVideoId(widget.videoId);
      final me = await _commentService.getCurrentUserIdIfLoggedIn();
      if (!mounted) return;
      setState(() {
        _comments = results;
        _currentUserId = me;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _posting = true);
    try {
      final created = await _commentService.postComment(videoId: widget.videoId, content: text);
      if (!mounted) return;
      setState(() {
        _comments = [created, ..._comments];
        _posting = false;
        _controller.clear();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _posting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để bình luận')),
      );
    }
  }

  Future<void> _delete(CommentModel c) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || c.userId != currentUserId) return;

    final idx = _comments.indexWhere((x) => x.id == c.id);
    if (idx < 0) return;
    final old = _comments;
    setState(() => _comments = List<CommentModel>.from(_comments)..removeAt(idx));
    try {
      await _commentService.deleteComment(c.id);
    } catch (_) {
      if (!mounted) return;
      setState(() => _comments = old);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa bình luận')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preview = _comments.isNotEmpty ? _comments.first : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Bình luận',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Text(
                  _loading ? '...' : '${_comments.length}',
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const Spacer(),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white54,
                  size: 22,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (!_expanded) ...[
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: LinearProgressIndicator(color: Color(0xffe24594), backgroundColor: Color(0xff1b1b1b)),
              )
            else if (preview == null)
              const Text('Chưa có bình luận nào.', style: TextStyle(color: Colors.white54, fontSize: 13))
            else
              _buildPreviewTile(preview),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildComposer()),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh, color: Colors.white54, size: 18),
                  tooltip: 'Tải lại',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator(color: Color(0xffe24594)))
            else if (_comments.isEmpty)
              const Text('Chưa có bình luận nào.', style: TextStyle(color: Colors.white54, fontSize: 13))
            else
              ..._comments.map(_buildCommentTile),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewTile(CommentModel c) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: const Color(0xff272727),
          backgroundImage: c.avatarUrl != null ? NetworkImage(c.avatarUrl!) : null,
          child: c.avatarUrl == null
              ? Text(
                  c.username.isNotEmpty ? c.username[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.username,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                c.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Viết bình luận...',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xff1b1b1b),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 44,
          width: 44,
          child: ElevatedButton(
            onPressed: _posting ? null : _post,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffe24594),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _posting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile(CommentModel c) {
    final isMine = _currentUserId != null && c.userId == _currentUserId;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xff272727),
            backgroundImage: c.avatarUrl != null ? NetworkImage(c.avatarUrl!) : null,
            child: c.avatarUrl == null
                ? Text(
                    c.username.isNotEmpty ? c.username[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.username,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (isMine)
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () => _delete(c),
                        icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 18),
                        tooltip: 'Xóa',
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  c.content,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

