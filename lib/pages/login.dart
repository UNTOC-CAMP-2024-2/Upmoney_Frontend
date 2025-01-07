import 'package:flutter/material.dart';
import 'signup.dart'; // 회원가입 페이지 import
import '../navigation.dart'; // 네비게이션 페이지 import

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "로그인",
          style: TextStyle(
            color: const Color(0xFF081F5C),
            fontWeight: FontWeight.bold,
            )
          ),
        backgroundColor: const Color(0xffF4F4FE),
        elevation: 0,
      ),
      backgroundColor:  const Color(0xffF4F4FE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 이메일 입력 필드
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400, // 가로 크기
                  height: 60, // 세로 크기
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "이메일",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // 간격
              // 비밀번호 입력 필드
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400, // 가로 크기
                  height: 60, // 세로 크기
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "비밀번호",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // 간격
              // 로그인 버튼
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400, // 가로 크기
                  height: 60, // 세로 크기
                  child: ElevatedButton(
                    onPressed: () {
                      // 로그인 성공 시 네비게이션으로 이동
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Navigation(),
                        ),
                      );
                    },
                    child: const Text(
                      "로그인",
                      style: TextStyle(fontSize: 18), // 버튼 텍스트 크기
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // 간격
              // 회원가입 버튼
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 280, // 버튼 크기
                  height: 50, // 버튼 높이
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "회원가입하기",
                      style: TextStyle(
                        fontSize: 16, // 텍스트 크기 증가
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}