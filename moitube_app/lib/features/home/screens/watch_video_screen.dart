import 'package:flutter/material.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/video_service.dart';
import 'package:moitube_app/features/home/widgets/watch/video_player_widget.dart';
import 'package:moitube_app/features/home/widgets/watch/related_video_list.dart';

class WatchVideoScreen extends StatefulWidget {
  final String videoId;

  const WatchVideoScreen({super.key, required this.videoId});

  @override
  State<WatchVideoScreen> createState() => _WatchVideoScreenState();
}

class _WatchVideoScreenState extends State<WatchVideoScreen> {
  final VideoService _videoService = VideoService();
  late String _currentVideoId;

  Video? _video;
  List<Video> _relatedVideos = [];
  bool _isLoading = true;
  bool _descriptionExpanded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentVideoId = widget.videoId;
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _descriptionExpanded = false;
    });

    try {
      final video = await _videoService.getVideoById(_currentVideoId);
      final related = await _videoService.getRelatedVideos(_currentVideoId);
      _videoService.incrementView(_currentVideoId);

      if (mounted) {
        setState(() {
          _video = video;
          _relatedVideos = related;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onRelatedVideoTap(Video video) {
    setState(() {
      _currentVideoId = video.id;
      _video = null;
      _relatedVideos = [];
    });
    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xffe24594)),
      );
    }

    if (_error != null || _video == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            const Text('Không thể tải video', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadVideo,
              child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
            ),
          ],
        ),
      );
    }

    final video = _video!;

    return Column(
      children: [
        // Top bar
        _buildTopBar(),

        // Video player
        VideoPlayerWidget(
          key: ValueKey(_currentVideoId),
          videoUrl: video.videoUrl ?? '',
        ),

        // Scrollable content below player
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + views
                _buildTitleSection(video),

                // Action buttons
                _buildActionButtons(video),

                const Divider(color: Colors.white10, height: 1),

                // Channel row
                _buildChannelRow(video),

                const Divider(color: Colors.white10, height: 1),

                // Description
                _buildDescriptionSection(video),

                const Divider(color: Colors.white10, height: 1),

                // Comment section header (placeholder for Feature 3)
                _buildCommentSectionHeader(),

                const Divider(color: Colors.white10, height: 1),

                // Related videos
                RelatedVideoList(
                  videos: _relatedVideos,
                  onVideoTap: _onRelatedVideoTap,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Top Bar ───
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ─── Title + Views ───
  Widget _buildTitleSection(Video video) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${video.viewsFormatted} lượt xem • ${video.timeAgo}',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ─── Action Buttons (chip style) ───
  Widget _buildActionButtons(Video video) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(
        children: [
          // Like
          _buildActionChip(
            icon: Icons.thumb_up_outlined,
            label: video.likeCount > 0 ? _formatCount(video.likeCount) : 'Thích',
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Dislike
          _buildActionChip(
            icon: Icons.thumb_down_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Share
          _buildActionChip(
            icon: Icons.share_outlined,
            label: 'Chia sẻ',
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Download
          _buildActionChip(
            icon: Icons.download_outlined,
            label: 'Tải xuống',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    String? label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff272727),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            if (label != null) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Channel Row ───
  Widget _buildChannelRow(Video video) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xffe24594),
            backgroundImage: video.channelAvatarUrl != null
                ? NetworkImage(video.channelAvatarUrl!)
                : null,
            child: video.channelAvatarUrl == null
                ? Text(
                    video.channelName.isNotEmpty ? video.channelName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // Channel name + subscriber count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.channelName,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${video.viewsFormatted} người đăng ký',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),

          // Subscribe button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffe24594),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Đăng ký',
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Description Section (collapsible) ───
  Widget _buildDescriptionSection(Video video) {
    final desc = video.description ?? '';

    return InkWell(
      onTap: () => setState(() => _descriptionExpanded = !_descriptionExpanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Mô tả',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(
                  _descriptionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white54,
                  size: 22,
                ),
              ],
            ),

            if (_descriptionExpanded && desc.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                desc,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Comment Section Header (placeholder for Feature 3) ───
  Widget _buildCommentSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text(
            'Bình luận',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          const Text(
            '0',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 22),
        ],
      ),
    );
  }

  // ─── Helpers ───
  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
