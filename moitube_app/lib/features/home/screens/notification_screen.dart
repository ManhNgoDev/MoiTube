import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moitube_app/features/home/controllers/notification_controller.dart';
import 'package:moitube_app/models/notification_model.dart';
import 'package:moitube_app/features/home/screens/watch_video_screen.dart';
import 'package:moitube_app/features/home/screens/channel_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationController>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      appBar: AppBar(
        backgroundColor: const Color(0xff000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<NotificationController>(
          builder: (context, controller, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông báo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                if (controller.unreadCount > 0)
                  Text(
                    '${controller.unreadCount} thông báo mới',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationController>().markAllAsRead(),
            child: const Text(
              'Đánh dấu đã đọc',
              style: TextStyle(color: Color(0xffe24594), fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, _) {
          if (controller.isLoading && controller.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffe24594)),
            );
          }

          if (controller.error != null && controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  const SizedBox(height: 12),
                  const Text('Không thể tải thông báo', style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _fetch,
                    child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
                  ),
                ],
              ),
            );
          }

          // If there's an error but we have notifications (mock fallback), show a snackbar once
          if (controller.error != null && controller.notifications.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(controller.error!),
                  backgroundColor: Colors.orange.withValues(alpha: 0.8),
                  duration: const Duration(seconds: 3),
                ),
              );
            });
          }

          if (controller.notifications.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => controller.fetchNotifications(),
              color: const Color(0xffe24594),
              child: Stack(
                children: [
                  ListView(),
                  const Center(
                    child: Text(
                      'Chưa có thông báo nào',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchNotifications(),
            color: const Color(0xffe24594),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                return _NotificationItem(notification: controller.notifications[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleOnTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.transparent : Colors.white.withValues(alpha: 0.05),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread dot
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xffe24594),
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
              const SizedBox(width: 16),

            // Avatar with Icon
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: notification.actorAvatarUrl != null
                      ? NetworkImage(notification.actorAvatarUrl!)
                      : null,
                  backgroundColor: const Color(0xffe24594),
                  child: notification.actorAvatarUrl == null
                      ? Text(
                          notification.actorName.isNotEmpty ? notification.actorName[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForType(notification.type),
                      size: 14,
                      color: _getColorForType(notification.type),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                      children: [
                        TextSpan(
                          text: notification.actorName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: notification.displayMessage),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.timeAgo,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Resource Thumbnail
            if (notification.resourceThumbnailUrl != null)
              Container(
                margin: const EdgeInsets.only(left: 12),
                width: 72,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    image: NetworkImage(notification.resourceThumbnailUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context) {
    context.read<NotificationController>().markAsRead(notification.id);

    final resId = notification.resourceId;
    final actId = notification.actorId;

    switch (notification.type) {
      case NotificationType.new_video:
      case NotificationType.comment:
      case NotificationType.like:
        if (resId != null && resId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WatchVideoScreen(videoId: resId)),
          );
        }
        break;
      case NotificationType.subscribe:
        if (actId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChannelDetailScreen(channelId: actId)),
          );
        }
        break;
    }
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.new_video:
        return Icons.notifications;
      case NotificationType.comment:
        return Icons.chat_bubble_outline;
      case NotificationType.like:
        return Icons.thumb_up_alt_outlined;
      case NotificationType.subscribe:
        return Icons.person_add_alt_1_outlined;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.new_video:
        return const Color(0xffe24594);
      case NotificationType.comment:
        return Colors.blueAccent;
      case NotificationType.like:
        return Colors.redAccent;
      case NotificationType.subscribe:
        return Colors.deepPurpleAccent;
    }
  }
}

