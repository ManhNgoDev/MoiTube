import 'package:flutter/material.dart';
import 'package:moitube_app/features/auth/controllers/auth_controller.dart';
import 'package:moitube_app/features/auth/screens/login_screen.dart';
import 'package:moitube_app/features/auth/screens/register_screen.dart';
import 'package:moitube_app/features/home/screens/home_screen.dart';
import 'package:moitube_app/features/splash/splash_screen.dart';
import 'package:moitube_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoiTube',
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.register: (context) => RegisterScreen(),
        AppRoutes.home: (context) => HomeScreen(),
      },
    );
  }
}