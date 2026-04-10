import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/video_service.dart';
import 'package:moitube_app/features/home/widgets/watch/video_player_widget.dart';
import 'package:moitube_app/features/home/widgets/watch/related_video_list.dart';
import 'package:moitube_app/features/home/widgets/watch/comment_section.dart';
import 'package:moitube_app/features/home/widgets/watch/watch_top_bar.dart';
import 'package:moitube_app/features/home/widgets/watch/video_title_section.dart';
import 'package:moitube_app/features/home/widgets/watch/video_action_row.dart';
import 'package:moitube_app/features/home/widgets/watch/channel_row.dart';
import 'package:moitube_app/features/home/widgets/watch/video_description_section.dart';
import 'package:moitube_app/features/home/screens/channel_detail_screen.dart';
import 'package:moitube_app/services/channel_service.dart';
import 'package:moitube_app/services/history_service.dart';

class WatchVideoScreen extends StatefulWidget {
  final String videoId;

  const WatchVideoScreen({super.key, required this.videoId});

  @override
  State<WatchVideoScreen> createState() => _WatchVideoScreenState();
}

class _WatchVideoScreenState extends State<WatchVideoScreen> {
  final VideoService _videoService = VideoService();
  final ChannelService _channelService = ChannelService();
  final HistoryService _historyService = HistoryService();
  late String _currentVideoId;

