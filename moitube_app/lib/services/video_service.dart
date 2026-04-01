import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/models/video.dart';

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

  Future<Video> getVideoById(String id) async {
    final res = await ApiClient.dio.get('/videos/$id');
    return Video.fromJson(res.data);
  }

  Future<void> incrementView(String id) async {
    await ApiClient.dio.post('/videos/$id/view');
  }

  Future<void> incrementLikeCount(String id, int delta) async {
    await ApiClient.dio.post(
      '/videos/$id/like',
      data: {'delta': delta},
    );
  }

  Future<void> incrementDislikeCount(String id, int delta) async {
    await ApiClient.dio.post(
      '/videos/$id/dislike',
      data: {'delta': delta},
    );
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
