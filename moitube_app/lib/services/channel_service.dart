import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/features/home/models/channel_model.dart';

class ChannelService {
  // Lấy channel của chính mình
  Future<ChannelModel> getMyChannel() async {
    final res = await ApiClient.dio.get("/channels/me");
    return ChannelModel.fromJson(res.data);
  }

  // Cập nhật channel
  Future<ChannelModel> updateChannel(Map<String, dynamic> data) async {
    final res = await ApiClient.dio.patch("/channels/me", data: data);
    return ChannelModel.fromJson(res.data);
  }
}

