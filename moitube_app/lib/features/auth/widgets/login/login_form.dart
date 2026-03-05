import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget{
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 10,),

          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white70,
              ),

              hintText: 'example@gmail.com',
              hintStyle: TextStyle(color: Colors.white60),

              filled: true,
              fillColor: Color(0xff18181b),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),

          SizedBox(height: 15,),

          Text(
            'Mật khẩu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70
            ),
          ),

          SizedBox(height: 10,),

          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white60,
              ),

              hintText: '........',
              hintStyle: TextStyle(color: Colors.white60),

              suffixIcon: Icon(
                Icons.visibility,
                color: Colors.white60,
              ),

              filled: true,
              fillColor: Color(0xff18181b),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1, color: Colors.white),
              )
            ),
          ),

          SizedBox(height: 15,),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Quên mật khẩu?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xfff6339a),
              ),
            ),
          ),

          SizedBox(height: 25,),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfff038a4),
                    Color(0xffb549fa),
                    Color(0xfff92f3e)
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,

                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}