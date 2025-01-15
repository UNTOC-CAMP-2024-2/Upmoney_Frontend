import 'package:flutter/material.dart';
import 'pages/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1초 후 로그인 페이지로 이동
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFDFE8FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지
            const Icon(
              Icons.monetization_on,
              size: 110,
              color: const Color(0xFF081F5C),
            ),
            const SizedBox(height: 16),

            const Text(
              "UPmoney",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF081F5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
