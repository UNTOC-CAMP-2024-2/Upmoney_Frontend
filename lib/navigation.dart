import 'package:flutter/material.dart';
import 'package:flutter_application_3/pages/household.dart';
import 'pages/pay.dart';
import 'pages/household.dart';
import 'pages/scholarship.dart';
import 'pages/my.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectIndex = 0;


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
            if (value == 2) { // "+" 아이콘 클릭 시
              final newEntry = await showDialog<Map<String, String>?>(
                context: context,
                builder: (context) => const CustomDialog(),
              );

              if (newEntry != null && (newEntry['type'] == 'income' || newEntry['type'] == 'consumption')) {
                setState(() {
                  DateTime today = DateTime.now();
                  today = DateTime(today.year, today.month, today.day);
                  if (!HouseholdPageState.entries[today]!.any((entry) =>
                    entry['type'] == newEntry['type'] &&
                    entry['title'] == newEntry['title'] &&
                    entry['amount'] == newEntry['amount'])) {
                  HouseholdPageState.entries[today]?.add(newEntry);
                }
                });
              }
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
          children: const [
            PayPage(),
            HouseholdPage(),
            PayPage(),
            ScholarshipPage(),
            MyPage(),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({super.key});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final FocusNode _textFieldFocusNode2 = FocusNode();
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;
  bool checkboxValue6 = false;
  String? selectedButton;

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
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
                                controller: _textController2,
                                focusNode: _textFieldFocusNode2,
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
                                controller: _textController,
                                focusNode: _textFieldFocusNode,
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
                }),
                _buildCheckboxWithText(-0.86, 0.50, checkboxValue2, '교육',
                    (newValue) {
                  setState(() => checkboxValue2 = newValue!);
                }),
                _buildCheckboxWithText(-0.86, 0.78, checkboxValue3, '저축',
                    (newValue) {
                  setState(() => checkboxValue3 = newValue!);
                }),
                _buildCheckboxWithText(0.23, 0.25, checkboxValue4, '취미, 여가',
                    (newValue) {
                  setState(() => checkboxValue4 = newValue!);
                }),
                _buildCheckboxWithText(0.03, 0.50, checkboxValue5, '교통',
                    (newValue) {
                  setState(() => checkboxValue5 = newValue!);
                }),
                _buildCheckboxWithText(0.03, 0.78, checkboxValue6, '기타', 
                    (newValue) {
                  setState(() => checkboxValue6 = newValue!);
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
                        onPressed: () {
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
                          if (_textController2.text.isEmpty || _textController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('제목과 금액을 모두 입력해주세요!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return; // 다이얼로그 닫지 않음
                          }

                          // 데이터 저장 로직
                          DateTime today = DateTime.now();
                          today = DateTime(today.year, today.month, today.day); // 시간 제거

                          if (!HouseholdPageState.entries.containsKey(today)) {
                            HouseholdPageState.entries[today] = [];
                          }

                          // 중복 데이터 확인
                          if (!HouseholdPageState.entries[today]!.any((entry) =>
                              entry['type'] == selectedButton &&
                              entry['title'] == _textController2.text &&
                              entry['amount'] == _textController.text)) {
                            HouseholdPageState.entries[today]?.add({
                              'type': selectedButton!,
                              'title': _textController2.text,
                              'amount': _textController.text,
                            });
                          }

                          // 다이얼로그 닫기
                          Navigator.pop(context, {
                            'type': selectedButton!,
                            'title': _textController2.text,
                            'amount': _textController.text,
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
