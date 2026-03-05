import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget{
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [

          Image(
            image: AssetImage('assets/images/logo.png'),
            width: 150,
            height: 150,
          ),

          Text(
            'Tạo tài khoản',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 10,),

          Text(
            'Tham gia MoiTube cùng mọi người',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

}