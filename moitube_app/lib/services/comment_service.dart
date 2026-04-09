import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/models/comment.dart';
import 'package:moitube_app/services/storage_service.dart';

class CommentService {
  Future<List<CommentModel>> getCommentsByVideoId(String videoId) async {
    final res = await ApiClient.dio.get('/videos/$videoId/comments');
    final data = res.data;
    if (data is List) {
      return data.map((e) => CommentModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<CommentModel> postComment({required String videoId, required String content}) async {
    final res = await ApiClient.dio.post(
      '/comments',
      data: {
        'videoId': videoId,
        'content': content,
      },
    );
    return CommentModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> deleteComment(String commentId) async {
    await ApiClient.dio.delete('/comments/$commentId');
  }

  Future<String?> getCurrentUserIdIfLoggedIn() async {
    final isLoggedIn = await StorageService.isLoggedIn();
    if (!isLoggedIn) return null;
    final res = await ApiClient.dio.get('/users/me');
    final data = res.data;
    if (data is Map && data['id'] != null) return data['id'].toString();
    return null;
  }
}

