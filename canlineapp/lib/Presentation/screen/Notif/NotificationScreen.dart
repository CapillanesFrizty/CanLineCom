import 'package:flutter/material.dart';
import '../../widgets/BarrelFileWidget..dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Notifications"),
      ),
      body: ListView(
        children: const [
          NotificationCard(
            title: "Event Notification: Free Cancer Screening Event",
            date: "November 12, 2024",
            location: "[Hospital Name], Oncology Department",
            reminder: "Don't miss our free cancer screening event! Early...",
          ),
          NotificationCard(
            title: "Event Notification: Free Cancer Screening Event",
            date: "November 12, 2024",
            location: "[Hospital Name], Oncology Department",
            reminder: "Don't miss our free cancer screening event! Early...",
          ),
          // Add more NotificationCards here as needed
        ],
      ),
    );
  }
}
