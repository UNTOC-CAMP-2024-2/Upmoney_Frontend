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
    final amounts = [2300000.0, 20000.0, 21000.0, 50000.0, 2200000.0, 70000.0];
    final total = amounts.reduce((a, b) => a + b);
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
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  style: TextStyle(
                    color: Color.fromARGB(218, 13, 40, 121),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LegendItem(
                            color: const Color(0xFFED6D4A),
                            title: '등록금',
                            amount: amounts[0].toStringAsFixed(0),
                          ),
                          LegendItem(
                            color: const Color(0xFF9FC3B2),
                            title: '취미, 여가',
                            amount: amounts[1].toStringAsFixed(0),
                          ),
                          LegendItem(
                            color: const Color(0xFFF9CF64),
                            title: '교육',
                            amount: amounts[2].toStringAsFixed(0),
                          ),
                          LegendItem(
                            color: const Color(0xFFF5F1E0),
                            title: '저축',
                            amount: amounts[3].toStringAsFixed(0),
                          ),
                          LegendItem(
                            color: const Color(0xFFD9E9A3),
                            title: '교통',
                            amount: amounts[4].toStringAsFixed(0),
                          ),
                          LegendItem(
                            color: const Color(0xFFA1CA7A),
                            title: '기타',
                            amount: amounts[5].toStringAsFixed(0),
                          ),
                        ],
                      ),
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
    final formattedAmount = amount.replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 94, 94, 94),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  formattedAmount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 94, 94, 94),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0.5),
                  height: 2,
                  width: formattedAmount.length * 10.0,
                  color: const Color.fromARGB(255, 94, 94, 94),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
