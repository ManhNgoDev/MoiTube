import 'package:flutter/material.dart';

class LoginOther extends StatelessWidget {
  const LoginOther({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Chưa có tài khoản?',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text(
                    'Đăng ký ngay',
                    style: TextStyle(fontSize: 16, color: Color(0xfff6339a)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
