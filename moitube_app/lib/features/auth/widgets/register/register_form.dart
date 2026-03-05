import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/screens/login_screen.dart';
import 'package:moitube_app/services/auth_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =  TextEditingController();

  final AuthService authService = AuthService();

  Future handleRegister() async {
    if(passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu phải trên 8 ký tự trở lên'))
      );
      return;
    }

    if(passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không khớp'))
        );
        return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.register(
        emailController.text,
        usernameController.text,
        passwordController.text
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký tài khoản thành công'))
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen()
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Họ và tên',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),

          SizedBox(height: 10),

          TextField(
            controller: usernameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.account_circle, color: Colors.white70),

              hintText: 'Nguyễn Văn A',
              hintStyle: TextStyle(color: Colors.white70),

              filled: true,
              fillColor: Color(0xff18181b),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),

          SizedBox(height: 15),

          Text('Email', style: TextStyle(fontSize: 16, color: Colors.white70)),

          SizedBox(height: 10),

          TextField(
            controller: emailController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: Colors.white70),

              hintText: 'example@gmail.com',
              hintStyle: TextStyle(color: Colors.white70),

              filled: true,
              fillColor: Color(0xff18181b),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),

          SizedBox(height: 15),

          Text(
            'Mật khẩu',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),

          SizedBox(height: 10),

          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: Colors.white70),

              hintText: '........',
              hintStyle: TextStyle(color: Colors.white70),

              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
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
              ),
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Tối đa 8 ký tự',
            style: TextStyle(fontSize: 13, color: Colors.white60),
          ),

          SizedBox(height: 15),

          Text(
            'Xác nhận lại mật khẩu',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),

          SizedBox(height: 10),

          TextField(
            controller: confirmPasswordController,
            obscureText: !showConfirmPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: Colors.white70),

              hintText: '........',
              hintStyle: TextStyle(color: Colors.white70),

              suffixIcon: IconButton(
                icon: Icon(
                  showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),

                onPressed: () {
                  setState(() {
                    showConfirmPassword = !showConfirmPassword;
                  });
                },
              ),

              filled: true,
              fillColor: Color(0xff18181b),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),

          SizedBox(height: 20,),

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
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,

                ),
                child: isLoading ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Text('Đăng ký'),
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
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
