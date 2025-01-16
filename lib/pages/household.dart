import 'package:flutter/material.dart';
import 'package:flutter_application_3/navigation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pay.dart';


class HouseholdPage extends StatefulWidget { // 추가
  const HouseholdPage({super.key}); // 추가

  @override
  State<HouseholdPage> createState() => HouseholdPageState();
}

class HouseholdPageState extends State<HouseholdPage> {
  final GlobalKey<PayPageState> payPageKey = GlobalKey<PayPageState>();
  void refreshData() {
    setState((){
      _fetchAllData();
    });
  }

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  static Map<DateTime, List<Map<String, String>>> entries = {};
  Map<DateTime, TextEditingController> _amountControllers = {};
  Map<DateTime, TextEditingController> _descriptionControllers = {}; 
  final TextEditingController _overlayController = TextEditingController();
  bool _showButtons = false; 
  final List<String> _buttonLabels = ['식비', '교육', '쇼핑', '취미', '교통', '기타'];
  Map<DateTime, Map<String, int>> dailyData = {};



  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  @override
  void dispose() {
    _amountControllers.values.forEach((controller) => controller.dispose());
    _descriptionControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _fetchAllData() async {
    final token = await getToken();
    
    final url = Uri.parse('http://34.47.105.208:8000/dateconsumption/dateconsumption').replace(
      queryParameters: {
        'token': token
      },
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodeData = utf8.decode(response.bodyBytes);
        final data = json.decode(decodeData);
        setState(() {
          dailyData = {
            for (var item in data)
            DateTime.parse(item['date']): {
              'total_income': item['total_income'],
              'total_consumption': item['total_consumption'],
            }
          };
        });
      } else {
        print('Error: ${response.body}');
      }
    } catch(e) {
      print('Network Error: $e');
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Center(
        child: Container(
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
                color: Color(0xFFD9EFFF),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
                todayBuilder: (context, date, _) {
                final normalizedDate = DateTime(date.year, date.month, date.day);
                if (dailyData.containsKey(normalizedDate)) {
                  final data = dailyData[normalizedDate]!;
                  return Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${date.day}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                        ),
                        if (data != null) ...[
                          if (data['total_income'] != 0)
                             Text('+${data['total_income']}',
                            style: TextStyle(fontSize: 10, color: Colors.red),
                            ),
                          if (data['total_consumption'] != 0)
                            Text('-${data['total_consumption']}',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                            ),
                        ],
                      ],
                    ),
                  );
                }
              },
              defaultBuilder: (context, date, _) {
                final normalizedDate = DateTime(date.year, date.month, date.day);
                if (dailyData.containsKey(normalizedDate)) {
                  final data = dailyData[normalizedDate]!;
                  return Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Text('${date.day}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        if (data != null) ...[
                          if (data['total_income'] != 0)
                             Text('+${data['total_income']}',
                            style: TextStyle(fontSize: 10, color: Colors.red),
                            ),
                          if (data['total_consumption'] != 0)
                            Text('-${data['total_consumption']}',
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                            ),
                        ],
                      ],
                    ),
                  );
                }
              },
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
      final decodedData = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedData);
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
                          return GestureDetector( 
                            onTap: () {
                              _showKeyboardOverlay(
                                context,
                                entry['id']!, 
                                entry, 
                                );
                            },
                            child: Padding(padding: EdgeInsets.only(left: 30),   
                            child: Container(
                            width: 300,
                            height: 58,
                            decoration: BoxDecoration(
                            color: entry['category'] == '0' ? Color(0xFFFFD9D9) : Color(0xFFD9EFFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Padding(padding: EdgeInsetsDirectional.fromSTEB(50, 8, 0, 0),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                                  child: Container(
                                    child: Text(
                                      '${entry['amount'] ?? '0'}원',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-1.02, 0),
                                child: Container(
                                  width: 14,
                                  height: 58,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: entry['category'] == '0' ? Color(0xFFFF5C5C) : Color(0xFF407BFF),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(0),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                    )
                                  ),
                                ),
                              ),  
                            ],
                          ),
                        ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
  }


  void _showKeyboardOverlay(BuildContext context, String id, Map<String, String> entry,) async {
    _overlayController.text = entry['amount']!;
    final descriptionController = TextEditingController(text: entry['description'] ?? '');
    final token = await getToken();
    int category = 0;
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
                            '금액입력',
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
                              onChanged: (value) {
                                entry['amount'] = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '내용 입력',
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
                            controller: descriptionController,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: '내용 입력',
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
                            onChanged: (value) {
                              entry['description'] = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                   Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.category_rounded, size: 35, color: Color(0xFFFA4F60)),
                        onPressed: () {
                          modalSetState(() {
                            _showButtons = !_showButtons;
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      if (_showButtons)
                        Expanded(
                          child: Container(
                            width: 600,
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _buttonLabels.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_buttonLabels[index] == '식비') {
                                        entry['category'] = '1';
                                      } else if (_buttonLabels[index] == '교육'){
                                        entry['category'] = '2';
                                      } else if (_buttonLabels[index] == '쇼핑') {
                                        entry['category'] = '3';
                                      } else if (_buttonLabels[index] == '취미') {
                                        entry['category'] = '4';
                                      } else if (_buttonLabels[index] == '교통') {
                                        entry['category'] = '5';
                                      } else if (_buttonLabels[index] == '기타') {
                                        entry['category'] = '6';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      iconColor: Colors.white,
                                      minimumSize: const Size(70, 30),
                                    ),
                                    child: Text(
                                      _buttonLabels[index],
                                      style: const TextStyle(fontSize: 14, color: Color(0xFFFA4F60),fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                   ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Spacer(),
                    Align(
                      alignment: AlignmentDirectional(1.5, 0),
                      child: ElevatedButton(
                        onPressed:  () async {
                          final url = Uri.parse('http://34.47.105.208:8000/consumption/consumption/${entry['id']}').replace(
                            queryParameters: {
                              'token': token,
                            },
                          );
                          final response = await http.delete(url);
                          if (response.statusCode == 200) {
                            while (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                            refreshData(); // household.dart 새로고침
                            payPageKey.currentState?.refreshData(); // pay.dart 새로고침
                            print("PayPage refreshed!");

                            _showCustomDialog(context, _selectedDay);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('삭제되었습니다'),
                                backgroundColor: Colors.green)
                            );
                          }  
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFA4F60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.all(0),
                        ), 
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                    ),
                    SizedBox(width: 15,),
                    Align(
                      alignment: AlignmentDirectional(2.0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          final token = await getToken();
                          if (token == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('인증 토큰이 없습니다. 다시 로그인하세요.'),
                                backgroundColor: Colors.red,
                              ),  
                            );
                            return;
                          }
                          if (entry['id'] == null) {
                            print('Error: Consumption ID is null');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('잘못된 데이터입니다. 다시 시도하세요.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          final url = Uri.parse('http://34.47.105.208:8000/consumption/consumption/${entry['id']}').replace(
                            queryParameters: {
                              'token': token,
                            },
                          );

                          final headers = {
                            'Content-Type': 'application/json',
                          };

                          final body = json.encode({
                            'description': descriptionController.text.trim(),
                            'amount': int.parse(_overlayController.text),
                            'category': int.tryParse(entry['category']!) ?? 0,
                          });
                          print('Category being sent: ${entry['category']}');

                          try {
                          final response = await http.put(
                            url,
                            headers: headers,
                            body: body
                          );

                          if (response.statusCode == 200) {
                            setState(() {
                            entry['amount'] = int.parse(_overlayController.text).toString();
                            entry['description'] = descriptionController.text;

                          });
                          while (Navigator.canPop(context)) Navigator.pop(context);
                          refreshData(); // household.dart 새로고침
                          payPageKey.currentState?.refreshData(); // pay.dart 새로고침
                          
                          _showCustomDialog(context, _selectedDay);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('수정이 완료되었습니다'),
                              backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            print('Error: ${response.body}');
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('수정에 실패했습니다. 다시 시도하세요.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          }
                          } catch(e){
                            print('Network Error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('네트워크 오류가 발생했습니다. 다시 시도하세요.'),
                                backgroundColor: Colors.red,
                                ),
                            );
                          }
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

