import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/controllers/auth_controller.dart';
import 'package:moitube_app/features/home/controllers/channel_controller.dart';
import 'package:moitube_app/features/home/controllers/notification_controller.dart';
import 'package:moitube_app/features/home/screens/channel_detail_screen.dart';
import 'package:moitube_app/features/home/screens/notification_screen.dart';
import 'package:moitube_app/features/home/screens/watch_video_screen.dart';
import 'package:moitube_app/features/home/screens/watch_history_screen.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_details.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_info.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_stats.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/video_service.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final VideoService _videoService = VideoService();
  List<Video> _myVideos = [];
  bool _loadingVideos = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  Future<void> _loadAll() async {
    final controller = context.read<ChannelController>();
    await controller.fetchMyChannel();
    await _loadMyVideos();
  }

  Future<void> _loadMyVideos() async {
    final channel = context.read<ChannelController>().myChannel;
    if (channel == null) return;
    setState(() => _loadingVideos = true);
    try {
      final vids = await _videoService.getVideosByChannelHandle(channel.handle, page: 1, limit: 50);
      if (!mounted) return;
      setState(() => _myVideos = vids);
    } catch (_) {
      if (!mounted) return;
      setState(() => _myVideos = []);
    } finally {
      if (mounted) setState(() => _loadingVideos = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChannelController>();
    final channel = controller.myChannel;

    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: controller.isLoading && channel == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xffe24594)))
          : channel == null
              ? _buildError(controller.error)
              : DefaultTabController(
                  length: 3,
                  child: RefreshIndicator(
                    onRefresh: _loadAll,
                    color: const Color(0xffe24594),
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverAppBar(
                          floating: true,
                          snap: true,
                          backgroundColor: const Color(0xff000000),
                          elevation: 0,
                          title: const Text(
                            'Trang cá nhân',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          actions: [
                            Consumer<NotificationController>(
                              builder: (context, notificationController, _) {
                                return Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const NotificationScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    if (notificationController.unreadCount > 0)
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffe24594),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              notificationController.unreadCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 7,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_outlined, color: Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.white),
                              onPressed: () => Navigator.pushNamed(context, '/edit-profile'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.white),
                              onPressed: () => context.read<AuthController>().logout(context),
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const ProfileInfo(),
                              const SizedBox(height: 12),
                              const ProfileDetails(),
                              const SizedBox(height: 12),
                              const ProfileStats(),
                              _buildQuickActions(channel),
                            ],
                          ),
                        ),
                        const SliverPersistentHeader(
                          pinned: true,
                          delegate: _ProfileTabBarDelegate(
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
                          _buildVideosTab(),
                          const Center(
                            child: Text('Chưa có playlist', style: TextStyle(color: Colors.white54)),
                          ),
                          _buildAboutTab(channel),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text(message ?? 'Không tìm thấy dữ liệu kênh', style: const TextStyle(color: Colors.grey)),
          TextButton(
            onPressed: _loadAll,
            child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(dynamic channel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: [
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _quickButton(
                  icon: Icons.groups_2_outlined,
                  label: 'Kênh đăng ký',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mở tab Kênh để xem kênh đăng ký')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _quickButton(
                  icon: Icons.history_toggle_off,
                  label: 'Lịch sử xem',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WatchHistoryScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _quickButton(
                  icon: Icons.watch_later_outlined,
                  label: 'Xem sau',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Xem sau sẽ bổ sung ở sprint sau')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _quickButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'Video đã thích',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Video đã thích sẽ bổ sung ở sprint sau')),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white12, height: 1),
        ],
      ),
    );
  }

  Widget _quickButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xffcc3bbf), Color(0xff3177ff)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    if (_loadingVideos) {
      return const Center(child: CircularProgressIndicator(color: Color(0xffe24594)));
    }
    if (_myVideos.isEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => _placeholderCard(index),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: _myVideos.length,
      itemBuilder: (context, index) {
        final v = _myVideos[index];
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
                        errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xff2a2a2a)),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            v.durationFormatted,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                v.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _placeholderCard(int index) {
    final fakeTimes = ['11:24', '12:24', '13:24', '14:24', '15:24', '16:24'];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xffd9d9d9),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.image_outlined, color: Colors.grey, size: 56),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                fakeTimes[index % fakeTimes.length],
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(dynamic channel) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(channel.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text('@${channel.handle}', style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 10),
        Text(channel.description ?? 'Chưa có mô tả', style: const TextStyle(color: Colors.white70, height: 1.5)),
        const SizedBox(height: 14),
        Text('Website: ${channel.websiteUrl ?? 'Chưa cập nhật'}', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _ProfileTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: const Color(0xff000000), child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _ProfileTabBarDelegate oldDelegate) => false;
}
