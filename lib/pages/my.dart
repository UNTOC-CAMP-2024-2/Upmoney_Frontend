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
          centerTitle: true, 
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
        return "2025-01-05: 공지사항";
      case "앱 사용방법":
        return "Upmoney 사용방법";
      default:
        return "알 수 없는 페이지";
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
