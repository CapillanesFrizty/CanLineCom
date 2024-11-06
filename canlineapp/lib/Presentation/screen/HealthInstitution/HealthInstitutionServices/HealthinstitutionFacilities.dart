import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HealthInstitutionFacilities extends StatefulWidget {
  final String type;

  const HealthInstitutionFacilities({super.key, required this.type});

  @override
  State<HealthInstitutionFacilities> createState() =>
      _HealthInstitutionFacilitiesState();
}

class _HealthInstitutionFacilitiesState
    extends State<HealthInstitutionFacilities> {
  static const Color _primaryColor = Color(0xFF5B50A0);
  static const Color _secondaryColor = Color(0xFFF3EBFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B50A0)),
          onPressed: () => context.go('/Health-Insititution'),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildMainServiceCard(),
            const SizedBox(height: 16),
            _buildConsultationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            '${widget.type} Services',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '${widget.type} ${_HeaderData.description}',
            style: const TextStyle(
              fontSize: 12,
              color: _primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMainServiceCard() {
    return _buildServiceCard(
      Icons.health_and_safety,
      _ServiceData.getTitle(widget.type),
      _ServiceData.getSubtitle(widget.type),
    );
  }

  Widget _buildConsultationCard() {
    return _buildServiceCard(
      Icons.person,
      _ServiceData.getAdditionalTitle(widget.type),
      'Patient Consultant',
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: _primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: _primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceData {
  static String getTitle(String type) {
    return {
          'Facilities': 'Facility Service',
          'Accredited Insurance': 'Accredited Insurance Service',
        }[type] ??
        'Doctor Consultation';
  }

  static String getSubtitle(String type) {
    return {
          'Facilities': 'Details about facilities',
          'Accredited Insurance': 'Details about insurance',
        }[type] ??
        'Details about doctors';
  }

  static String getAdditionalTitle(String type) {
    return {
          'Facilities': 'Additional Facility',
          'Accredited Insurance': 'Insurance Partner',
        }[type] ??
        'Specialist Doctor';
  }
}

class _HeaderData {
  static const String description =
      'Dedicated to providing specialized care for cancer patients. '
      'With advanced treatments, compassionate support, and a team of expert oncologists, '
      'we are here to guide you every step of the way on your journey to healing.';
}
