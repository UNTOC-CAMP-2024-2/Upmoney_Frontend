import 'package:flutter/material.dart';
import 'package:flutter_application_3/navigation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => HouseholdPageState();
}

class HouseholdPageState extends State<HouseholdPage> {

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  static Map<DateTime, List<Map<String, String>>> entries = {};
  Map<DateTime, TextEditingController> _amountControllers = {};
  final TextEditingController _overlayController = TextEditingController();
  bool _showButtons = false; 
  final List<String> _buttonLabels = ['식비', '교육', '저축', '취미, 여가', '교통', '기타'];


  @override
  void dispose() {
    _amountControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }


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

              DateTime today = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
              setState(() {
                if (!HouseholdPageState.entries.containsKey(today)) {
                  HouseholdPageState.entries[today] = [];
                }
              });

              _fetchDataForToday(today);

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
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _fetchDataForToday(DateTime today) async {
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

  final formattedDate = '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  final url = Uri.parse('http://34.47.105.208:8000/dateconsumption/dateconsumption/$formattedDate').replace(
    queryParameters: {
      'token': token,
    },
  );
  if (!HouseholdPageState.entries.containsKey(today)) {
        HouseholdPageState.entries[today] = [];
  }
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        HouseholdPageState.entries[today] = List<Map<String, String>>.from(data.map((item) => {
        'id': item['id'].toString(),
        'amount': item['amount'].toString(),
        'category': item['category'].toString(),
        'description': item['description'].toString(), 
        'created_at': item['created_at'].toString(), 
        }));
      });

      for (var entry in HouseholdPageState.entries[today]!) {
        final key = DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(entry['id']!),
        );
        if (!_amountControllers.containsKey(key)) {
          _amountControllers[key] = TextEditingController(
            text: entry['amount']
          );
        }
      }
    } else {
      print('Error: ${response.body}');
    }
  } catch (e) {
    print('Network Error: $e');
  }
}


  void _showCustomDialog(BuildContext context, DateTime selectedDay) async {
    DateTime today = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    await _fetchDataForToday(today);
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
                        ...?HouseholdPageState.entries[today]?.map((entry) {
                          final key = DateTime(
                            today.year,
                            today.month,
                            today.day,
                            int.parse(entry['id']!),
                          );
                          return  Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Padding(padding: EdgeInsetsDirectional.fromSTEB(50, 15, 0, 0),
                              child: Text(
                                entry['description']!,
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
                                    child: TextField(
                                      controller: _amountControllers[key],
                                      onTap: () {
                                        _showKeyboardOverlay(context, '금액입력', _amountControllers[key]!);
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: '금액입력',
                                      ),
                                      onChanged: (value) {
                                        entry['amount'] = value;
                                      }
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        }).toList(),
                      ],
                    ),
                  ],
                ),),
            ),
          ),
        );
      });
  }


  void _showKeyboardOverlay(BuildContext context, String title, TextEditingController controller) {
    _overlayController.text = controller.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                color: const Color(0xFFFEF5F8),
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
      },
    );
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

