class Video {
  final String id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? videoUrl;
  final int duration;
  final String status;
  final int viewCount;
  final int likeCount;
  final int dislikeCount;
  final DateTime? publishedAt;
  final String channelName;
  final String? channelAvatarUrl;

  Video({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.videoUrl,
    required this.duration,
    required this.status,
    required this.viewCount,
    required this.likeCount,
    required this.dislikeCount,
    this.publishedAt,
    required this.channelName,
    this.channelAvatarUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final channel = json['channel'];
    return Video(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
      duration: json['duration'] ?? 0,
      status: json['status'] ?? 'public',
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      dislikeCount: json['dislike_count'] ?? 0,
      publishedAt: json['published_at'] != null ? DateTime.tryParse(json['published_at']) : null,
      channelName: channel != null 
          ? (channel['name'] ?? channel['handle'] ?? 'Unknown Channel') 
          : 'Unknown Channel',
      channelAvatarUrl: _parseAvatarUrl(channel),
    );
  }

  static String? _parseAvatarUrl(Map<String, dynamic>? channel) {
    if (channel == null) return null;
    final user = channel['user'];
    if (user == null) return null;
    final url = user['avatar_url'];
    if (url == null || url.toString().isEmpty) return null;
    return url.toString();
  }

  String get durationFormatted {
    final int minutes = duration ~/ 60;
    final int seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get viewsFormatted {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    }
    return viewCount.toString();
  }

  String get timeAgo {
    if (publishedAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(publishedAt!);

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
}
