import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';

  //Lưu token 
  static Future saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessToken, value: accessToken);
    await _storage.write(key: _refreshToken, value: refreshToken);
  }

  //Lấy token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessToken);
  } 

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshToken);
  }

  //Xóa tokenkhi đăng xuất
  static Future clearTokens() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
  }

  //Check Đăng nhập
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessToken);
    return token != null;
  } 

}