import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/screens/login_screen.dart';
import 'package:moitube_app/services/auth_service.dart';

class VerifyEmailDialog extends StatelessWidget {
  final String email;
  final AuthService authService;

  const VerifyEmailDialog({
    super.key,
    required this.email,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff18181b),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.email_outlined, color: Color(0xfff6339a)),
          SizedBox(width: 10),
          Text('Kiểm tra email', style: TextStyle(color: Colors.white)),
        ],
      ),
      content: Text(
        'Chúng tôi đã gửi link xác nhận đến\n$email\n\nVui lòng kiểm tra hộp thư và click vào link để kích hoạt tài khoản.',
        style: const TextStyle(color: Colors.white70, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await authService.resendVerify(email);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã gửi lại email xác nhận')),
            );
          },
          child: const Text(
            'Gửi lại email',
            style: TextStyle(color: Colors.white54),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfff6339a),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text('Đến trang đăng nhập'),
        ),
      ],
    );
  }
}