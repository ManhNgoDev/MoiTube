import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moitube_app/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService = AuthService();

  bool isLoading = false;

  //REGISTER
  Future<bool> register(
    BuildContext context,
    String email,
    String username,
    String password,
  ) async {
    isLoading = true;

    notifyListeners();

    try {
      await authService.register(email, username, password);

      return true;
    } on DioException catch (e) {
      if(!context.mounted) return false;

      final message = e.response?.data['message'] ?? 'Đã có lỗi xảy ra';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
      );

      return false;
    } finally {
      isLoading = false;
      
      notifyListeners();
    }
  }

  //LOGIN
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    isLoading = true;

    notifyListeners();

    try {
      final data = await authService.login(email, password);

      print('Đăng nhập thành công: $data');

      return true;
    } on DioException catch (e) {
      if(!context.mounted) return false;

      final message = e.response?.data['message'] ?? 'Đã có lỗi xảy ra';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  //RESEND VERIFY
  Future<void> resendVerify(
    BuildContext context,
    String email
  ) async {
    try {
      await authService.resendVerify(email);

      if(!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã gửi lại email xác nhận'))
      );

    } on DioException catch (e) {
      if(!context.mounted) return;

      final message = e.response?.data['message'] ?? 'Đã có lỗi xảy ra';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
      );
    }
  }
}