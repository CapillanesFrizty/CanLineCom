import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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

  Future<void> _refreshContent() async {
    final hasInternet = await _checkInternetConnection();
    if (hasInternet) {
      await _getUserData();
    }
    if (mounted) {
      setState(() {}); // Rebuild widget
    }
  }

  // Check Internet Connection using dart:io
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  Future<void> _getUserData() async {
    try {
      final hasInternet = await _checkInternetConnection();
      if (!hasInternet) {
        return; // Don't attempt to fetch if no internet
      }

      final u = await supabase.auth.getUser().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );

      if (mounted) {
        setState(() {
          _user = u.user;
        });
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication error: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error fetching user data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<bool>(
        future: _checkInternetConnection(),
        builder: (context, connectionSnapshot) {
          if (connectionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ProfileScreen.primaryColor),
              ),
            );
          }

          if (connectionSnapshot.data == false) {
            return _buildNoInternetView();
          }

          if (_user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ProfileScreen.primaryColor),
                  ),
                ],
              ),
            );
          }

          return _buildBody();
        },
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your network and try again',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshContent,
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileScreen.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
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
