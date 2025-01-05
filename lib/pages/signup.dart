import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 이메일 입력 필드
            TextField(
              decoration: const InputDecoration(
                labelText: "이메일",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // 비밀번호 입력 필드
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                // 회원가입 로직
                // 예: Navigator.pop(context); // 회원가입 후 이전 페이지로 돌아가기
              },
              child: const Text("회원가입"),
            ),
          ],
        ),
      ),
    );
  }
}
