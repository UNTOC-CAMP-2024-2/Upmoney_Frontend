import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final idController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedGender; // 선택된 성별
  int? selectedAge; // 선택된 나이
  final List<int> ageOptions = List<int>.generate(100, (index) => index + 1); // 1~100세

  Future<void> signUp() async {
    final url = Uri.parse('http://34.47.105.208:8000/auth/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': idController.text.trim(),
          'name': usernameController.text.trim(),
          'hashed_password': passwordController.text.trim(),
          'age': selectedAge ?? 0, // 선택된 나이 전달
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

  void _showAgePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int temporarySelectedAge = selectedAge ?? ageOptions.first; // 임시 선택 값

        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: ageOptions.indexOf(selectedAge ?? ageOptions.first),
                  ),
                  onSelectedItemChanged: (int index) {
                    temporarySelectedAge = ageOptions[index];
                  },
                  children: ageOptions.map((age) => Text('$age세')).toList(),
                ),
              ),
              const Divider(height: 1, color: Colors.grey), // 구분선 추가
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAge = temporarySelectedAge; // 최종 선택 값 저장
                  });
                  Navigator.pop(context); // 창 닫기
                },
                child: Container(
                  width: double.infinity, // 버튼을 화면 전체로 확장
                  color: Colors.white, // 배경색 흰색 설정
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, color: Colors.black), // 검은 글씨
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String? temporarySelectedGender = selectedGender; // 임시 선택 값

        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedGender == 'male' ? 0 : 1,
                  ),
                  onSelectedItemChanged: (int index) {
                    temporarySelectedGender = index == 0 ? 'male' : 'female';
                  },
                  children: const [
                    Text('남성'),
                    Text('여성'),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey), // 구분선 추가
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = temporarySelectedGender; // 최종 선택 값 저장
                  });
                  Navigator.pop(context); // 창 닫기
                },
                child: Container(
                  width: double.infinity, // 버튼을 화면 전체로 확장
                  color: Colors.white, // 배경색 흰색 설정
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, color: Colors.black), // 검은 글씨
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

                // 나이 선택 박스
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _showAgePicker,
                    child: Stack(
                      children: [
                        Container(
                          width: 400,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0), // 텍스트 살짝 내리기
                            child: Text(
                              selectedAge != null ? '$selectedAge세' : '',
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: 3, // 라벨을 조금 더 위로 올리기
                          child: Container(
                            color: const Color(0xffF4F4FE), // 배경색
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: const Text(
                              '나이',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 성별 선택 박스
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _showGenderPicker,
                    child: Stack(
                      children: [
                        Container(
                          width: 400,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            selectedGender != null
                                ? (selectedGender == 'male' ? '남성' : '여성')
                                : '',
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: 3, // 텍스트가 입력 필드와 겹치지 않도록 수정
                          child: Container(
                            color: const Color(0xffF4F4FE), // 배경색
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: const Text(
                              '성별 선택',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 회원가입 버튼
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
                            selectedGender == null ||
                            selectedAge == null) {
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
