import 'package:flutter/material.dart';

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
          backgroundColor: const Color(0xFF081F5C),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(
                  color: Color.fromARGB(255, 46, 43, 43));
            }
            return const IconThemeData(color: Colors.white);
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectIndex,
          onDestinationSelected: (value) => setState(() {
            if (value == 2) {
              showDialog(
                context: context,
                builder: (context) => const CustomDialog(),
              );
            } else {
              selectIndex = value;
            }
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.attach_money_rounded, size: 30),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month, size: 30),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline, size: 30),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.school, size: 30),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle, size: 30),
              label: "",
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("UpMoney"),
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
  final FocusNode _textFieldFocusNode = FocusNode();
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 10, 0, 0),
                  child: Text(
                    '소비 / 소득 입력',
                    style: TextStyle(
                      fontFamily: 'Inter Tight',
                      fontSize: 30,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.19, -0.43),
                  child: Container(
                    width: 275,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF001A72),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-0.45, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 10, 40, 10),
                            child: SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: _textController,
                                focusNode: _textFieldFocusNode,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: '금액 입력',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
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
                                  fontWeight: FontWeight.normal,
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
                                EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
                            child: Text(
                              '원',
                              style: TextStyle(
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
                _buildCheckboxWithText(-0.86, 0.08, checkboxValue1, '식비',
                    (newValue) {
                  setState(() => checkboxValue1 = newValue!);
                }),
                _buildCheckboxWithText(-0.86, 0.45, checkboxValue2, '교육',
                    (newValue) {
                  setState(() => checkboxValue2 = newValue!);
                }),
                _buildCheckboxWithText(-0.86, 0.78, checkboxValue3, '저축',
                    (newValue) {
                  setState(() => checkboxValue3 = newValue!);
                }),
                _buildCheckboxWithText(0.03, 0.08, checkboxValue4, '취미',
                    (newValue) {
                  setState(() => checkboxValue4 = newValue!);
                }),
                _buildCheckboxWithText(0.03, 0.45, checkboxValue5, '교통',
                    (newValue) {
                  setState(() => checkboxValue5 = newValue!);
                }),
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
}// ddddkdkd

