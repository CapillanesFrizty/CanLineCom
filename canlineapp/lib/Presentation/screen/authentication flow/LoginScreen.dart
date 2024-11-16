import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjust for keyboard
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Prevent overflow by making the layout scrollable
        child: Container(
          height: MediaQuery.of(context).size.height, // Make it fill the screen
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeText(),
              const SizedBox(height: 40.0),
              _buildEmailTextField(),
              const SizedBox(height: 20.0),
              _buildPasswordTextField(),
              const SizedBox(height: 40.0),
              _buildLoginButton(),
              const SizedBox(height: 20.0),
              _buildOrText(),
              const SizedBox(height: 20.0),
              _buildCreateAccountText(),
              const SizedBox(height: 20.0),
              _buildCreateAccountButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      'Hello,\nWelcome!',
      style: GoogleFonts.poppins(
        fontSize: 40.0,
        fontWeight: FontWeight.w500,
        color: LoginScreen._primaryColor,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GoogleFonts.poppins(color: LoginScreen._primaryColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: LoginScreen._primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LoginScreen._primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LoginScreen._primaryColor),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: GoogleFonts.poppins(color: LoginScreen._primaryColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: LoginScreen._primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LoginScreen._primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LoginScreen._primaryColor),
        ),
        suffixIcon: Icon(Icons.visibility, color: LoginScreen._primaryColor),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () => context.go('/HomeScreen'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: LoginScreen._primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'Log in',
        style: GoogleFonts.poppins(),
      ),
    );
  }

  Widget _buildOrText() {
    return Center(
      child: Text(
        '- OR -',
        style: GoogleFonts.poppins(color: Colors.grey),
      ),
    );
  }

  Widget _buildCreateAccountText() {
    return Center(
      child: Text(
        "Don't have account yet?",
        style: GoogleFonts.poppins(color: Colors.grey),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return OutlinedButton(
      onPressed: () => context.go('/SignUpScreen'),
      style: OutlinedButton.styleFrom(
        foregroundColor: LoginScreen._primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        side: BorderSide(color: LoginScreen._primaryColor),
      ),
      child: Text(
        'Create new account',
        style: GoogleFonts.poppins(),
      ),
    );
  }
}
