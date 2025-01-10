import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final idController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  String? selectedGender; // 선택된 성별

  Future<void> signUp() async {
    final url = Uri.parse('http://your-backend-url/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userid': idController.text.trim(),
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
          'age': int.tryParse(ageController.text.trim()) ?? 0,
          'gender': selectedGender, // 선택된 성별 전달
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog('회원가입 성공! 로그인 해주세요.');
      } else {
        _showErrorDialog('회원가입 실패: ${response.body}');
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('성공'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
        title: const Text("회원가입"),
        backgroundColor: const Color(0xffF4F4FE),
        elevation: 0,
      ),
      backgroundColor: const Color(0xffF4F4FE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "이름",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                //나이
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "나이",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                //성별
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "성별",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("남성"),
                              value: "male",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("여성"),
                              value: "female",
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (idController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            selectedGender == null) {
                          _showErrorDialog('모든 필드를 채워주세요.');
                        } else {
                          signUp();
                        }
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
      ),
    );
  }
}
