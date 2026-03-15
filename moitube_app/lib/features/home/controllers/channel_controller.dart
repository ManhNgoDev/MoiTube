import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/models/channel_model.dart';
import 'package:moitube_app/services/channel_service.dart';

class ChannelController extends ChangeNotifier {
  final ChannelService _channelService = ChannelService();

  ChannelModel? _myChannel;
  bool _isLoading = false;
  String? _error;

  ChannelModel? get myChannel => _myChannel;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Lấy channel của mình
  Future<void> fetchMyChannel() async {
    if (_isLoading) return; 
    
    _isLoading = true;
    _error = null;
    notifyListeners();


    try {
      debugPrint("Fetching my channel...");
      _myChannel = await _channelService.getMyChannel();
      debugPrint("Fetched my channel successfully: ${_myChannel?.name}");
    } catch (e) {
      debugPrint("Error fetching my channel: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  // Cập nhật thông tin channel
  Future<bool> updateChannelInfo(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _myChannel = await _channelService.updateChannel(data);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

