import 'package:flutter/material.dart';
import 'package:moitube_app/models/notification_model.dart';
import 'package:moitube_app/services/notification_service.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _notificationService.getNotifications();
      _notifications = list;
    } catch (e) {
      debugPrint('Notification fetch error: $e');
      _error = 'Không thể tải thông báo từ server. Vui lòng kiểm tra kết nối.';
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      _notifications = _notifications.map((n) => NotificationModel(
        id: n.id,
        userId: n.userId,
        type: n.type,
        actorId: n.actorId,
        resourceId: n.resourceId,
        isRead: true,
        createdAt: n.createdAt,
        actorName: n.actorName,
        actorAvatarUrl: n.actorAvatarUrl,
        resourceThumbnailUrl: n.resourceThumbnailUrl,
        message: n.message,
      )).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _notificationService.markAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final n = _notifications[index];
        _notifications[index] = NotificationModel(
          id: n.id,
          userId: n.userId,
          type: n.type,
          actorId: n.actorId,
          resourceId: n.resourceId,
          isRead: true,
          createdAt: n.createdAt,
          actorName: n.actorName,
          actorAvatarUrl: n.actorAvatarUrl,
          resourceThumbnailUrl: n.resourceThumbnailUrl,
          message: n.message,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
