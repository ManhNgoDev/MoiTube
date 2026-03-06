import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/controllers/auth_controller.dart';
import 'package:moitube_app/features/auth/screens/login_screen.dart';
import 'package:provider/provider.dart';

class VerifyEmailDialog extends StatefulWidget {
  final String email;

  const VerifyEmailDialog({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailDialog> createState() => _VerifyEmailDialogState();
}

class _VerifyEmailDialogState extends State<VerifyEmailDialog> {
  bool isResending = false;

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
        'Chúng tôi đã gửi link xác nhận đến\n${widget.email}\n\nVui lòng kiểm tra hộp thư và click vào link để kích hoạt tài khoản.',
        style: const TextStyle(color: Colors.white70, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: isResending ? null : () async {
            setState(() => isResending = true);

            await context.read<AuthController>().resendVerify(
              context,
              widget.email,
            );

            if (mounted) setState(() => isResending = false);
          },
          child: isResending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white54,
                  ),
                )
              : const Text(
                  'Gửi lại email',
                  style: TextStyle(color: Colors.white54),
                ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfff6339a),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
          child: const Text('Đến trang đăng nhập'),
        ),
      ],
    );
  }
}