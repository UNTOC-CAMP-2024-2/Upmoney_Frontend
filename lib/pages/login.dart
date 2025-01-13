import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation.dart'; // 네비게이션 페이지 import
import 'signup.dart'; // 회원가입 페이지 import
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login(String id, String password) async {
    final url = Uri.parse('http://34.47.105.208:8000/auth/login'); // 백엔드 URL로 변경
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': id, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'];

        // Save token using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        print('Saved Token: ${prefs.getString('jwt_token')}');
        await prefs.setString('jwt_token', token);

        // Navigate to the next page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Navigation()),
        );
      } else {
        _showErrorDialog('로그인 실패: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('네트워크 오류가 발생했습니다.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인"),
        backgroundColor: const Color(0xffF4F4FE),
      ),
      backgroundColor: const Color(0xffF4F4FE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이디 입력 필드
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: "아이디",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 비밀번호 입력 필드
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "비밀번호",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 로그인 버튼
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        final id = idController.text.trim();
                        final password = passwordController.text.trim();

                        if (id.isEmpty || password.isEmpty) {
                          _showErrorDialog('아이디와 비밀번호를 입력하세요.');
                          return;
                        }

                        login(id, password);
                      },
                      child: const Text(
                        "로그인",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 회원가입 버튼
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 280,
                    height: 50,
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
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
