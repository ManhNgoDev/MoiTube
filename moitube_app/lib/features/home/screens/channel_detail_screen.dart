import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/models/channel_model.dart';
import 'package:moitube_app/features/home/screens/watch_video_screen.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/channel_service.dart';
import 'package:moitube_app/services/storage_service.dart';
import 'package:moitube_app/services/video_service.dart';

class ChannelDetailScreen extends StatefulWidget {
  final String? channelHandle;
  final String? channelId;

  const ChannelDetailScreen({
    super.key,
    this.channelHandle,
    this.channelId,
  }) : assert(channelHandle != null || channelId != null);

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  final ChannelService _channelService = ChannelService();
  final VideoService _videoService = VideoService();

  bool _loading = true;
  bool _submitting = false;
  bool _isSubscribed = false;
  bool _loggedIn = false;
  String? _error;
  ChannelModel? _channel;
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final loggedIn = await StorageService.isLoggedIn();
      final ch = widget.channelHandle != null && widget.channelHandle!.trim().isNotEmpty
          ? await _channelService.getChannelByHandle(widget.channelHandle!.trim())
          : await _channelService.getChannelById(widget.channelId!.trim());
      final vids = await _videoService.getVideosByChannelHandle(ch.handle, page: 1, limit: 30);
      bool subscribed = false;
      if (loggedIn) {
        try {
          subscribed = await _channelService.getSubscriptionStatus(ch.id);
        } catch (_) {}
      }
      if (!mounted) return;
      setState(() {
        _loggedIn = loggedIn;
        _channel = ch;
        _videos = vids;
        _isSubscribed = subscribed;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _toggleSubscribe() async {
    final ch = _channel;
    if (ch == null) return;
    if (!_loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đăng nhập để đăng ký kênh')),
      );
      return;
    }
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final next = await _channelService.toggleSubscription(ch.id);
      if (!mounted) return;
      setState(() => _isSubscribed = next);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể cập nhật đăng ký')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xffe24594)))
            : _error != null || _channel == null
                ? _buildError()
                : _buildContent(_channel!),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          const Text('Không thể tải kênh', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _load,
            child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ChannelModel channel) {
    return DefaultTabController(
      length: 3,
      child: RefreshIndicator(
        onRefresh: _load,
        color: const Color(0xffe24594),
        child: NestedScrollView(
          headerSliverBuilder: (context, inner) => [
            SliverToBoxAdapter(child: _buildHeader(channel)),
            const SliverPersistentHeader(
              pinned: true,
              delegate: _ChannelTabBarDelegate(
                TabBar(
                  indicatorColor: Color(0xffe24594),
                  labelColor: Color(0xffe24594),
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: 'Videos'),
                    Tab(text: 'Playlists'),
                    Tab(text: 'Giới thiệu'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _buildVideoGrid(),
              const Center(
                child: Text('Chưa có playlist', style: TextStyle(color: Colors.white54)),
              ),
              _buildAbout(channel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ChannelModel channel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 6,
              child: Image.network(
                channel.bannerUrl ?? 'https://via.placeholder.com/1200x400.png?text=MoiTube+Channel',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xff1c1c1c)),
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xff2a2a2a),
                backgroundImage: channel.avatarUrl != null ? NetworkImage(channel.avatarUrl!) : null,
                child: channel.avatarUrl == null
                    ? Text(
                        channel.name.isNotEmpty ? channel.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.name,
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '@${channel.handle}',
                      style: const TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatCount(channel.subscriberCount)} người đăng ký • ${channel.videoCount} video',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _toggleSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubscribed ? const Color(0xff2a2a2a) : const Color(0xffe24594),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(_isSubscribed ? Icons.notifications_none : Icons.notifications_outlined),
                  label: Text(_isSubscribed ? 'Đã đăng ký' : 'Đăng ký'),
                ),
              ),
              const SizedBox(width: 10),
              _smallIconButton(Icons.share_outlined),
              const SizedBox(width: 8),
              _smallIconButton(Icons.more_vert),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Text(
            channel.description ?? 'Chưa có mô tả kênh.',
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _smallIconButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(color: Color(0xff222222), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildVideoGrid() {
    if (_videos.isEmpty) {
      return const Center(child: Text('Kênh chưa có video', style: TextStyle(color: Colors.white54)));
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final v = _videos[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WatchVideoScreen(videoId: v.id)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        v.thumbnailUrl ?? 'https://via.placeholder.com/640x360.png?text=No+Thumbnail',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xff1b1b1b)),
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            v.durationFormatted,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                v.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '${v.viewsFormatted} lượt xem • ${v.timeAgo}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAbout(ChannelModel channel) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _aboutItem('Tên kênh', channel.name),
        _aboutItem('Handle', '@${channel.handle}'),
        _aboutItem('Người đăng ký', _formatCount(channel.subscriberCount)),
        _aboutItem('Số video', '${channel.videoCount}'),
        _aboutItem('Website', channel.websiteUrl ?? 'Chưa cập nhật'),
      ],
    );
  }

  Widget _aboutItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(title, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _ChannelTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _ChannelTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xff0f0f0f),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _ChannelTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}

