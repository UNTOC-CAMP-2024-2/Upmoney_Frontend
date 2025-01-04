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

class GuidePage extends StatelessWidget {
  final String title; 
  const GuidePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          "여기는 $title 페이지입니다.",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}