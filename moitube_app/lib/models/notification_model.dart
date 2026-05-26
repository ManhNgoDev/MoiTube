enum NotificationType {
  newVideo,
  comment,
  like,
  subscribe,
}

class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String actorId;
  final String? resourceId;
  final bool isRead;
  final DateTime createdAt;

  // Extra fields for UI display (usually joined from actor/resource tables)
  final String actorName;
  final String? actorAvatarUrl;
  final String? resourceThumbnailUrl;
  final String? message;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.actorId,
    this.resourceId,
    required this.isRead,
    required this.createdAt,
    required this.actorName,
    this.actorAvatarUrl,
    this.resourceThumbnailUrl,
    this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Nested objects from server (NestJS/TypeORM pattern with joins)
    final actor = json['actor'] as Map<String, dynamic>?;
    final actorUser = actor != null ? (actor['user'] as Map<String, dynamic>?) : null;
    
    // Resource can be video, comment, or channel
    final resource = json['resource'] as Map<String, dynamic>?;
    
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      type: _parseType(json['type'] ?? ''),
      actorId: json['actor_id']?.toString() ?? '',
      resourceId: json['resource_id']?.toString(),
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      
      // Extended fields
      actorName: actor != null ? (actor['name'] ?? actor['handle'] ?? 'Người dùng') : 'Người dùng',
      actorAvatarUrl: actorUser != null ? actorUser['avatar_url'] : null,
      resourceThumbnailUrl: resource != null ? resource['thumbnail_url'] : null,
      message: json['message'], // Optionally provided by server
    );
  }

  static NotificationType _parseType(String type) {
    switch (type) {
      case 'new_video':
        return NotificationType.newVideo;
      case 'comment':
        return NotificationType.comment;
      case 'like':
        return NotificationType.like;
      case 'subscribe':
        return NotificationType.subscribe;
      default:
        return NotificationType.newVideo;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 365) {
      return '${difference.inDays ~/ 365} năm trước';
    } else if (difference.inDays >= 30) {
      return '${difference.inDays ~/ 30} tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  String get displayMessage {
    if (message != null) return message!;
    switch (type) {
      case NotificationType.newVideo:
        return 'đã đăng video mới';
      case NotificationType.comment:
        return 'đã bình luận về video của bạn';
      case NotificationType.like:
        return 'đã thích bình luận của bạn';
      case NotificationType.subscribe:
        return 'đã đăng ký kênh của bạn';
    }
  }
}
