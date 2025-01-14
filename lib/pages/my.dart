import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Map<String, dynamic>? userData; // 사용자 정보 저장
  bool isLoading = false;         // 로딩 상태
  String? errorMessage;           // 에러 메시지
  String? fortuneMessage;

  // 1. 내 정보 가져오기 함수
  Future<void> fetchUserInfo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 1) SharedPreferences에서 토큰 가져오기
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        throw Exception('로그인 정보가 없습니다. 다시 로그인해주세요.');
      }

      // 2) 백엔드 /auth/userinfo 호출
      final url = Uri.parse('http://34.47.105.208:8000/auth/userinfo').replace(
        queryParameters: {
          'token':token,
        }
      );
      final response = await http.get(
        url,
        headers: {
          'Conten-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
        },
      );

      // 3) 응답 처리
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userData = data;
          isLoading = false;
        });
        showUserInfoModal(); // 모달창 호출
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = '사용자 정보를 가져오는 중 오류가 발생했습니다: $e';
        isLoading = false;
      });
    }
  }

  // 모달 창 호출
  void showUserInfoModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        if (userData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "내 정보",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 1),
              const SizedBox(height:16),
              Text(
                "이름: ${userData!['name']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "나이: ${userData!['age']}세",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "성별: ${userData!['gender']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "아이디: ${userData!['username']}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 모달 닫기
                  },
                  child: const Text("닫기"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchFortune() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse('hhttp://34.47.105.208:8000/monetaryluck/random');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fortuneMessage = data['fortune']; // 'fortune' 키로 데이터를 가져옴
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "금전운 정보를 가져오는 데 실패했습니다. (${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "금전운 정보를 가져오는 중 오류가 발생했습니다: $e";
        isLoading = false;
      });
    }
  }

  // 2. UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // 전체 스크롤 가능하게 변경
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Section 1: 사용자 정보
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 130,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "반갑습니다!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData != null
                            ? "${userData!['name']} 님"
                            : "사용자 이름 님", // 사용자 이름 표시
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: fetchUserInfo, // 내 정보 가져오기
                        child: const Text(
                          "내 정보 확인",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 70, 74, 77), // 클릭 가능하게 파란색으로 변경
                            decoration: TextDecoration.underline, // 밑줄 추가
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Section 3: 금전운 
            Container(
              width: double.infinity,
              height: 320,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/monetaryluck.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator() // 로딩 중
                    : errorMessage != null
                        ? Text(
                            errorMessage!,
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            fortuneMessage ?? "운세를 불러오는 중...",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
              ),
            ),

            // Section 4: 공지사항
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView(
                shrinkWrap: true, // 스크롤 충돌 방지
                physics: const NeverScrollableScrollPhysics(), // ListView 내부 스크롤 비활성화
                children: [
                  _buildListTile(
                    context,
                    "금전운 안내서",
                    const GuidePage(title: "금전운 안내서"),
                  ),
                  _buildListTile(
                    context,
                    "공지사항",
                    const GuidePage(title: "공지사항"),
                  ),
                  _buildListTile(
                    context,
                    "앱 사용방법",
                    const GuidePage(title: "앱 사용방법"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 리스트 타일 유지
  Widget _buildListTile(
    BuildContext context,
    String title,
    Widget nextpage, {
    bool isLastItem = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextpage),
            );
          },
        ),
        if (!isLastItem)
          const Divider(
            thickness: 1.0,
            color: Colors.grey,
            height: 0,
          ),
      ],
    );
  }
}



class GuidePage extends StatelessWidget {
  final String title; 
  const GuidePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0), // AppBar 제목 위치 조정
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: false, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 본문 큰 글씨
              Text(
                _getHeadingForPage(title), 
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // 본문 내용
              Text(
                _getContentForPage(title),
                style: const TextStyle(
                  fontSize: 22,
                  height: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getHeadingForPage(String title) {
    switch (title) {
      case "금전운 안내서":
        return "🍀금전운 안내서🍀";
      case "공지사항":
        return " 2025-01-05: 공지사항 ";
      case "앱 사용방법":
        return " Upmoney 사용방법 ";
      default:
        return " 알 수 없는 페이지 ";
    }
  }

  // 본문 내용 반환
  String _getContentForPage(String title) {
    switch (title) {
      case "금전운 안내서":
        return "금전운을 높이기 위한 팁과 방법:\n"
            "- 소비 습관 점검하기\n"
            "- 저축 계획 세우기\n"
            "- 지출 항목 분석과 최적화\n"
            "- 장학금 정보를 통한한 재정 생활 구체화";
      case "공지사항":
        return "여기에는 최신 공지사항이 표시됩니다:\n"
            "- 서비스 점검: 2025년 01월 05일\n";
      case "앱 사용방법":
        return "앱 사용방법 가이드:\n"
            "1. 회원가입 또는 로그인.\n"
            "2. 계좌연결 후 분석된 자신의 소비 습관 확인.\n"
            "3. Upmoney앱을 통해 올바른 소비 습관을 형성합시다!";
      default:
        return "해당 페이지의 내용이 준비되지 않았습니다.";
    }
  }
}
