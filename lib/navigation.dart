import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/household.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/pay.dart';
import 'pages/graph.dart';
import 'pages/household.dart';
import 'pages/scholarship.dart';
import 'pages/my.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectIndex = 0;
  final GlobalKey<PayPageState> payPageKey = GlobalKey<PayPageState>();
  final GlobalKey<GraphPageState> graphPageKey = GlobalKey<GraphPageState>();
  final GlobalKey<HouseholdPageState> householdPageKey = GlobalKey<HouseholdPageState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          backgroundColor: const Color(0xFFFFFF),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                  color: Color.fromARGB(255, 46, 43, 43));
            }
            return const IconThemeData(color: Color(0xFF081F5C));
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectIndex,
          onDestinationSelected: (value) async {
            if (value == 0) { // 소비페이지 버튼 클릭
              // 소비페이지 새로고침
              payPageKey.currentState?.refreshData();
            }
            if (value == 2) { // "+" 아이콘 클릭 시
              showDialog(
                context: context,
                builder: (context) => CustomDialog(
                  onRefresh: () {
                    // 새로고침 콜백
                    payPageKey.currentState?.refreshData();
                    graphPageKey.currentState?.refreshData();
                    householdPageKey.currentState?.refreshData();
                  },
                ),
              );
              
            } else {
              setState(() {
                selectIndex = value;
              });
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.attach_money_rounded, size: 40),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month, size: 40),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline, size: 40),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.school, size: 40),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle, size: 40),
              label: "",
            ),
          ],
        ),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.monetization_on, 
            ),
            const SizedBox(width: 8), // 아이콘과 텍스트 사이 간격
            const Text("UpMoney"),
          ],
        ),
      ),

      body: Center(
        child: IndexedStack(
          index: selectIndex,
          children: [
            PayPage(key: payPageKey),
            HouseholdPage(key: householdPageKey),
            GraphPage(key: graphPageKey, onBack: () => setState(() {})),
            ScholarshipPage(),
            MyPage(),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final VoidCallback onRefresh;

  const CustomDialog({Key? key, required this.onRefresh}) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController description = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode descriptionFocusNode2 = FocusNode();
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;
  bool checkboxValue6 = false;
  String? selectedButton;
  int category = 0;

  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }




  @override
  void dispose() {
    amount.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 300,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: const AlignmentDirectional(-1, -1),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                  child: Container(
                    width: 200,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue[100], // 배경색
                      borderRadius: BorderRadius.circular(12), // 둥근 모서리
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedButton = 'consumption';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: selectedButton == 'consumption'
                                ? Color(0xFF87CEEB)
                                : Colors.blue[100],
                              shadowColor: Colors.transparent, // 그림자 제거
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(
                              '소비',
                              style: TextStyle(
                                color: Colors.white, // 텍스트 색상
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 3, // 구분선 두께
                          color: Colors.white, // 구분선 색상
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedButton = 'income';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: selectedButton == 'income'
                              ? Color(0xFF87CEEB)
                              : Colors.blue[100],
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Text(
                              '소득',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),  
                Align(
                  alignment: const AlignmentDirectional(-0.19, -0.43),
                  child: Container(
                    width: 275,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF001A72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        const Align(
                          alignment: AlignmentDirectional(-0.93, -0.5),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
                            child: Text(
                              '제목 :',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-0.45, -0.5),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              55, 0, 10, 10),
                            child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: description,
                                focusNode: descriptionFocusNode2,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF001A72),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF001A72),
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                cursorColor: Colors.white,
                              ),
                              ),
                            ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-0.45, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                60, 55, 0, 10),
                            child: SizedBox(
                              width: 130,
                              child: TextFormField(
                                controller: amount,
                                focusNode: amountFocusNode,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: '( 금액 입력 )',
                                  hintStyle:
                                      const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF001A72),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFF001A72),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                cursorColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Align(
                          alignment: AlignmentDirectional(0.85, -0.24),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 50, 5, 5),
                            child: Text(
                              '원',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCheckboxWithText(-0.86, 0.25, checkboxValue1, '식비',
                    (newValue) {
                  setState(() => checkboxValue1 = newValue!);
                  if (checkboxValue1) {
                    category = 1;
                  }
                }),
                _buildCheckboxWithText(-0.86, 0.50, checkboxValue2, '교육',
                    (newValue) {
                  setState(() => checkboxValue2 = newValue!);
                  if (checkboxValue2) {
                    category = 2;
                  }
                }),
                _buildCheckboxWithText(-0.86, 0.78, checkboxValue3, '저축',
                    (newValue) {
                  setState(() => checkboxValue3 = newValue!);
                  if (checkboxValue3) {
                    category = 3;
                  }
                }),
                _buildCheckboxWithText(0.23, 0.25, checkboxValue4, '취미, 여가',
                    (newValue) {
                  setState(() => checkboxValue4 = newValue!);
                  if (checkboxValue4) {
                    category = 4;
                  }
                }),
                _buildCheckboxWithText(0.03, 0.50, checkboxValue5, '교통',
                    (newValue) {
                  setState(() => checkboxValue5 = newValue!);
                  if (checkboxValue5) {
                    category = 5;
                  }
                }),
                _buildCheckboxWithText(0.03, 0.78, checkboxValue6, '기타', 
                    (newValue) {
                  setState(() => checkboxValue6 = newValue!);
                  if (checkboxValue6) {
                    category = 6;
                  }
                }),
                Align(
                  alignment: AlignmentDirectional(1, 1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      10, 100, 5, 0),                      
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color(0xFF6F7DF7),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          )
                        ),
                        onPressed: () async {
                          // 소득/소비 선택 여부 확인
                          if (selectedButton == null || (selectedButton != 'income' && selectedButton != 'consumption')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('소득 또는 소비를 선택해주세요!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // 다이얼로그 닫지 않음
                          }

                          // 제목과 금액 입력 여부 확인
                          if (description.text.isEmpty || amount.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('제목과 금액을 모두 입력해주세요!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // 다이얼로그 닫지 않음
                          }
                          if (selectedButton == 'income') {
                            category = 0;
                          } 
                        
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
                          final url = Uri.parse('http://34.47.105.208:8000/consumption/consumption').replace(
                            queryParameters: {
                              'token':token,
                            },
                          );

                          final headers = {
                            'Content-Type': 'application/json',
                          };

                          final body = json.encode({
                            'description': description.text.trim(),
                            'amount': int.tryParse(amount.text) ?? 0,
                            'category': category,
                          });

                          try {
                            final response = await http.post(url, headers: headers, body: body);

                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('데이터가 성공적으로 저장되었습니다!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              print('Error: ${response.body}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('서버 오류가 발생했습니다: ${response.body}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            print('Network Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('네트워크 오류가 발생했습니다.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          // 다이얼로그 닫기
                          widget.onRefresh();
                          Navigator.pop(context, {
                            'type': selectedButton!,
                            'title': description.text,
                            'amount': amount.text,
                          });

                          

                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                          ),
                        ),
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

  Widget _buildCheckboxWithText(double x, double y, bool value, String label,
      ValueChanged<bool?> onChanged) {
    return Align(
      alignment: AlignmentDirectional(x, y),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            side: const BorderSide(width: 2, color: Colors.grey),
            activeColor: Colors.blue,
            checkColor: Colors.white,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                letterSpacing: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
