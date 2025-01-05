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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TableCalendar(
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
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, day) {
            String formattedHeader = '${_monthName(day.month)} ${day.year}';
            return Column(
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
            );
          },
        ),
      ),
    );
  }


  void _showCustomDialog(BuildContext context, DateTime selectedDay) {
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
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
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
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
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
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
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
} 
