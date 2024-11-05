import 'package:flutter/material.dart';

class HealthInstitutionOncologists extends StatefulWidget {
  final String type;

  const HealthInstitutionOncologists({super.key, required this.type});

  @override
  State<HealthInstitutionOncologists> createState() =>
      _HealthInstitutionOncologistsState();
}

class _HealthInstitutionOncologistsState
    extends State<HealthInstitutionOncologists> {
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
        title: Text('${widget.type} Details'), // Display the type in the title
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.type} Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dedicated to providing specialized care for cancer patients. With advanced treatments, compassionate support, and a team of expert oncologists, we are here to guide you every step of the way on your journey to healing.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildServiceCard(
              icon: Icons.health_and_safety,
              title: widget.type == 'Facilities'
                  ? 'Facility Service'
                  : widget.type == 'Accredited Insurance'
                      ? 'Accredited Insurance Service'
                      : 'Doctor Consultation',
              subtitle: widget.type == 'Facilities'
                  ? 'Details about facilities'
                  : widget.type == 'Accredited Insurance'
                      ? 'Details about insurance'
                      : 'Details about doctors',
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              icon: Icons.person,
              title: widget.type == 'Facilities'
                  ? 'Additional Facility'
                  : widget.type == 'Accredited Insurance'
                      ? 'Insurance Partner'
                      : 'Specialist Doctor',
              subtitle: 'Patient Consultant',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.deepPurple),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple[300],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
