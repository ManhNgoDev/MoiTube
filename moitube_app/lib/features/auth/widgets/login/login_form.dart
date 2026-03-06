import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget{
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  bool showPassword = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future handleLogin() async {
    if(emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đậy đủ thông tin'))
      );
      return;
    }

    if(!emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email không hợp lệ'))
      );
      return;
    }

    final success = await context.read<AuthController>().login(
      context,
      emailController.text.trim(),
      passwordController.text,
    );

    if(success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthController>().isLoading;
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
            controller: emailController,
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
            controller: passwordController,
            obscureText: !showPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white60,
              ),

              hintText: '........',
              hintStyle: TextStyle(color: Colors.white60),

              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
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
                onPressed: isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,

                ),
                child: isLoading ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                ) : Text('Đăng nhập', style: TextStyle(fontSize: 20, color: Colors.white),)
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}