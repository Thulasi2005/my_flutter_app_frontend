import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDay = DateTime.now();
  Map<String, bool> timeSlotAvailability = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'BOOK TIME SLOT',
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
        child: SingleChildScrollView(
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
                      child: CalendarDatePicker(
                        initialDate: _selectedDay,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        onDateChanged: (selectedDate) {
                          setState(() {
                            _selectedDay = selectedDate;
                          });
                          _fetchAvailableTimeSlots();
                        },
                      ),
                    ),
                    timeSlotAvailability.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Prevent ListView from scrolling
                      itemCount: timeSlotAvailability.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        String timeSlot = timeSlotAvailability.keys.elementAt(index);
                        bool isAvailable = timeSlotAvailability[timeSlot] ?? false;

                        return ListTile(
                          title: Text(timeSlot),
                          trailing: isAvailable
                              ? ElevatedButton(
                            onPressed: () {
                              _bookTimeSlot(timeSlot);
                            },
                            child: Text('Book'),
                          )
                              : Text('Unavailable',
                              style: TextStyle(color: Colors.red)),
                        );
                      },
                    )
                        : CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchAvailableTimeSlots() async {
    String date = DateFormat('yyyy-MM-dd').format(_selectedDay);

    final response = await http.get(
      Uri.parse('http://10.0.2.2/donation_app/get_time_slots.php?elderly_home_id=1&date=$date'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        timeSlotAvailability = {
          for (var slot in data['time_slots'])
            slot['time_slot']: slot['is_available'] == 1
        };
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch time slots')),
      );
    }
  }

  Future<void> _bookTimeSlot(String timeSlot) async {
    String date = DateFormat('yyyy-MM-dd').format(_selectedDay);
    Map<String, dynamic> data = {
      'donor_id': 1,  // Replace with the actual donor ID
      'elderly_home_id': 1,
      'date': date,
      'time_slot': timeSlot,
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2/donation_app/book_time_slot.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed')),
      );
    }
  }
}
