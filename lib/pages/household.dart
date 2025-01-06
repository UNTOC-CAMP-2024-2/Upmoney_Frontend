import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final TextEditingController _expandController = TextEditingController();
  final TextEditingController _consume1Controller = TextEditingController();
  final TextEditingController _consume2Controller = TextEditingController();
  final TextEditingController _overlayController = TextEditingController();
  
  Map<DateTime, Map<String, dynamic>> _dayData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _showCustomDialog(context, selectedDay);
            },
            rowHeight: 80.0,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              tablePadding: const EdgeInsets.symmetric(vertical: 8.0), 
              cellMargin: const EdgeInsets.all(15.0),
              todayDecoration: BoxDecoration(
                color: Color(0xFFD9EFFF),
                shape: BoxShape.circle,
              )
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                String formattedHeader = '${_monthName(day.month)} ${day.year}';
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFD9EFFF),
                        shape: BoxShape.circle,
                      ),
                    ),                
                    Column(
                      children: [
                        Text(
                          formattedHeader,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1.5,
                        ),
                      ],
                    ),
                  ],
                );
              },
               todayBuilder: (context, day, focusedDay) {
                final data = _dayData[day] ?? {'expand' : 0, 'consume' : 0};
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    '${day.day}',
                    style: TextStyle(
                    fontSize: 16,)
                    ), 
                    if (data['expand'] != 0) 
                      Text(
                        '+${data['expand']}',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    if (data['consume'] != 0) 
                      Text(
                        '-${data['consume']}',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                  ],
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                final data = _dayData[day] ?? {'expand' : 0, 'consume' : 0};
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${day.day}', style: TextStyle(fontSize: 16)), 
                    if (data['expand'] != 0) 
                      Text(
                        '+${data['expand']}',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    if (data['consume'] != 0) 
                      Text(
                        '-${data['consume']}',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                  ],
                );
              },
            ),
          ),
      ),
    );
  }


  void _showCustomDialog(BuildContext context, DateTime selectedDay) {

  final data = _dayData[selectedDay] ?? {'expand': '', 'consume1': '', 'consume2': ''};

  _expandController.text = data['expand']?.toString() ?? '';
  _consume1Controller.text = data['consume1']?.toString() ?? '';
  _consume2Controller.text = data['consume2']?.toString() ?? '';

  _expandController.clear();
  _consume1Controller.clear();
  _consume2Controller.clear();
  
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), 
        ),
        child: Container(
          width: 400,
          height: 450,
          child: SingleChildScrollView( 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(17, 0, 0, 0),
                    child: Text(
                      '${selectedDay.month}월 ${selectedDay.day}일',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Text(
                          _todayText(selectedDay),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 10, 0, 0),
                        child: Container(
                          width: 340,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD9D9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(50, 15, 0, 0),
                                child: Text(
                                  '용돈',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.74, 0.09),
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(0, 0, 40, 0),
                                  child: Container(
                                    width: 150,
                                    child: TextFormField(
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      controller: _expandController,
                                      onTap: () {
                                        _showKeyboardOverlay(context,'용돈',_expandController);
                                      },
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: '금액',
                                        filled: true,
                                        fillColor: Color(0xFFFFD9D9),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.8, 0),
                                child: Text(
                                  '원',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1.02, 0),
                                child: Container(
                                  width: 14,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF5C5C),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 10, 0, 0),
                        child: Container(
                          width: 340,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9EFFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(50, 15, 0, 0),
                                child: Text(
                                  '소비',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.74, 0.09),
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(0, 0, 40, 0),
                                  child: Container(
                                    width: 150,
                                    child: TextFormField(
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      controller: _consume1Controller,
                                      onTap: (){
                                        _showKeyboardOverlay(context,'소비',_consume1Controller);
                                      },
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: '금액',
                                        filled: true,
                                        fillColor: Color(0xFFD9EFFF),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.8, 0),
                                child: Text(
                                  '원',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1.02, 0),
                                child: Container(
                                  width: 15,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF407BFF),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(15, 10, 0, 0),
                        child: Container(
                          width: 340,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9EFFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(50, 15, 0, 0),
                                child: Text(
                                  '소비',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.74, 0.09),
                                child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(0, 0, 40, 0),
                                  child: Container(
                                    width: 150,
                                    child: TextFormField(
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      controller: _consume2Controller,
                                      onTap: () {
                                        _showKeyboardOverlay(context,'소비',_consume2Controller);
                                      },
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: '금액',
                                        filled: true,
                                        fillColor: Color(0xFFD9EFFF),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.8, 0),
                                child: Text(
                                  '원',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1.02, 0),
                                child: Container(
                                  width: 15,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF407BFF),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _dayData.remove(_selectedDay);
                            _expandController.clear();
                            _consume1Controller.clear();
                            _consume2Controller.clear();
                          });
                          Navigator.of(context).pop();
                        }, 
                        child: Text(
                          '초기화',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); 
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          ),
                      ),
                      const SizedBox(width: 8.0),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            final currentExpand = _dayData[_selectedDay]?['expand'] ?? 0;
                            final currentConsume = _dayData[_selectedDay]?['consume'] ?? 0;

                            final newExpand = int.tryParse(_expandController.text) ?? 0;
                            final newConsume = (int.tryParse(_consume1Controller.text) ?? 0) +
                                (int.tryParse(_consume2Controller.text) ?? 0);

                            _dayData[_selectedDay] = {
                              'expand': currentExpand + newExpand,
                              'consume': currentConsume + newConsume, 
                            };
                            _expandController.clear();
                            _consume1Controller.clear();
                            _consume2Controller.clear();
                          });
                          Navigator.of(context).pop(); 
                        },
                        child: Text(
                          '저장',
                          style: TextStyle(
                            color: Colors.black
                          ),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}



  String _todayText(DateTime selectedDay) {
  final DateTime today = DateTime.now(); 
  final Duration difference = selectedDay.difference(
    DateTime(today.year, today.month, today.day),
  );

  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == -1) {
    return 'D-1';
  } else if (difference.inDays == 1) {
    return 'D+1'; 
  } else if (difference.inDays < 0) {
    return 'D${difference.inDays}'; 
  } else {
    return 'D+${difference.inDays}';
  }
}



  String  _monthName(int month){
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'Agust',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month-1];
  }


    void _showKeyboardOverlay(BuildContext context, String title, TextEditingController controller) {
    _overlayController.text = controller.text; 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, 
          ),
          child: Container(
            color: Color(0xFFFEF5F8),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: _overlayController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '금액 입력',
                            isDense: true,
                            filled: true,
                            fillColor: const Color(0xFFFEF5F8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),       
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  controller.text = _overlayController.text; 
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFA4F60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.all(0),
                              ),
                              child: const Icon(
                                Icons.telegram_rounded,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          } 
