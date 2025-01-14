import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// webview_flutter 4.2.1용
import 'package:webview_flutter/webview_flutter.dart';

///
/// 장학금 데이터 모델
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

///
/// ScholarshipPage: (HomePage를 감싸는 용도)
///
class ScholarshipPage extends StatelessWidget {
  const ScholarshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

///
/// ❶ HomePage: StatefulWidget
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

  bool isLoading = false; // 로딩 중 여부
  String? errorMessage; // 오류 메시지

  /// 검색어
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchScholarships1(); // 앱 시작 시 PNU(1) 장학금 먼저 로딩
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
      // 상단 AppBar
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // 1) PNU 버튼
                CategoryButton(
                  label: 'PNU',
                  onPressed: fetchScholarships1,
                ),
                // 2) PNU_CSE 버튼
                CategoryButton(
                  label: 'PNU_CSE',
                  onPressed: fetchScholarships2,
                ),
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
                height: 80.0, // 항목별 높이
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
                    // WebViewPage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WebViewPage(url: scholarship.link),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // (중요) 장학금 이름을 SingleChildScrollView로 감싸기
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              scholarship.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
          )),
        ],
      ),
    );
  }
}

///
/// CategoryButton: PNU / PNU_CSE 버튼
///
class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

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
/// 상세 페이지 (원본 그대로, 미사용이지만 "삭제하지 않음")
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$scholarshipName 상세 정보\n\n링크: $link',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // 앱 내부 WebView로 링크 열기
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(url: link),
                  ),
                );
              },
              child: const Text("앱 내부에서 링크 열기"),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// WebViewPage: 앱 내부 브라우저 (webview_flutter: ^4.2.1 대응)
///
class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  /// WebViewController (4.2.1 버전용)
  late final WebViewController _controller;

  bool _isLoading = true; // 웹뷰 로딩 상태

  @override
  void initState() {
    super.initState();
    // 컨트롤러 초기화
    _controller = WebViewController()
      // 자바스크립트 모드 설정
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // 페이지 로드 상황을 받아서 로딩 인디케이터 제어
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          // 필요 시: onNavigationRequest, onWebResourceError 등 추가 가능
        ),
      )
      // 실제 페이지 로드
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(
        children: [
          // 4.2.1 이상에서는 WebView 대신 WebViewWidget 사용
          WebViewWidget(controller: _controller),
          // 로딩 인디케이터
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
