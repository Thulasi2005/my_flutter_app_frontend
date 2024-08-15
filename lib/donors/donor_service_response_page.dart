import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonorServiceResponsePage extends StatefulWidget {
  @override
  _DonorServiceResponsePageState createState() => _DonorServiceResponsePageState();
}

class _DonorServiceResponsePageState extends State<DonorServiceResponsePage> {
  List<dynamic> _requests = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() {
      _isFetching = true;
    });
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/donation_app/get_service_requests.php'));
      print('Fetch response status: ${response.statusCode}');
      print('Fetch response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _requests = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load requests. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching requests: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching requests: $e')),
      );
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  Future<void> _updateRequestStatus(int requestId, String status) async {
    print('Sending request to update status...'); // Debugging line
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/donation_app/update_request_service_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': requestId, 'status': status}),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          _fetchRequests(); // Refresh the request list
          _showSuccessDialog(status);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update request: ${result['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update request. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error updating request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating request: $e')),
      );
    }
  }

  void _showSuccessDialog(String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Request has been $status successfully.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Service Requests'),
        backgroundColor: Color(0xFF21B2C5),
      ),
      body: _isFetching
          ? Center(child: CircularProgressIndicator())
          : _requests.isEmpty
          ? Center(child: Text('No requests available'))
          : ListView.builder(
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Home Name: ${request['homeName']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Service: ${request['service']}'),
                  Text('Number of Elders: ${request['numElders']}'),
                  Text('Description: ${request['description']}'),
                  Text('Time Period: ${request['timePeriod']}'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: request['status'] == 'Accepted' || request['status'] == 'Declined'
                            ? null
                            : () {
                          print('Accept button pressed with ID: ${request['id']}');
                          _updateRequestStatus(request['id'], 'Accepted');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Accept'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: request['status'] == 'Accepted' || request['status'] == 'Declined'
                            ? null
                            : () {
                          print('Decline button pressed with ID: ${request['id']}');
                          _updateRequestStatus(request['id'], 'Declined');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('Decline'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
