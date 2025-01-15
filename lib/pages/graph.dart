import 'package:flutter/material.dart';
import 'package:flutter_application_3/splash_screen.dart';

void main() => runApp(const Myapp());

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF081F5C),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF081F5C),
            size: 40,
          ),
        ),
      ),

      home: const SplashScreen(),
    );
  } 
}
