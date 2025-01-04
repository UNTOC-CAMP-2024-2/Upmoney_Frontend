import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 위에서부터 아래로 배치
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
                      "사용자 이름 님",
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

          // Section 2: 금전운운
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
        ],
      ),
    );
  }
}
