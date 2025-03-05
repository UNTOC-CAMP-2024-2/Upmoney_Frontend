import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/graph.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  PayPageState createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  void refreshData() {
    print("PayPage refreshData called");
    fetchUserinfo();
    fetchDifference(dataOptions[selectedOption]!['classify_id']);
    fetchRecentConsumption();
    fetchMostRecentConsumption();
  }
  
  String selectedOption = '식비';
  String imagePath = 'assets/images/meal.png';

  final Map<String, Map<String, dynamic>> dataOptions = {
    '식비': {
      'text1': '식비',
      'text2': '',
      'image': 'assets/images/meal.png',
      'classify_id': 1,
    },
    '교육': {
      'text1': '교육',
      'text2': '',
      'image': 'assets/images/education.png',
      'classify_id': 2,
    },
    '쇼핑': {
      'text1': '쇼핑',
      'text2': '',
      'image': 'assets/images/shopping.png',
      'classify_id': 3,
    },
    '여가': {
      'text1': '여가',
      'text2': '',
      'image': 'assets/images/play.png',
      'classify_id': 4,
    },
    '교통': {
      'text1': '교통',
      'text2': '',
      'image': 'assets/images/vehicle.png',
      'classify_id': 5,
    },
  };

  bool showGraphPage = false;

  Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
  }

  Map<String, dynamic>? userData;
  String dynamictext = "";

  Future<void> fetchDifference(int classifyId) async {
    final token = await getToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('토큰이 없습니다. 다시 로그인하세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/averageconsumption/difference').replace(
                            queryParameters: {
                              'token':token,
                              'classify_id': '$classifyId',
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
          // text2를 차이값으로 업데이트
          if (userData!['gender'] == "male" && data['difference'] >= 0){
              dynamictext = "에서 20대 남성보다\n         원 더 소비했어요 !";
          } else if (userData!['gender'] == "male" && data['difference'] < 0){
              dynamictext = "에서 20대 남성보다\n         원 덜 소비했어요 !";
              data['difference'] *= -1;
          } else if (userData!['gender'] == "female" && data['difference'] >= 0){
              dynamictext = "에서 20대 여성보다\n         원 더 소비했어요 !";
          } else if (userData!['gender'] == "female" && data['difference'] < 0){
              dynamictext = "에서 20대 여성보다\n         원 덜 소비했어요 !";
              data['difference'] *= -1;
          }
          dataOptions[selectedOption]!['text2'] = data['difference'].toString();
        });
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching difference: $e');
    }
  }


  List<dynamic> fiveConsumptions = [];
  Map<String, dynamic>? recentConsumption;

  
  @override
  void initState() {
    super.initState();
    fetchUserinfo();
    fetchDifference(dataOptions[selectedOption]!['classify_id']);
    fetchRecentConsumption(); // PayPage 시작 시 최근 소비 데이터 가져오기
    fetchMostRecentConsumption();
  }
  

  Future<void> fetchRecentConsumption() async {
    final token = await getToken();
    print('Retrieved Token: $token'); // null이면 저장 과정에서 문제가 있음

    if (token == null) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('토큰이 없습니다. 다시 로그인하세요.'),
        backgroundColor: Colors.red,
      ),
     );
     return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/consumption/consumption/recent').replace(
                            queryParameters: {
                              'token':token,
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
        final decodedData = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedData);
        if (data.isNotEmpty) {
          setState(() { // 첫 번째 소비 데이터 사용
            fiveConsumptions = data;
          });
        }
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching recent consumption: $e');
    }
  }

  Future<void> fetchMostRecentConsumption() async {
    final token = await getToken();
    print('Retrieved Token: $token'); // null이면 저장 과정에서 문제가 있음

    if (token == null) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('토큰이 없습니다. 다시 로그인하세요.'),
        backgroundColor: Colors.red,
      ),
     );
     return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/consumption/consumption/most_recent_consumption').replace(
                            queryParameters: {
                              'token':token,
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
        final decodedData = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedData);
        if (data.isNotEmpty) {
          setState(() {
            recentConsumption = data; // 첫 번째 소비 데이터 사용
          });
        }
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching recent consumption: $e');
    }
  }

 

  Future<void> fetchUserinfo() async {
    final token = await getToken();
    print('Retrieved Token: $token'); // null이면 저장 과정에서 문제가 있음

    if (token == null) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('토큰이 없습니다. 다시 로그인하세요.'),
        backgroundColor: Colors.red,
      ),
     );
     return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/auth/userinfo').replace(
                            queryParameters: {
                              'token':token,
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
        final decodedData = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedData);
        if (data.isNotEmpty) {
          setState(() {
            userData = data;
          });
        }
      } else {
        throw Exception('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching recent consumption: $e');
    }
  }


  String mapCategoryToOption(int category) {
    // 카테고리 숫자를 문자열로 매핑
    switch (category) {
      case 0:
        return '소득';
      case 1:
        return '식비';
      case 2:
        return '교육';
      case 3:
        return '쇼핑';
      case 4:
        return '여가';
      case 5:
        return '교통';
      case 6:
        return '기타';
      default:
        return '카테고리안옴';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showGraphPage) {
      return GraphPage(onBack: () {
        setState(() {
          showGraphPage = false;
        });
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
        onRefresh: () async {
          // 새로고침 시 데이터 갱신
          await fetchUserinfo();
          await fetchDifference(dataOptions[selectedOption]!['classify_id']);
          await fetchRecentConsumption();
          await fetchMostRecentConsumption();
        },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                              color: const Color(0xFFDFE8FF),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(1000),
                                border: Border.all(
                                  color:
                                      const Color(0xFFDFE8FF),
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
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(15),
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
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    selectedOption = newValue!;
                                  });
                                  await fetchDifference(dataOptions[newValue]!['classify_id']);
                                },
                              ),
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
                                setState(() {
                                  showGraphPage = true;
                                });
                              },
                              child: const Icon(
                                Icons.navigate_next,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0, 0.8),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(35, 0, 0, 0),
                            child: Text(
                              dynamictext,
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
                          alignment: const AlignmentDirectional(0, 0.660),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 140, 0),
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
                          alignment: const AlignmentDirectional(0, 0.82),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 210, 0),
                            child: SizedBox(
                            width: 150,
                            child: Text(
                              dataOptions[selectedOption]!['text2'],
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color.fromRGBO(236, 80, 93, 1.0),
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
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
                              color: Colors.white,
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
                          alignment: const AlignmentDirectional(0, -0.79),
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                            child: SizedBox(
                            width: 250,
                            child: Text(
                              recentConsumption != null
                                  ? recentConsumption!['description']
                                  : '',
                              textAlign: TextAlign.left,
                              softWrap: false,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
                              color: Color(0xffDFE8FF),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, -0.3),
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                            child: Text(
                              recentConsumption != null
                                  ? '${recentConsumption!['amount']}'
                                  : '',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0, -0.23),
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
                        Align(
                          alignment: const AlignmentDirectional(0, 0.84),
                          child: Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(0, 0, 220, 0),
                            child: Text(
                              recentConsumption != null
                                  ? mapCategoryToOption(recentConsumption!['category'])
                                  : '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
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
                      children: List.generate(fiveConsumptions.length, (index) {
                        final consumption = fiveConsumptions[index];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              index == 0 ? 40 : 10, 0, index == fiveConsumptions.length - 1 ? 40 : 10, 60),
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
                                      color: consumption['category'] == 0 // 카테고리가 소득인지 확인
                                         ? const Color(0xFFFA787A) // 소득일 경우 색상
                                        : const Color(0xFF6F96F7),
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
                                Align(
                                  alignment: const AlignmentDirectional(-0.69, -0.8),
                                  child: Text(
                                    consumption['description'] ?? '없음',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-0.08, -0.15),
                                  child: Text(
                                    '${consumption['amount'] ?? 0}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: AlignmentDirectional(0.9, -0.15),
                                  child: Text(
                                    '원',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(-0.69, 0.79),
                                  child: Text(
                                    mapCategoryToOption(consumption['category']),
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
                        );
                      }).toList(),
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
