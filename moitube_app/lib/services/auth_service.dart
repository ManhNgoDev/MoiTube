import 'package:moitube_app/core/api_client.dart';

class AuthService {
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

  Future resendVerify(String email) async {
    final res = await ApiClient.dio.post(
      '/auth/resend-verify',
      data: {
        "email": email
      }
    );
    return res.data;
  }
}