import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
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
              const SizedBox(height: 16), // 간격
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
              // 회원가입 버튼
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 400, // 가로 크기
                  height: 60, // 세로 크기
                  child: ElevatedButton(
                    onPressed: () {
                      // 회원가입 완료 후 이전 페이지로 돌아가기
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "회원가입",
                      style: TextStyle(fontSize: 18),
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