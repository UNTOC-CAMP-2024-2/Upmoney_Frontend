import 'package:flutter/material.dart';

class ScholarshipPage extends StatefulWidget {
  /// 생성자를 const 로 선언 (runtime 상수가 없는 상태로 변경)
  const ScholarshipPage({super.key});

  @override
  State<ScholarshipPage> createState() => _ScholarshipPageState();
}

class _ScholarshipPageState extends State<ScholarshipPage> {
  /// 장학금 개수를 나타내는 상수
  static const int scholarshipCount = 20;

  /// 전체 장학금 리스트
  final List<String> scholarships =
      List.generate(scholarshipCount, (index) => '장학금 ${index + 1}');

  /// 검색 결과 리스트
  List<String> filteredScholarships = [];

  /// 초기화 메서드
  @override
  void initState() {
    super.initState();
    filteredScholarships = scholarships; // 처음에는 모든 장학금을 보여줌
  }

  /// 검색 기능
  void filterScholarships(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredScholarships = scholarships; // 검색어가 없으면 전체 리스트
      } else {
        filteredScholarships = scholarships
            .where(
                (scholarship) => scholarship.contains(query)) // 검색어가 포함된 항목 필터링
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.white, // 버튼 영역의 배경을 고정된 흰색으로 설정
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CategoryButton(label: 'PNU'),
                  CategoryButton(label: 'PNU_CSE'),
                  CategoryButton(label: '국가장학금'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterScholarships, // 입력값이 바뀔 때마다 필터 실행
              decoration: InputDecoration(
                hintText: '검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const Divider(
            color: Color(0xFF081F5C), // 검색창 아래의 선 색상
            thickness: 1, // 선 두께
            height: 1, // 선 간격 최소화
          ),
          Expanded(
            child: Container(
              color: Colors.white, // 리스트 영역 흰색
              child: ListView.separated(
                itemCount: filteredScholarships.length + 1, // 마지막 선을 추가하기 위해 +1
                itemBuilder: (context, index) {
                  if (index < filteredScholarships.length) {
                    return ListTile(
                      title: Text(
                        filteredScholarships[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScholarshipDetailPage(
                            scholarshipName: filteredScholarships[index],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink(); // 마지막 추가 구분선 위한 빈 공간
                  }
                },
                separatorBuilder: (context, index) {
                  if (index == filteredScholarships.length - 1) {
                    return const Divider(
                      color: Color(0xFF081F5C), // 마지막 구분선 색상
                      thickness: 1, // 선 두께
                      height: 1, // 간격 최소화
                    );
                  } else {
                    return const Divider(
                      color: Color(0xFF081F5C), // 일반 구분선 색상
                      thickness: 1,
                      height: 1,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 카테고리 버튼도 const 생성자 선언
class CategoryButton extends StatelessWidget {
  final String label;

  const CategoryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0x00f4f4fe).withOpacity(0.9), // 버튼 배경색
          side: const BorderSide(
            color: Color(0xFF081F5C), // 버튼 테두리 색상
            width: 1.5, // 테두리 두께
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 둥근 테두리
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 패딩 조정
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black, // 버튼 텍스트 색상
            fontSize: 14, // 텍스트 크기
            fontWeight: FontWeight.w500, // 텍스트 굵기
          ),
        ),
      ),
    );
  }
}

/// 상세 페이지도 const 생성자 선언
class ScholarshipDetailPage extends StatelessWidget {
  final String scholarshipName;

  const ScholarshipDetailPage({super.key, required this.scholarshipName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 상세 페이지 배경 흰색으로 설정
      appBar: AppBar(
        title: Text(scholarshipName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white, // AppBar 배경도 흰색으로 설정
        elevation: 0, // 그림자 제거
      ),
      body: Center(
        child: Text(
          '$scholarshipName 상세 정보',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
