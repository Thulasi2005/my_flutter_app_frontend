import 'package:flutter/material.dart';

class DonorRequestResponsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Donation Type'),
        backgroundColor: Color(0xFF21B2C5),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDonationButton(
              context,
              title: 'Item Donation',
              subtitle: 'Donate items like clothes, food, etc.',
              onPressed: () {
                Navigator.pushNamed(context, '/requestList');
              },
            ),
            SizedBox(height: 20),
            _buildDonationButton(
              context,
              title: 'Service Donation',
              subtitle: 'Donate services such as medical, maintenance, etc.',
              onPressed: () {
                _showServiceDonationOptions(context);
              },
            ),
            SizedBox(height: 20),
            _buildDonationButton(
              context,
              title: 'Money Donation',
              subtitle: 'Donate money to support various needs.',
              onPressed: () {
                Navigator.pushNamed(context, '/donormoney');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationButton(BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF21B2C5),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  void _showServiceDonationOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Service Donation Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionButton(
                context,
                title: 'Submit Service Request',
                subtitle: 'Submit a new service request.',
                onPressed: () {
                  Navigator.pushNamed(context, '/donorrequest');
                },
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                title: 'Respond to Requests',
                subtitle: 'View and respond to service donation requests.',
                onPressed: () {
                  Navigator.pushNamed(context, '/donorserviceresponse');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionButton(BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF21B2C5),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
