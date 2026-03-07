import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moitube_app/routes/app_routes.dart';
import 'package:moitube_app/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final token = await StorageService.getAccessToken();

    if (!mounted) return;

    if (token != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff7a10c6), Color(0xFFc8232c)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/SplashAnimation.json',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 15),
            const Text(
              'MoiTube',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Xem video mọi lúc, mọi nơi',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}