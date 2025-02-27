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
              '1. LICENSE GRANT',
              '''Subject to your compliance with this Agreement, the Company grants you a limited, non-exclusive, non-transferable, and revocable license to install and use the Software for personal or professional healthcare-related purposes, strictly in accordance with applicable laws and regulations.''',
            ),
            _buildSection(
              '2. RESTRICTIONS ON USE',
              '''You agree not to:
\u2022The medical information you provide will be used for patient care coordination.
\u2022While we maintain strict privacy standards, no method of electronic storage is 100% secure.
\u2022You agree to provide accurate medical history and current health status information.''',
            ),
            _buildSection(
              '3.  HEALTHCARE DISCLAIMER',
              '''The Software is intended to assist healthcare professionals and patients but is not a substitute for professional medical advice, diagnosis, or treatment. You should always seek the advice of a qualified healthcare provider before making any medical decisions. The Company is not responsible for any adverse outcomes resulting from reliance on the Software. The User acknowledges that the Software may contain errors or limitations that could impact its accuracy and should not be solely relied upon for critical healthcare decisions.  
''',
            ),
            _buildSection(
              '4.  DATA PRIVACY AND SECURITY',
              '''\u2022 The Company collects, stores, and processes personal and health-related information through the Software. By using the Software, users consent to the Company's collection and use of such data as outlined in the [Privacy Policy].
\u2022 The Company is committed to implementing industry-standard security measures to protect user data. However, it does not guarantee absolute security against data breaches, and users are responsible for taking necessary precautions to protect their information.
\u2022 The Company ensures compliance with applicable data protection laws, including but not limited to HIPAA (for U.S. users) and GDPR (for EU users).
\u2022 The Company reserves the right to anonymize and aggregate collected data for analytics, research, and product development while ensuring that no personally identifiable information is disclosed.''',
            ),
            _buildSection(
              '5. UPDATES, MODIFICATIONS, AND SUPPORT',
              '''\u2022 The Company reserves the right to update, modify, or discontinue the Software at any time without notice. Updates may be required for continued use.
\u2022 The Company is not obligated to provide technical support or maintenance services but may do so at its discretion.               
              ''',
            ),
            _buildSection(
              '6. TERMINATION',
              '''This Agreement is effective until terminated by you or the Company. Your rights under this Agreement will automatically terminate if you fail to comply with any terms. Upon termination, you must cease all use of the Software and delete all copies. The Company reserves the right to suspend or terminate access without liability if it determines that your use of the Software poses a risk to security, legal compliance, or operational integrity.  
''',
            ),
            _buildSection(
              '7. DISCLAIMER OF WARRANTIES',
              '''\u2022 The Software is provided "as is" and "as available" without warranties of any kind, either express or implied.
\u2022 The Company does not warrant that the Software will be free from defects, errors, viruses, or interruptions.
\u2022 The Company disclaims all warranties, including but not limited to merchantability, fitness for a particular purpose, and non-infringement.''',
            ),
            _buildSection(
              '8. LIMITATION OF LIABILITY',
              '''To the fullest extent permitted by law, the Company shall not be liable for any direct, indirect, incidental, consequential, or special damages arising from the use or inability to use the Software. This includes but is not limited to loss of data, revenue, or profits, business interruption, and unauthorized access to personal data.  ''',
            ),
            _buildSection(
              '9. COMPLIANCE WITH LAWS',
              '''
\u2022 Users are responsible for ensuring that their use of the Software complies with all applicable local, state, and federal laws, including healthcare regulations.  
\u2022 The Company does not assume liability for any misuse of the Software that results in non-compliance with healthcare regulations. ''',
            ),
            const SizedBox(height: 20),
            Text(
              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
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
