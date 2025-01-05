import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  children: const [
                    Text(
                      "반갑습니다!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "사용자 이름 님", // * 변수로 수정해야함
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "아이디 | 비밀번호 확인",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15), // Section 1과 Section 2 사이 간격

          // Section 2: 금전운
          Container(
            width: double.infinity, 
            height: 320, 
            decoration: BoxDecoration(
              color:Colors.yellow,
              // image: DecorationImage(
              //   image: AssetImage('assets/images/.png'), 
              //   fit: BoxFit.cover, 
              // ),
            ),
          ),
          // Section 3: 공지사항 등...
          Expanded(
            child: ListView(
              children: [
                _buildListTile(context, "금전운 안내서", GuidePage(title: "금전운 안내서")),
                _buildListTile(context, "공지사항", GuidePage(title: "공지사항")),
                _buildListTile(context, "앱 사용방법", GuidePage(title: "앱 사용방법")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, Widget nextpage){
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
    );
  }
}


// 공지사항 새 페이지
class GuidePage extends StatelessWidget {
  final String title; 
  const GuidePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), 
        child: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 25, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getContentForPage(title), // 각 페이지에 맞는 내용 가져오기
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 페이지 내용 반환
  String _getContentForPage(String title) {
    switch (title) {
      case "금전운 안내서":
        return "금전운을 높이기 위한 팁과 방법:\n"
            "- 소비 습관 점검하기\n"
            "- 저축 계획 세우기\n"
            "- 지출 항목 분석과 최적화";
      case "공지사항":
        return "여기에는 최신 공지사항이 표시됩니다:\n"
            "- 서비스 점검: 2023년 10월 1일\n"
            "- 새 기능 추가: 예산 목표 설정";
      case "앱 사용방법":
        return "앱 사용방법 가이드:\n"
            "1. 회원가입 또는 로그인.\n"
            "2. 예산을 입력하여 관리 시작.\n"
            "3. 월별 리포트를 확인하고 목표 설정.";
      default:
        return "해당 페이지의 내용이 준비되지 않았습니다.";
    }
  }
}
