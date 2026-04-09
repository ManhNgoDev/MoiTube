import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/models/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20}) async {
    final res = await ApiClient.dio.get(
      '/notifications',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    
    if (res.data != null && res.data['data'] != null) {
      List<dynamic> list = res.data['data'];
      return list.map((json) => NotificationModel.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> markAsRead(String id) async {
    await ApiClient.dio.patch('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await ApiClient.dio.patch('/notifications/read-all');
  }
}
