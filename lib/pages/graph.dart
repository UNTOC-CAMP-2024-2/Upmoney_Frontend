import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class GraphPage extends StatefulWidget {
  final VoidCallback onBack;

  const GraphPage({super.key, required this.onBack});

  @override
  GraphPageState createState() => GraphPageState();
}

class GraphPageState extends State<GraphPage> {
  void refreshData() {
    fetchCategoryTotals();
  }

  List<double> amounts = [0, 0, 0, 0, 0, 0];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    fetchCategoryTotals();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> fetchCategoryTotals() async {
    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('토큰이 없습니다. 다시 로그인하세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.parse('http://34.47.105.208:8000/totalcategory').replace(
      queryParameters: {
        'token': token,
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          amounts = List.generate(6, (index) {
            final categoryIndex = index + 1;
            final categoryData = data.firstWhere(
              (element) => element['category_id'] == categoryIndex,
              orElse: () => {'total_consumption': 0},
            );
            return categoryData['total_consumption'].toDouble();
          });
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching category totals: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final total = amounts.reduce((a, b) => a + b);
    final percentages =
        amounts.map((amount) => (amount / total) * 100).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await fetchCategoryTotals();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50), // 원그래프와 화면 상단 사이 간격 추가
                    Center(
                      child: DonutChart(
                        percentages: percentages,
                        colors: const [
                          Color(0xFFED6D4A),
                          Color(0xFF9FC3B2),
                          Color(0xFFF9CF64),
                          Color(0xFFF5F1E0),
                          Color(0xFFD9E9A3),
                          Color(0xFFA1CA7A),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Divider(
                      thickness: 1.5,
                      color: Color.fromARGB(255, 94, 94, 94),
                      indent: 32,
                      endIndent: 32,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LegendItem(
                            color: const Color(0xFFED6D4A),
                            title: '식비',
                            amount: formatWithCommas(amounts[0]),
                          ),
                          LegendItem(
                            color: const Color(0xFF9FC3B2),
                            title: '저축',
                            amount: formatWithCommas(amounts[1]),
                          ),
                          LegendItem(
                            color: const Color(0xFFF9CF64),
                            title: '여가',
                            amount: formatWithCommas(amounts[2]),
                          ),
                          LegendItem(
                            color: const Color(0xFFF5F1E0),
                            title: '교통',
                            amount: formatWithCommas(amounts[3]),
                          ),
                          LegendItem(
                            color: const Color(0xFFD9E9A3),
                            title: '교육',
                            amount: formatWithCommas(amounts[4]),
                          ),
                          LegendItem(
                            color: const Color(0xFFA1CA7A),
                            title: '기타',
                            amount: formatWithCommas(amounts[5]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromARGB(218, 13, 40, 121),
                iconSize: 30,
                onPressed: widget.onBack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatWithCommas(double value) {
    final parts = value.toStringAsFixed(0).split('');
    for (int i = parts.length - 3; i > 0; i -= 3) {
      parts.insert(i, ',');
    }
    return '${parts.join()}원';
  }
}

class DonutChart extends StatelessWidget {
  final List<double> percentages;
  final List<Color> colors;

  const DonutChart({
    super.key,
    required this.percentages,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(170, 170),
      painter: DonutChartPainter(percentages: percentages, colors: colors),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  DonutChartPainter({
    required this.percentages,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 60;

    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = 2 * pi * (percentages[i] / 100);
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }

    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3.0,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String title;
  final String amount;

  const LegendItem({
    super.key,
    required this.color,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF767676),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: amount.split('원')[0],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF767676),
                        ),
                        children: const [
                          TextSpan(
                            text: ' 원',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF767676),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
