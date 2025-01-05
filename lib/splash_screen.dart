import 'package:flutter/material.dart';
import 'navigation.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Navigation()),
      );
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(244, 187, 204, 235),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지
            const Icon(
              Icons.monetization_on,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 16),

            const Text(
              "UPmoney",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
