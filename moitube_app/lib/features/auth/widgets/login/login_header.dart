import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget{
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage('assets/images/logo.png'),
          width: 150,
          height: 150,
        ),

        SizedBox(height: 20,),

        Text(
          'Chào mừng trở lại',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),

        SizedBox(height: 10,),

        Text(
          'Đăng nhập để tiếp tục với MoiTube',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70
          ),
        ),
      ],
    );
  }
}