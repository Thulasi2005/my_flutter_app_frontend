import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimeSlotsPage extends StatefulWidget {
  @override
  _TimeSlotsPageState createState() => _TimeSlotsPageState();
}

class _TimeSlotsPageState extends State<TimeSlotsPage> {
  List bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/donation_app/get_calendar_bookings.php'),
    );

    if (response.statusCode == 200) {
      setState(() {
        bookings = json.decode(response.body)['bookings'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings')),
      );
    }
  }

  Future<void> _updateBookingStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/donation_app/update_booking_status.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'status': status}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking status updated')),
      );
      _fetchBookings(); // Refresh the list after updating
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update booking status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Manage Bookings'),
      ),
      body: bookings.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          var booking = bookings[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Time Slot: ${booking['time_slot']}'),
              subtitle: Text(
                  'Date: ${booking['date']}\nStatus: ${booking['status']}'),
              trailing: DropdownButton<String>(
                value: booking['status'],
                items: ['Pending', 'Accepted', 'Declined']
                    .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    _updateBookingStatus(booking['id'], newStatus);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
