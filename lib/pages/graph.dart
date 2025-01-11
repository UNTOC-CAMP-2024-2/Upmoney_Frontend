import 'package:flutter/material.dart';
import 'dart:math';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    // 각 항목의 금액 정의 (6개 항목)
    final amounts = [2300000.0, 20000.0, 21000.0, 50000.0, 2200000.0, 70000.0];
    final total = amounts.reduce((a, b) => a + b); // 총액 계산
    // 각 금액의 비율을 계산하여 percentages 리스트 생성
    final percentages =
        amounts.map((amount) => (amount / total) * 100).toList();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: const Color.fromARGB(218, 13, 40, 121),
                iconSize: 30,
                onPressed: () {
                  Navigator.of(context).pop(); // 이전 페이지로 이동
                },
              ),
              const SizedBox(width: 10), // 버튼과 로고 사이 간격
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'UPmoney',
                  style: TextStyle(
                    color: Color.fromARGB(218, 13, 40, 121),
                    fontWeight: FontWeight.bold,
                    fontSize: 24, // 로고 크기
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Center(
                child: DonutChart(
                  percentages: percentages,
                  colors: const [
                    Color(0xFFED6D4A), // 등록금
                    Color(0xFF9FC3B2), // 취미, 여가
                    Color(0xFFF9CF64), // 교육
                    Color(0xFFF5F1E0), // 저축
                    Color(0xFFD9E9A3), // 교통
                    Color(0xFFA1CA7A), // 기타
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
                      color: const Color(0xFFED6D4A), // 등록금
                      title: '등록금',
                      amount: '${amounts[0].toStringAsFixed(0)}원',
                    ),
                    LegendItem(
                      color: const Color(0xFF9FC3B2), // 취미, 여가
                      title: '취미, 여가',
                      amount: '${amounts[1].toStringAsFixed(0)}원',
                    ),
                    LegendItem(
                      color: const Color(0xFFF9CF64), // 교육
                      title: '교육',
                      amount: '${amounts[2].toStringAsFixed(0)}원',
                    ),
                    LegendItem(
                      color: const Color(0xFFF5F1E0), // 저축
                      title: '저축',
                      amount: '${amounts[3].toStringAsFixed(0)}원',
                    ),
                    LegendItem(
                      color: const Color(0xFFD9E9A3), // 교통
                      title: '교통',
                      amount: '${amounts[4].toStringAsFixed(0)}원',
                    ),
                    LegendItem(
                      color: const Color(0xFFA1CA7A), // 기타
                      title: '기타',
                      amount: '${amounts[5].toStringAsFixed(0)}원',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 기존 DonutChart, DonutChartPainter, LegendItem 클래스는 그대로 유지

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

  DonutChartPainter({required this.percentages, required this.colors});

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
      size.width / 3.0, // 작은 원의 반지름 비율 (조정된 값)
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 20.4, // 기존 12 * 1.7
                height: 20.4, // 기존 12 * 1.7
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // 세미볼드 적용
                  color: Color.fromARGB(255, 94, 94, 94),
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500, // 세미볼드 적용
              color: Color.fromARGB(255, 94, 94, 94),
            ),
          ),
        ],
      ),
    );
  }
}
