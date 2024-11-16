import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  final String? userid;

  const ProfileScreen({super.key, required this.userid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  static const Color primaryColor = Color(0xFF5B50A0);
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0), // Set the height here
      child: AppBar(
        title: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
        ),
        centerTitle: false,
        leading: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: ProfileScreen.primaryColor),
            onPressed: () => context.go('/HomeScreen'),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: ProfileScreen.primaryColor,
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          _buildProfileImage(),
          const SizedBox(height: 15),
          _buildNameAndLocation(),
          const SizedBox(height: 60),
          _buildMedicalRecordLabel(),
          const SizedBox(height: 16),
          _buildQRCodePlaceholder(),
          SizedBox(height: 20),
          Text('User ID: ${widget.userid}'),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey, // Placeholder color
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNameAndLocation() {
    return Column(
      children: const [
        Text(
          'Hanna Forger',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ProfileScreen.primaryColor,
          ),
        ),
        Text(
          'Barangay Mandug, Davao City\nDavao del sur',
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
      color: Colors.grey, // Placeholder color
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
