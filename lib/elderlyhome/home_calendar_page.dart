import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, bool> timeSlotStatus = {
    '9am - 10am': true,
    '10am - 11am': true,
    '11am - 12pm': true,
    '12pm - 1pm': true,
    '1pm - 2pm': true,
    '2pm - 3pm': true,
    '3pm - 4pm': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'CALENDAR',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFF21B2C5),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _showTimeSlotOptions(context);
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.teal.shade700, width: 2),
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        weekendTextStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitAvailability();
                    },
                    child: Text('Submit Availability'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeSlotOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: timeSlotStatus.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  String timeSlot = timeSlotStatus.keys.elementAt(index);
                  bool isEnabled = timeSlotStatus[timeSlot] ?? true;

                  return ListTile(
                    title: Text(timeSlot),
                    trailing: Switch(
                      value: isEnabled,
                      onChanged: (value) {
                        setState(() {
                          timeSlotStatus[timeSlot] = value;
                        });
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitAvailability() async {
    String date = DateFormat('yyyy-MM-dd').format(_selectedDay);
    Map<String, dynamic> data = {
      'date': date,
      'time_slots': timeSlotStatus,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2/donation_app/time_slots.php'), // Use 10.0.2.2 for Android Emulator
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time slots updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update time slots: ${responseData['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update time slots: Server error')),
      );
    }
  }
}
