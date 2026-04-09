import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/screens/channel_detail_screen.dart';
import 'package:moitube_app/features/home/widgets/feed/video_card.dart';
import 'package:moitube_app/features/home/models/channel_model.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/channel_service.dart';
import 'package:moitube_app/services/storage_service.dart';
import 'package:moitube_app/services/video_service.dart';

class ChannelTab extends StatefulWidget {
    const ChannelTab({super.key});

    @override
    State<ChannelTab> createState() => _ChannelTabState();
}

class _ChannelTabState extends State<ChannelTab> {
  final ChannelService _channelService = ChannelService();
  final VideoService _videoService = VideoService();

  bool _loading = true;
  String? _error;
  bool _loggedIn = false;

  List<ChannelModel> _subs = [];
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final loggedIn = await StorageService.isLoggedIn();
    if (!mounted) return;
    setState(() {
      _loggedIn = loggedIn;
      _loading = true;
      _error = null;
      _subs = [];
      _videos = [];
    });

    if (!loggedIn) {
      setState(() => _loading = false);
      return;
    }

    try {
      final subs = await _channelService.getMySubscriptions();
      final vids = await _videoService.getSubscriptionFeed(page: 1, limit: 20);
      if (!mounted) return;
      setState(() {
        _subs = subs;
        _videos = vids;
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

  List<Video> _filterToday(List<Video> input) {
    final now = DateTime.now();
    return input.where((v) {
      final dt = v.publishedAt ?? v.publishedAt;
      if (dt == null) return false;
      return now.difference(dt).inHours <= 24;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xffe24594)))
            : !_loggedIn
                ? _buildNeedLogin()
                : _error != null
                    ? _buildError()
                    : _buildBody(),
      ),
    );
  }

  Widget _buildNeedLogin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.subscriptions_outlined, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Đăng nhập để xem kênh đã đăng ký',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bạn sẽ thấy danh sách kênh đã đăng ký và video mới từ các kênh đó.',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: _init,
              child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            const Text('Không thể tải dữ liệu', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text(_error ?? '', style: const TextStyle(color: Colors.white54), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _init,
              child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Text(
              'Kênh đăng ký',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          _buildSubRow(),
          const SizedBox(height: 6),
          const TabBar(
            isScrollable: true,
            indicatorColor: Color(0xffe24594),
            labelColor: Color(0xffe24594),
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Hôm nay'),
              Tab(text: 'Videos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildVideoList(_videos),
                _buildVideoList(_filterToday(_videos)),
                _buildVideoList(_videos),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubRow() {
    if (_subs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Text('Bạn chưa đăng ký kênh nào.', style: TextStyle(color: Colors.white38)),
      );
    }
    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: _subs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final c = _subs[index];
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChannelDetailScreen(channelHandle: c.handle)),
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xff272727),
                      backgroundImage: c.avatarUrl != null ? NetworkImage(c.avatarUrl!) : null,
                      child: c.avatarUrl == null
                          ? Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xffe24594),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(
                    c.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList(List<Video> videos) {
    if (videos.isEmpty) {
      return const Center(
        child: Text('Không có video.', style: TextStyle(color: Colors.white38)),
      );
    }
    return RefreshIndicator(
      color: const Color(0xffe24594),
      onRefresh: _init,
      child: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) => VideoCard(video: videos[index]),
      ),
    );
  }
}