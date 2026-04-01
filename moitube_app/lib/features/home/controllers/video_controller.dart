import 'package:flutter/material.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/services/video_service.dart';

class VideoController extends ChangeNotifier {
  final VideoService _videoService = VideoService();

  List<Video> _videos = [];
  bool _isLoading = false;
  String? _error;
  
  // Pagination
  int _currentPage = 1;
  bool _hasMore = true;
  
  List<Video> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchVideos({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _videos.clear();
      _hasMore = true;
      _error = null;
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newVideos = await _videoService.getVideos(page: _currentPage, limit: 10);
      
      if (newVideos.isEmpty) {
        _hasMore = false;
      } else {
        _videos.addAll(newVideos);
        _currentPage++;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchVideoTitleBinary(String title) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (title.isEmpty) {
        await fetchVideos(refresh: true);
        return;
      }
      
      final video = await _videoService.searchVideoByTitleBinary(title);
      _videos.clear();
      if (video != null) {
        _videos.add(video);
      }
      _hasMore = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
