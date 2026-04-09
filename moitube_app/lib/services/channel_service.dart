import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/features/home/models/channel_model.dart';
import 'package:path/path.dart' as p;

class ChannelService {
  // Lấy channel của chính mình
  Future<ChannelModel> getMyChannel() async {
    final res = await ApiClient.dio.get("/channels/me");
    return ChannelModel.fromJson(res.data);
  }

  Future<ChannelModel> getChannelByHandle(String handle) async {
    final res = await ApiClient.dio.get('/channels/$handle');
    return ChannelModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<ChannelModel> getChannelById(String channelId) async {
    final res = await ApiClient.dio.get('/channels/id/$channelId');
    return ChannelModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  // Cập nhật channel
  Future<ChannelModel> updateChannel(
    Map<String, dynamic> data, {
    File? avatar,
    File? banner,
  }) async {
    final formData = dio.FormData.fromMap(data);

    if (avatar != null) {
      formData.files.add(MapEntry(
        'avatar',
        await dio.MultipartFile.fromFile(
          avatar.path,
          filename: p.basename(avatar.path),
        ),
      ));
    }

    if (banner != null) {
      formData.files.add(MapEntry(
        'banner',
        await dio.MultipartFile.fromFile(
          banner.path,
          filename: p.basename(banner.path),
        ),
      ));
    }

    final res = await ApiClient.dio.patch("/channels/me", data: formData);
    return ChannelModel.fromJson(res.data);
  }

  Future<List<ChannelModel>> getMySubscriptions() async {
    final res = await ApiClient.dio.get('/channels/subscriptions/mine');
    final data = res.data;
    if (data is List) {
      return data
          .map((e) => (e is Map && e['channel'] is Map) ? ChannelModel.fromJson(Map<String, dynamic>.from(e['channel'])) : null)
          .whereType<ChannelModel>()
          .toList();
    }
    return [];
  }

  Future<bool> getSubscriptionStatus(String channelId) async {
    final res = await ApiClient.dio.get('/channels/$channelId/subscription-status');
    final data = res.data;
    if (data is bool) return data;
    if (data is Map && data['subscribed'] is bool) return data['subscribed'] as bool;
    return false;
  }

  Future<bool> toggleSubscription(String channelId) async {
    final res = await ApiClient.dio.post('/channels/$channelId/subscribe');
    final data = res.data;
    if (data is Map && data['subscribed'] is bool) return data['subscribed'] as bool;
    return false;
  }
}

