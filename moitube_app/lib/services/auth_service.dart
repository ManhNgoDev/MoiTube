import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/services/storage_service.dart';

class AuthService {
  //Đăng ký
  Future register(String email, String username, String password) async {
    final res = await ApiClient.dio.post(
      "/auth/register",
      data: {
        "email": email,
        "username": username,
        "password": password
      }
    );
    return res.data;
  }
  //Đăng nhập
  Future login(String email, String password) async {
    final res = await ApiClient.dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password
      }
    );
    return res.data;
  }

  Future resendVerify(String email) async {
    final res = await ApiClient.dio.post(
      '/auth/resend-verify',
      data: {
        "email": email
      }
    );
    return res.data;
  }

  Future<String?> refreshToken() async {
    final refreshToken = await StorageService.getRefreshToken();
    if(refreshToken == null) return null;
    final res = await ApiClient.dio.post(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken
      }
    );
    return res.data['access_token'];
  }
}