  Video? _video;
  List<Video> _relatedVideos = [];
  bool _isLoading = true;
  bool _descriptionExpanded = false;
  String? _error;
  bool _liking = false;
  bool _disliking = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isOwner = false;
  bool _isSubscribed = false;
  bool _subscribing = false;

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
      _isLiked = false;
      _isDisliked = false;
      _isOwner = false;
      _isSubscribed = false;
      _subscribing = false;
    });

    try {
      final video = await _videoService.getVideoById(_currentVideoId);
      final related = await _videoService.getRelatedVideos(_currentVideoId);
      _videoService.incrementView(_currentVideoId);
      
      // Ghi nhận lịch sử xem
      _historyService.addToHistory(_currentVideoId);

      // If logged in, fetch my reaction (also tells if I'm owner)
      try {
        final my = await _videoService.getMyReaction(_currentVideoId);
        final type = my['type'];
        final owner = my['owner'] == true;
        if (mounted) {
          setState(() {
            _isOwner = owner;
            _isLiked = type == 'like';
            _isDisliked = type == 'dislike';
          });
        }
      } catch (_) {
        // ignore: not logged in or API error
      }

      // Fetch subscription status for channel
      final channelId = (video.channelId ?? '').trim();
      if (channelId.isNotEmpty) {
        try {
          final subscribed = await _channelService.getSubscriptionStatus(channelId);
          if (mounted) {
            setState(() => _isSubscribed = subscribed);
          }
        } catch (_) {
          // ignore when user not logged in
        }
      }

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
        WatchTopBar(
          onBack: () => Navigator.pop(context),
          onSettings: () {},
          onMore: () {},
        ),

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
                VideoTitleSection(video: video),

                // Action buttons
                VideoActionRow(
                  likeCount: video.likeCount,
                  liking: _liking,
                  disliking: _disliking,
                  isLiked: _isLiked,
                  isDisliked: _isDisliked,
                  onLike: _onLike,
                  onDislike: _onDislike,
                  onShare: () => _onShare(video),
                  onDownload: () {},
                ),

                const Divider(color: Colors.white10, height: 1),

                // Channel row
                ChannelRow(
                  video: video,
                  onSubscribe: () => _toggleSubscribe(video),
                  onOpenChannel: () => _openChannel(video),
                  isSubscribed: _isSubscribed,
                  subscribing: _subscribing,
                ),

                const Divider(color: Colors.white10, height: 1),

                // Description
                VideoDescriptionSection(
                  description: video.description ?? '',
                  expanded: _descriptionExpanded,
                  onToggle: () => setState(() => _descriptionExpanded = !_descriptionExpanded),
                ),

                const Divider(color: Colors.white10, height: 1),

                // Comments
                CommentSection(videoId: _currentVideoId),

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


  Future<void> _onShare(Video video) async {
    final link = (video.videoUrl ?? '').trim();
    if (link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có link để chia sẻ')),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: link));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã copy link video')),
    );
  }

  Future<void> _toggleSubscribe(Video video) async {
    final channelId = (video.channelId ?? '').trim();
    if (channelId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin kênh')),
      );
      return;
    }
    if (_isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đây là kênh của bạn')),
      );
      return;
    }
    if (_subscribing) return;

    setState(() => _subscribing = true);
    try {
      final subscribed = await _channelService.toggleSubscription(channelId);
      if (!mounted) return;
      setState(() => _isSubscribed = subscribed);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để đăng ký kênh')),
      );
    } finally {
      if (mounted) setState(() => _subscribing = false);
    }
  }

  void _openChannel(Video video) {
    final handle = (video.channelHandle ?? '').trim();
    final channelId = (video.channelId ?? '').trim();
    if (handle.isEmpty && channelId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin kênh')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChannelDetailScreen(
          channelHandle: handle.isNotEmpty ? handle : null,
          channelId: channelId.isNotEmpty ? channelId : null,
        ),
      ),
    );
  }

  Future<void> _onLike() async {
    final v = _video;
    if (v == null) return;
    if (_isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn không thể like video của chính bạn')),
      );
      return;
    }
    if (_liking || _disliking) return;

    try {
      setState(() => _liking = true);
      final res = await _videoService.reactVideo(v.id, VideoReactionType.like);
      final active = res['active'] == true;
      if (!mounted) return;
      setState(() {
        final cur = _video!;
        var likeCount = cur.likeCount;
        var dislikeCount = cur.dislikeCount;

        if (_isLiked && !active) {
          likeCount = (likeCount - 1).clamp(0, 1 << 30);
        } else if (!_isLiked && active) {
          likeCount = likeCount + 1;
          if (_isDisliked) dislikeCount = (dislikeCount - 1).clamp(0, 1 << 30);
        }

        _isLiked = active;
        _isDisliked = false;

        _video = Video(
          id: cur.id,
          channelId: cur.channelId,
          channelHandle: cur.channelHandle,
          title: cur.title,
          description: cur.description,
          thumbnailUrl: cur.thumbnailUrl,
          videoUrl: cur.videoUrl,
          duration: cur.duration,
          status: cur.status,
          viewCount: cur.viewCount,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          publishedAt: cur.publishedAt,
          channelName: cur.channelName,
          channelAvatarUrl: cur.channelAvatarUrl,
        );
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để like')),
      );
    } finally {
      if (mounted) setState(() => _liking = false);
    }
  }

  Future<void> _onDislike() async {
    final v = _video;
    if (v == null) return;
    if (_isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn không thể dislike video của chính bạn')),
      );
      return;
    }
    if (_liking || _disliking) return;

    try {
      setState(() => _disliking = true);
      final res = await _videoService.reactVideo(v.id, VideoReactionType.dislike);
      final active = res['active'] == true;
      if (!mounted) return;
      setState(() {
        final cur = _video!;
        var likeCount = cur.likeCount;
        var dislikeCount = cur.dislikeCount;

        if (_isDisliked && !active) {
          dislikeCount = (dislikeCount - 1).clamp(0, 1 << 30);
        } else if (!_isDisliked && active) {
          dislikeCount = dislikeCount + 1;
          if (_isLiked) likeCount = (likeCount - 1).clamp(0, 1 << 30);
        }

        _isDisliked = active;
        _isLiked = false;

        _video = Video(
          id: cur.id,
          channelId: cur.channelId,
          channelHandle: cur.channelHandle,
          title: cur.title,
          description: cur.description,
          thumbnailUrl: cur.thumbnailUrl,
          videoUrl: cur.videoUrl,
          duration: cur.duration,
          status: cur.status,
          viewCount: cur.viewCount,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          publishedAt: cur.publishedAt,
          channelName: cur.channelName,
          channelAvatarUrl: cur.channelAvatarUrl,
        );
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để dislike')),
      );
    } finally {
      if (mounted) setState(() => _disliking = false);
    }
  }

}
