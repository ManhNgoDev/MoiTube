import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/widgets/login/login_form.dart';
import 'package:moitube_app/features/auth/widgets/login/login_header.dart';
import 'package:moitube_app/features/auth/widgets/login/login_other.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1,
            colors: [
              Color(0xff2f0a1b),
              Color(0xff12051b),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),

            child: Column(
              children: [
                LoginHeader(),

                SizedBox(height: 20,),

                LoginForm(),

                SizedBox(height: 30,),

                LoginOther(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
