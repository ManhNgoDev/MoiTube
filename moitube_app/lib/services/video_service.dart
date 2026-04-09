import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/models/video.dart';

enum VideoReactionType { like, dislike }

class VideoService {
  Future<List<Video>> getVideos({int page = 1, int limit = 10}) async {
    final res = await ApiClient.dio.get(
      '/videos',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    
    // Server returns payload in data property, wait actually from nestJS it returns: {data: [...], total: ...}
    // We parse the data array.
    if (res.data != null && res.data['data'] != null) {
      List<dynamic> list = res.data['data'];
      return list.map((json) => Video.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Video>> getSubscriptionFeed({int page = 1, int limit = 10}) async {
    final res = await ApiClient.dio.get(
      '/videos/subscriptions/feed',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    if (res.data != null && res.data['data'] != null) {
      final List<dynamic> list = res.data['data'];
      return list.map((json) => Video.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Video>> getVideosByChannelHandle(String handle, {int page = 1, int limit = 12}) async {
    final h = handle.trim();
    if (h.isEmpty) return [];
    final res = await ApiClient.dio.get(
      '/videos/channel/$h',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    if (res.data != null && res.data['data'] != null) {
      final List<dynamic> list = res.data['data'];
      return list.map((json) => Video.fromJson(json)).toList();
    }
    return [];
  }

  Future<Video?> searchVideoByTitleBinary(String title) async {
    final res = await ApiClient.dio.get(
      '/videos/search/binary',
      queryParameters: {
        'title': title,
      },
    );
    if (res.data != null && res.data != "") {
      return Video.fromJson(res.data);
    }
    return null;
  }

  Future<List<Video>> searchVideos(String query, {int page = 1, int limit = 10}) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final res = await ApiClient.dio.get(
      '/videos/search',
      queryParameters: {
        'query': q,
        'page': page,
        'limit': limit,
      },
    );
    if (res.data != null && res.data['data'] != null) {
      final List<dynamic> list = res.data['data'];
      return list.map((json) => Video.fromJson(json)).toList();
    }
    return [];
  }

  Future<Video> getVideoById(String id) async {
    final res = await ApiClient.dio.get('/videos/$id');
    return Video.fromJson(res.data);
  }

  Future<void> incrementView(String id) async {
    await ApiClient.dio.post('/videos/$id/view');
  }

  Future<Map<String, dynamic>> getMyReaction(String videoId) async {
    final res = await ApiClient.dio.get('/videos/$videoId/my-reaction');
    if (res.data is Map) return Map<String, dynamic>.from(res.data);
    return {'type': null, 'active': false, 'owner': false};
  }

  Future<Map<String, dynamic>> reactVideo(String videoId, VideoReactionType type) async {
    final res = await ApiClient.dio.post(
      '/videos/$videoId/react',
      data: {'type': type == VideoReactionType.like ? 'like' : 'dislike'},
    );
    if (res.data is Map) return Map<String, dynamic>.from(res.data);
    return {'type': type == VideoReactionType.like ? 'like' : 'dislike', 'active': true};
  }

  Future<List<Video>> getRelatedVideos(String videoId, {int limit = 10}) async {
    final res = await ApiClient.dio.get(
      '/videos',
      queryParameters: {'page': 1, 'limit': limit},
    );
    if (res.data != null && res.data['data'] != null) {
      List<dynamic> list = res.data['data'];
      return list
          .map((json) => Video.fromJson(json))
          .where((v) => v.id != videoId)
          .toList();
    }
    return [];
  }
}
