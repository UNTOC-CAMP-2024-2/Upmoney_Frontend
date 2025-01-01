import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // 화면 중앙에 모든 내용을 정렬
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 전체 패딩 추가
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가로로 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 세로로 중앙 정렬
            children: [
              // 왼쪽: 사용자 아이콘
              const Icon(
                Icons.account_circle,
                size: 100, // 아이콘 크기
                color: Colors.grey, // 아이콘 색상
              ),
              const SizedBox(width: 16), // 아이콘과 텍스트 사이 간격
              // 오른쪽: 텍스트들
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
                mainAxisSize: MainAxisSize.min, // 텍스트 높이 최소화
                children: const [
                  Text(
                    "반갑습니다!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500, 
                    ),
                  ),
                  SizedBox(height: 8), // 간격
                  Text(
                    "사용자 이름 님",
                    style: TextStyle(
                      fontSize: 2, 
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                  SizedBox(height: 8), // 간격
                  Text(
                    "아이디 | 비밀번호 확인",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey, 
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}