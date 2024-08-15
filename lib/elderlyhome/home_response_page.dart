import 'package:flutter/material.dart';

class HomeResponsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF21B2C5), // Set the background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Donation Options', style: TextStyle(color: Colors.teal[900])),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title
            Text(
              'Choose the Request Response',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0), // Spacing between title and cards

            // Option Cards
            _buildOptionCard(
              context,
              title: 'Item Donation',
              icon: Icons.shopping_basket,
              color: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, '/request-response');
              },
            ),
            SizedBox(height: 16.0), // Add spacing between cards
            _buildOptionCard(
              context,
              title: 'Services Donation',
              icon: Icons.volunteer_activism,
              color: Colors.teal[600]!,
              onTap: () {
                Navigator.pushNamed(context, '/homeserviceresponse');
              },
            ),
            SizedBox(height: 16.0), // Add spacing between cards
            _buildOptionCard(
              context,
              title: 'Money Donation',
              icon: Icons.attach_money,
              color: Colors.teal[400]!,
              onTap: () {
                Navigator.pushNamed(context, '/homemoneydonation');
              },
            ),
            SizedBox(height: 16.0), // Add spacing between cards
            _buildOptionCard(
              context,
              title: 'Calendar Donation',
              icon: Icons.calendar_today,
              color: Colors.teal[300]!,
              onTap: () {
                Navigator.pushNamed(context, '/homecalendarresponse');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.black, width: 2), // Black border
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white), // Icon for the card
              SizedBox(width: 16.0), // Spacing between icon and text
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
