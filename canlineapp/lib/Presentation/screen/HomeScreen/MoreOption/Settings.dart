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
                _buildSettingItem(
                  title: 'Emergency Contacts',
                  icon: Icons.contact_phone_outlined,
                  onTap: () => _showEmergencyContactsDialog(),
                ),
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
                _buildSettingItem(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () => _showPrivacyPolicyDialog(),
                ),
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

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Emergency Contacts',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Settings.primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add emergency contacts list/form here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'About CanLineCom',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Settings.primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Version 1.0.0',
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 8),
              Text(
                'A support platform for cancer patients and their families.',
                style: GoogleFonts.poppins(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Terms & Conditions',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Settings.primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Acceptance of Terms',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By accessing and using CanLineCom, you accept and agree to be bound by the terms and provision of this agreement.',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                Text(
                  '2. Medical Disclaimer',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The information provided in this app is for general informational purposes only and should not replace professional medical advice.',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                Text(
                  '3. User Responsibilities',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Users are responsible for maintaining the confidentiality of their account information and for all activities that occur under their account.',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: Settings.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Settings.primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Information Collection',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We collect information that you provide directly to us, including medical history, contact information, and other personal details necessary for your care.',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                Text(
                  '2. Data Protection',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We implement appropriate technical and organizational measures to protect your personal data against unauthorized or unlawful processing and accidental loss.',
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                Text(
                  '3. Information Sharing',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We only share your information with healthcare providers and emergency contacts that you specifically authorize.',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: Settings.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
