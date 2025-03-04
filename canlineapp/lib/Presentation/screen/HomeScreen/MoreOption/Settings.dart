import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static const Color primaryColor = Color(0xFF5B50A0);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      final response = await supabase.auth.getUser();

      setState(() {
        _user = response.user;
      });
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Failed to fetch user data';
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ConnectionException')) {
        errorMessage = 'No internet connection';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: Settings.primaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 24),

          // Profile Settings
          _buildSectionHeader('Profile Settings'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingItem(
                  title: 'Edit Profile',
                  icon: Icons.edit_outlined,
                  onTap: () => _handleEditProfile(),
                ),
                // _buildSettingItem(
                //   title: 'Emergency Contacts',
                //   icon: Icons.contact_phone_outlined,
                //   onTap: () => _showEmergencyContactsDialog(),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Support & About
          _buildSectionHeader('Support & About'),
          _buildSettingCard(
            child: Column(
              children: [
                _buildSettingItem(
                  title: 'Help Center',
                  icon: Icons.help_outline,
                  onTap: () => context.push('/help-center'),
                ),
                _buildSettingItem(
                  title: 'Terms & Conditions',
                  icon: Icons.description_outlined,
                  onTap: () => _showTermsAndConditionsDialog(),
                ),
                // _buildSettingItem(
                //   title: 'Privacy Policy',
                //   icon: Icons.privacy_tip_outlined,
                //   onTap: () => _showPrivacyPolicyDialog(),
                // ),
                _buildSettingItem(
                  title: 'About App',
                  icon: Icons.info_outline,
                  onTap: () => _showAboutDialog(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    String displayName = _user?.userMetadata?['firstname'] != null &&
            _user?.userMetadata?['lastname'] != null
        ? "${_user!.userMetadata!['firstname']} ${_user!.userMetadata!['lastname']}"
        : _user?.email ?? 'User';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Settings.primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.person,
                color: Settings.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Settings.primaryColor,
                    ),
                  ),
                  Text(
                    _user?.email ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: () async {
          bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (confirm) {
            await supabase.auth.signOut();
            context.go('/');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Settings.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: Settings.primaryColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 13),
            )
          : null,
      trailing: trailing ??
          Icon(Icons.arrow_forward_ios, size: 16, color: Settings.primaryColor),
      onTap: onTap,
    );
  }

  // void _showEmergencyContactsDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Emergency Contacts',
  //           style: GoogleFonts.poppins(
  //             fontWeight: FontWeight.w600,
  //             color: Settings.primaryColor,
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Add emergency contacts list/form here
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Who are we?',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Settings.primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cancer Companion empowers patients and caregivers on their cancer journey. We combine innovative tech, personalized support, and  a strong community to improve well-being and quality of care.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Divider(
                  thickness: 1,
                ),
                Text(
                  'Mission',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Our mission is to empower cancer patients and their care companions throughout their journey by providing integrated and supportive solutions. We create an environment that nurtures understanding, care, and companionship for the patients by collaborating with medical professionals, healthcare institutions, and support organizations. We are committed to enhancing the overall wellbeing and quality of care for cancer patients through innovative technology, personalized holistic support, and a strong community network.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Vision',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'A world where cancer patients live with a smile.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Divider(
                  thickness: 1,
                ),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Settings.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Terms & Conditions',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Settings.primaryColor,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  '',
                  'By accessing and using the CanLine application, you agree to be bound by these Terms and Conditions. Please read them carefully.',
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
                const Divider(height: 24),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
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

  // void _showPrivacyPolicyDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Privacy Policy',
  //           style: GoogleFonts.poppins(
  //             fontWeight: FontWeight.w600,
  //             color: Settings.primaryColor,
  //           ),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 '1. Information Collection',
  //                 style: GoogleFonts.poppins(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'We collect information that you provide directly to us, including medical history, contact information, and other personal details necessary for your care.',
  //                 style: GoogleFonts.poppins(),
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 '2. Data Protection',
  //                 style: GoogleFonts.poppins(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'We implement appropriate technical and organizational measures to protect your personal data against unauthorized or unlawful processing and accidental loss.',
  //                 style: GoogleFonts.poppins(),
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 '3. Information Sharing',
  //                 style: GoogleFonts.poppins(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'We only share your information with healthcare providers and emergency contacts that you specifically authorize.',
  //                 style: GoogleFonts.poppins(),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text(
  //               'Close',
  //               style: GoogleFonts.poppins(
  //                 color: Settings.primaryColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _handleEditProfile() async {
    final TextEditingController firstNameController = TextEditingController(
      text: _user?.userMetadata?['firstname'] ?? '',
    );
    final TextEditingController lastNameController = TextEditingController(
      text: _user?.userMetadata?['lastname'] ?? '',
    );
    final TextEditingController phoneController = TextEditingController(
      text: _user?.userMetadata?['phone'] ?? '',
    );

    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Profile',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Settings.primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Settings.primaryColor,
              ),
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await supabase.auth.updateUser(
          UserAttributes(
            data: {
              'firstname': firstNameController.text,
              'lastname': lastNameController.text,
              'phone': phoneController.text,
            },
          ),
        );

        // Refresh user data
        await _getUserData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profile updated successfully',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update profile',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
