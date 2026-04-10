import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/models/video.dart';

class HistoryService {
  Future<void> addToHistory(String videoId) async {
    try {
      await ApiClient.dio.post('/history/$videoId');
    } catch (e) {
      // Bỏ qua lỗi nếu chưa đăng nhập hoặc lỗi kết nối, quá trình xem video chính vẫn tiếp tục bình thường
      print('Could not add to history: $e');
    }
  }

  Future<List<Video>> getHistory({int page = 1, int limit = 20}) async {
    final res = await ApiClient.dio.get('/history', queryParameters: {
      'page': page,
      'limit': limit,
    });
    
    final List data = res.data['data'] ?? [];
    return data.map((e) {
      // The backend returns { id, watchedAt, video }
      final videoData = e['video'];
      return Video.fromJson(videoData);
    }).toList();
  }

  Future<void> clearHistory() async {
    await ApiClient.dio.delete('/history/clear');
  }

  Future<void> removeHistoryItem(String videoId) async {
    await ApiClient.dio.delete('/history/$videoId');
  }
}
