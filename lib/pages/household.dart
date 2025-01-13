import 'package:flutter/material.dart';
import 'package:flutter_application_3/navigation.dart';
import 'package:table_calendar/table_calendar.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => HouseholdPageState();
}

class HouseholdPageState extends State<HouseholdPage> {

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  static Map<DateTime, List<Map<String, String>>> entries = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Container(
        width: 503,
        height: 600,
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: TableCalendar(
            focusedDay: _focusedDay, 
            firstDay: DateTime.utc(2024, 1, 1), 
            lastDay: DateTime.utc(2025, 12, 31),
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showCustomDialog(context, selectedDay);
            },
            rowHeight: 90,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              tablePadding: const EdgeInsets.symmetric(vertical: 8.0),
              cellMargin: const EdgeInsets.all(15.0),
              todayDecoration: BoxDecoration(
                color: Color(0xffd9efff),
                shape: BoxShape.circle,
              )
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder:(context, day) {
                String formattedHeader = '${_monthName(day.month)} ${day.year}';
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffd9eff),
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
                        )
                      ],
                    ),
                  ],
                );
              }
            ),
            ),
        ),
      ),
    );
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

  void _showCustomDialog(BuildContext context, DateTime selectedDay) async {
    DateTime today = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 400,
            height: 450,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                        ...?entries[today]?.map((entry) => Container(
                          decoration: BoxDecoration(
                            color: entry['type'] == 'income'
                            ? Colors.red
                            : Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Padding(padding: EdgeInsetsDirectional.fromSTEB(50, 15, 0, 0),
                              child: Text(
                                entry['type'] == 'income' ? '소득' : '소비',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.74, 0.09),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                  child: Container(
                                    width: 150,
                                    child: Text(
                                      entry['amount']!,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
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
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                  ],
                ),),
            ),
          ),
        );
      });
  }

  String _todayText(DateTime selectedDay) {
  final DateTime today = DateTime.now();
  final DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
  final DateTime selectedDayOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

  // 정확히 날짜만 비교
  if (selectedDayOnly == todayDateOnly) {
    return 'Today';
  } else if (selectedDayOnly.isBefore(todayDateOnly)) {
    final int daysDiff = todayDateOnly.difference(selectedDayOnly).inDays;
    return 'D-${daysDiff}';
  } else {
    final int daysDiff = selectedDayOnly.difference(todayDateOnly).inDays;
    return 'D+${daysDiff}';
  }
}
}