import '../../../Layouts/Scaffold/ScaffoldLayout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String? userid;

  const ProfileScreen({super.key, required this.userid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  static const Color primaryColor = Color(0xFF5B50A0);
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future _getUserData() async {
    final u = await supabase.auth.getUser();

    setState(() {
      _user = u.user;
    });

    debugPrint('Authenticated User: $_user');
  }

  Future<void> _Logout() async {
    await supabase.auth.signOut();
    GoRouter.of(context).go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        // Added to prevent overflow
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildProfileImage(),
            const SizedBox(height: 15),
            _buildNameAndLocation(),
            const SizedBox(height: 60),
            _buildMedicalRecordLabel(),
            const SizedBox(height: 16),
            _buildQRCodePlaceholder(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    // Assuming you have a 'avatar_url' in user_metadata. Adjust accordingly.
    String? avatarUrl = _user?.userMetadata?['avatar_url'];

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey, // Placeholder color
        image: avatarUrl != null
            ? DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: avatarUrl == null
          ? const Center(
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildNameAndLocation() {
    String displayName = _user?.userMetadata?['firstname'] != null &&
            _user?.userMetadata?['lastname'] != null
        ? "${_user!.userMetadata!['firstname']} ${_user!.userMetadata!['lastname']}"
        : _user?.userMetadata?['firstname'] ?? '';

    String location =
        "${_user?.userMetadata?['current_address']}, ${_user?.userMetadata?['city']}, ${_user?.userMetadata?['province']}";

    return Column(
      children: [
        Text(
          displayName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ProfileScreen.primaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          location,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: ProfileScreen.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalRecordLabel() {
    return const Text(
      'Scan my Medical Record',
      style: TextStyle(
        fontSize: 16,
        color: ProfileScreen.primaryColor,
      ),
    );
  }

  Widget _buildQRCodePlaceholder() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey, // Placeholder color
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.qr_code,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
