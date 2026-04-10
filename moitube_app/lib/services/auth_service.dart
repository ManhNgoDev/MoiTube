import 'package:dio/dio.dart' as dio_lib;
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
    
    // Sử dụng instance Dio sạch (không có interceptor của ApiClient) để tránh vòng lặp vô tận
    final dio = dio_lib.Dio(dio_lib.BaseOptions(baseUrl: ApiClient.baseUrl));
    
    final res = await dio.post(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken
      }
    );
    return res.data['access_token'];
  }

  // Đăng xuất
  Future logout() async {
    final refreshToken = await StorageService.getRefreshToken();
    if(refreshToken == null) return;
    final res = await ApiClient.dio.post(
      '/auth/logout',
      data: {
        'refresh_token': refreshToken
      }
    );
    return res.data;
  }

  Future forgotPassword(String email) async {
    final res = await ApiClient.dio.post(
      '/auth/forgot-password',
      data: {
        'email': email,
      }
    );
    return res.data;
  }

  Future resetPassword(String email, String otp, String password) async {
    final res = await ApiClient.dio.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'otp': otp,
        'password': password,
      }
    );
    return res.data;
  }
}