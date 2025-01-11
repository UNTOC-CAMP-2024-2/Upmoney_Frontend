import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/graph.dart';

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  String selectedOption = '식비';
  String imagePath = 'assets/images/meal.png';

  final Map<String, Map<String, dynamic>> dataOptions = {
    '식비': {
      'text1': '식비',
      'text2': '1,000,000',
      'image': 'assets/images/meal.png'
    },
    '여가': {
      'text1': '여가',
      'text2': '2,000,000',
      'image': 'assets/images/relax.png'
    },
    '쇼핑': {
      'text1': '쇼핑',
      'text2': '3,000,000',
      'image': 'assets/images/shopping.png'
    },
    '교통': {
      'text1': '교통',
      'text2': '4,000,000',
      'image': 'assets/images/vehicle.png'
    },
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(40, 20, 40, 0),
                  child: SizedBox(
                    height: 328,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Container(
                            width: 313,
                            height: 328,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(221, 227, 255, 1.0),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0,
                                    2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, -0.3),
                          child: Image.asset(
                            dataOptions[selectedOption]!['image'],
                            width: 180,
                            height: 180,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 15, 175, 0),
                            child: Container(
                              width: 106,
                              height: 30,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(221, 227, 255, 1.0),
                                borderRadius: BorderRadius.circular(1000),
                                border: Border.all(
                                  color:
                                      const Color.fromRGBO(88, 134, 186, 1.0),
                                ),
                              ),
                              child: DropdownButton(
                                value: selectedOption,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down_rounded,
                                    color: Color.fromRGBO(0, 26, 114, 1.0)),
                                underline: const SizedBox(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                dropdownColor:
                                    const Color.fromRGBO(221, 227, 255, 1.0),
                                items: dataOptions.keys.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0.87),
                          child: Container(
                            width: 271,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(234, 238, 255, 70),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, -1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                250, 20, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const GraphPage()),
                                );
                              },
                              child: const Icon(
                                Icons.navigate_next,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0, 0.8),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(35, 0, 0, 0),
                            child: Text(
                              '에서 20대 남성보다\n         원 더 소비했어요 !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(30, 18, 74, 1.0),
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0.65),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 150, 0),
                            child: Text(
                              dataOptions[selectedOption]!['text1'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromRGBO(236, 80, 93, 1.0),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0.83),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 155, 0),
                            child: Text(
                              dataOptions[selectedOption]!['text2'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromRGBO(236, 80, 93, 1.0),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 40, 215, 18),
                    child: Text(
                      '지출 내역',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 40, 0),
                  child: SizedBox(
                    height: 136,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Container(
                            width: 313,
                            height: 136,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F5FF),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0,
                                    2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0, -0.79),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 195, 0),
                            child: Text(
                              'UNTOC_MT',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 1),
                          child: Container(
                            width: 313,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0, -0.41),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(35, 0, 0, 0),
                            child: Text(
                              '45,000',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0, -0.33),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(220, 0, 0, 0),
                            child: Text(
                              '원',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0, 0.84),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 165, 0),
                            child: Text(
                              '여가, 취미',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 40, 175, 18),
                    child: Text(
                      '최근 재정 내역',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              40, 0, 10, 60),
                          child: SizedBox(
                            width: 117,
                            height: 112,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Container(
                                    width: 117,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF081F5C),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 1),
                                  child: Container(
                                    width: 117,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Color(0xCCFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, -0.8),
                                  child: Text(
                                    'UNTOC',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.08, -0.2),
                                  child: Text(
                                    '20,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(0.9, -0.2),
                                  child: Text(
                                    '원',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, 0.79),
                                  child: Text(
                                    '유흥, 여가',
                                    style: TextStyle(
                                      color: Color.fromRGBO(118, 118, 118, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 60),
                          child: SizedBox(
                            width: 117,
                            height: 112,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Container(
                                    width: 117,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF081F5C),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 1),
                                  child: Container(
                                    width: 117,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Color(0xCCFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, -0.8),
                                  child: Text(
                                    '부산대학교',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.08, -0.2),
                                  child: Text(
                                    '21,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(0.9, -0.2),
                                  child: Text(
                                    '원',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, 0.79),
                                  child: Text(
                                    '교육',
                                    style: TextStyle(
                                      color: Color.fromRGBO(118, 118, 118, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 60),
                          child: SizedBox(
                            width: 117,
                            height: 112,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Container(
                                    width: 117,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEC505D),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 1),
                                  child: Container(
                                    width: 117,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Color(0xCCFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, -0.8),
                                  child: Text(
                                    'UNTOC',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.08, -0.2),
                                  child: Text(
                                    '20,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(0.9, -0.2),
                                  child: Text(
                                    '원',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, 0.79),
                                  child: Text(
                                    '유흥, 여가',
                                    style: TextStyle(
                                      color: Color.fromRGBO(118, 118, 118, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 60),
                          child: SizedBox(
                            width: 117,
                            height: 112,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Container(
                                    width: 117,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF081F5C),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 1),
                                  child: Container(
                                    width: 117,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Color(0xCCFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, -0.8),
                                  child: Text(
                                    'UNTOC',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.08, -0.2),
                                  child: Text(
                                    '20,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(0.9, -0.2),
                                  child: Text(
                                    '원',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, 0.79),
                                  child: Text(
                                    '유흥, 여가',
                                    style: TextStyle(
                                      color: Color.fromRGBO(118, 118, 118, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 40, 60),
                          child: SizedBox(
                            width: 117,
                            height: 112,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Container(
                                    width: 117,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF081F5C),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0,
                                            2,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const AlignmentDirectional(0, 1),
                                  child: Container(
                                    width: 117,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Color(0xCCFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, -0.8),
                                  child: Text(
                                    'UNTOC',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.08, -0.2),
                                  child: Text(
                                    '20,000',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(0.9, -0.2),
                                  child: Text(
                                    '원',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(-0.69, 0.79),
                                  child: Text(
                                    '유흥, 여가',
                                    style: TextStyle(
                                      color: Color.fromRGBO(118, 118, 118, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
