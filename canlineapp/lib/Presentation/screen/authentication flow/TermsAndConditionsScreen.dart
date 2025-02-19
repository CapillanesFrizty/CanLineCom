import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/RegisterScreen'),
          tooltip: 'Go back',
        ),
        title: Text(
          'Terms and Conditions',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Welcome to CanLine',
              'By accessing and using the CanLine application, you agree to be bound by these Terms and Conditions. Please read them carefully before proceeding with registration.',
            ),
            _buildSection(
              '1. User Registration',
              '''• You must provide accurate, complete, and current information during registration.
• You are responsible for maintaining the confidentiality of your account credentials.
• You must be at least 18 years old to create an account.''',
            ),
            _buildSection(
              '2. Medical Information',
              '''• The medical information you provide will be used for patient care coordination.
• While we maintain strict privacy standards, no method of electronic storage is 100% secure.
• You agree to provide accurate medical history and current health status information.''',
            ),
            _buildSection(
              '3. Privacy Policy',
              '''• We collect and process your personal data in accordance with our Privacy Policy.
• Your medical information will be handled with strict confidentiality.
• We may share your information with healthcare providers involved in your care.''',
            ),
            _buildSection(
              '4. Patient Rights',
              '''• You have the right to access your medical information.
• You can request corrections to your personal information.
• You may withdraw consent at any time by contacting our support team.''',
            ),
            _buildSection(
              '5. Data Usage',
              '''• Your data may be used for improving our services.
• Anonymous data may be used for research purposes.
• We implement security measures to protect your information.''',
            ),
            _buildSection(
              '6. Communication',
              '''• We may send you important notifications about your care.
• You can opt-out of non-essential communications.
• Emergency notifications cannot be opted out of.''',
            ),
            _buildSection(
              '7. Disclaimer',
              '''• The app is not a substitute for professional medical advice.
• In case of emergency, contact emergency services immediately.
• We are not liable for any delays in seeking professional medical care.''',
            ),
            const SizedBox(height: 20),
            Text(
              'Last updated: February 19, 2025',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5B50A0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
