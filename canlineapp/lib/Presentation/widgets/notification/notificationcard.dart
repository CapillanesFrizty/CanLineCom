import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String reminder;

  const NotificationCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.event, size: 16),
                  SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.warning, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      reminder,
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
