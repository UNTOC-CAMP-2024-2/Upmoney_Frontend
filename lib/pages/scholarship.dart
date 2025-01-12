import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///
/// scholarship_model.dart
///
class Scholarship {
  final int id;
  final int pageId;
  final String name;
  final String link;

  Scholarship({
    required this.id,
    required this.pageId,
    required this.name,
    required this.link,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'],
      pageId: json['page_id'],
      name: json['name'],
      link: json['link'],
    );
  }
}

class ScholarshipPage extends StatelessWidget {
  const ScholarshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 원래 코드 유지
    return const HomePage();
  }
}

///
/// ❶ StatelessWidget -> StatefulWidget
///
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

///
/// ❷ 서버 통신 + 검색 로직
///
class _HomePageState extends State<HomePage> {
  /// 현재 보여줄 장학금 리스트
  List<Scholarship> scholarships = [];

  bool isLoading = false;
  String? errorMessage;

  /// 검색어
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchScholarships1(); // 시작 시 scholarship/1 (기존 장학금1) 먼저 로딩
  }

  /// scholarship/1 데이터 가져오기
  Future<void> fetchScholarships1() async {
    await _fetchScholarshipsFromUrl(
        'http://34.47.105.208:8000/scholarship/1?limit=15');
  }

  /// scholarship/2 데이터 가져오기
  Future<void> fetchScholarships2() async {
    await _fetchScholarshipsFromUrl(
        'http://34.47.105.208:8000/scholarship/2?limit=15');
  }

  /// 실제로 데이터를 받아와서 scholarships에 넣어주는 함수
  Future<void> _fetchScholarshipsFromUrl(String url) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = decoded['scholarships'];

        final loaded = items
            .map((item) => Scholarship.fromJson(item as Map<String, dynamic>))
            .toList();

        setState(() {
          scholarships = loaded;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = '서버 통신 실패(상태코드: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '오류 발생: $e';
        isLoading = false;
      });
    }
  }

  /// 검색어 필터
  List<Scholarship> get filteredScholarships {
    if (searchQuery.isEmpty) {
      return scholarships;
    } else {
      return scholarships
          .where((sch) => sch.name.contains(searchQuery))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 국가장학금 버튼은 제거, PNU/PNU_CSE 버튼만 남김
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // 1) PNU 버튼 → scholarship/1 데이터
                CategoryButton(
                  label: 'PNU',
                  onPressed: fetchScholarships1,
                ),
                // 2) PNU_CSE 버튼 → scholarship/2 데이터
                CategoryButton(
                  label: 'PNU_CSE',
                  onPressed: fetchScholarships2,
                ),
                // "국가장학금" 버튼은 삭제
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // 로딩/에러 표시
          if (isLoading) const LinearProgressIndicator(),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // 장학금 리스트 (검색 적용)
          Expanded(
            child: ListView.builder(
              itemCount: filteredScholarships.length,
              itemBuilder: (context, index) {
                final scholarship = filteredScholarships[index];
                return Container(
                  height: 80.0, // 고정 높이
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      // 상세 페이지 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScholarshipDetailPage(
                            scholarshipName: scholarship.name,
                            link: scholarship.link,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 장학금 이름
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            scholarship.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // 오른쪽 화살표 아이콘
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///
/// CategoryButton 수정:
/// - onPressed: () => ... 기능을 받도록 변경
///
class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // 새로 추가

  const CategoryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x00f4f4fe).withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color(0xFF081F5C),
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

///
/// 상세 페이지 (기존 코드 그대로)
///
class ScholarshipDetailPage extends StatelessWidget {
  final String scholarshipName;
  final String link;

  const ScholarshipDetailPage({
    super.key,
    required this.scholarshipName,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scholarshipName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(
          '$scholarshipName 상세 정보\n\n링크: $link',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
