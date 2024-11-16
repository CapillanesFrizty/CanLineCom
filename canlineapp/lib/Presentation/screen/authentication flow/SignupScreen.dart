import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
}

class _SignupScreenState extends State<SignupScreen> {
  bool hasNoMiddleName = false;
  String? selectedCitizenship;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _NameFields(
                hasNoMiddleName: hasNoMiddleName,
                onNoMiddleNameChanged: (value) {
                  setState(() {
                    hasNoMiddleName = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              const _TextField(labelText: 'Last Name'),
              const SizedBox(height: 20),
              const _TextField(labelText: 'Email'),
              const SizedBox(height: 20),
              _CitizenshipDropdown(
                selectedCitizenship: selectedCitizenship,
                onChanged: (value) {
                  setState(() {
                    selectedCitizenship = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const _TextField(labelText: 'Address'),
              const SizedBox(height: 20),
              const _TextField(labelText: 'Occupation'),
              const SizedBox(height: 30),
              _NextButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0), // Adjust the height here
      child: AppBar(
        title: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
          child: Text(
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: SignupScreen._primaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: SignupScreen._primaryColor),
            onPressed: () => context.go('/'),
          ),
        ),
      ),
    );
  }
}

class _NameFields extends StatelessWidget {
  final bool hasNoMiddleName;
  final ValueChanged<bool?> onNoMiddleNameChanged;

  const _NameFields({
    required this.hasNoMiddleName,
    required this.onNoMiddleNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: _TextField(labelText: 'First Name'),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: _TextField(labelText: 'Suffix'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _TextField(labelText: 'Middle Name'),
        Row(
          children: [
            Checkbox(
              value: hasNoMiddleName,
              onChanged: onNoMiddleNameChanged,
            ),
            Text(
              'I have no middle name',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final String labelText;

  const _TextField({required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: SignupScreen._primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: SignupScreen._primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: SignupScreen._primaryColor),
        ),
      ),
    );
  }
}

class _CitizenshipDropdown extends StatelessWidget {
  final String? selectedCitizenship;
  final ValueChanged<String?> onChanged;

  const _CitizenshipDropdown({
    required this.selectedCitizenship,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCitizenship,
      decoration: InputDecoration(
        labelText: 'Citizenship',
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: SignupScreen._primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: SignupScreen._primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: SignupScreen._primaryColor),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Foreign', child: Text('Foreign')),
        DropdownMenuItem(value: 'Filipino', child: Text('Filipino')),
      ],
      onChanged: onChanged,
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.go('/MoreSignUpScreen'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: SignupScreen._primaryColor),
          ),
        ),
        child: Text(
          'Next',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }
}
