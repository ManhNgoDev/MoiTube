import 'package:flutter/material.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/history_service.dart';
import 'package:moitube_app/features/home/screens/watch_video_screen.dart';
import 'package:moitube_app/features/home/widgets/feed/video_card.dart';

class WatchHistoryScreen extends StatefulWidget {
  const WatchHistoryScreen({super.key});

  @override
  State<WatchHistoryScreen> createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen> {
  final HistoryService _historyService = HistoryService();
  List<Video> _historyVideos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final videos = await _historyService.getHistory(page: 1, limit: 50);
      setState(() {
        _historyVideos = videos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Dường như bạn chưa đăng nhập hoặc có lỗi kết nối';
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1f1f1f),
        title: const Text('Xóa lịch sử?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Bạn có chắc chắn muốn xóa toàn bộ lịch sử xem video không?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffe24594)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _historyService.clearHistory();
        setState(() {
          _historyVideos.clear();
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa tất cả lịch sử')),
        );
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi xóa lịch sử. Vui lòng đăng nhập lại.')),
        );
      }
    }
  }

  Future<void> _removeItem(String videoId) async {
    try {
      await _historyService.removeHistoryItem(videoId);
      setState(() {
        _historyVideos.removeWhere((v) => v.id == videoId);
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể xóa video này')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      appBar: AppBar(
        backgroundColor: const Color(0xff0f0f0f),
        elevation: 0,
        title: const Text('Lịch sử xem'),
        actions: [
          if (_historyVideos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: _clearHistory,
              tooltip: 'Xóa tất cả',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xffe24594)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_toggle_off, size: 60, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHistory,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff1f1f1f)),
              child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }

    if (_historyVideos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'Danh sách này không có video nào.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _historyVideos.length,
      itemBuilder: (context, index) {
        final video = _historyVideos[index];
        return Dismissible(
          key: Key(video.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red.shade800,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            _removeItem(video.id);
          },
          child: InkWell(
            onTap: () {
              // Khi người dùng bấm vào video thì chuyển sang màn hình watch
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WatchVideoScreen(videoId: video.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chỉnh layout hiển thị giống UI youtube thu nhỏ
                  Container(
                    width: 160,
                    height: 90,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnailUrl ?? 'https://via.placeholder.com/160x90'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(video.duration ?? 0),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          video.channelName ?? 'Kênh vô danh',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${video.viewCount} lượt xem',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white54),
                    onPressed: () {
                      _removeItem(video.id);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
