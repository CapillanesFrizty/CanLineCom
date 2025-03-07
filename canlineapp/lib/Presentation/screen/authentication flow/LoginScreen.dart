import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Textfield Controllers
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Initiate a Supabase Client
  final supabase = Supabase.instance.client;

  // Obscure password variable
  var _obscurePassword;

  // Add this variable with the other state variables
  bool _isLoading = false;

  // Update the checkInternetConnection method
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

  // Update the login function
  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signInWithPassword(
        password: _password.text.trim(),
        email: _email.text.trim(),
      );

      if (!mounted) return;

      final user = await supabase.auth.getUser();
      context.go('/HomeScreen/${user.user?.id}');
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Update the checkSession function
  Future<void> checkSession() async {
    try {
      final session = supabase.auth.currentSession;
      if (session != null && session.user != null) {
        if (!mounted) return;
        context.go('/HomeScreen/${session.user.id}');
      }
    } catch (e) {
      debugPrint('Session check error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _obscurePassword = true;

    // Defer navigation to after the widget build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkSession();
    });
  }

  // Update the build method to show offline status when needed
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _checkInternetConnection(),
          builder: (context, networkSnapshot) {
            if (networkSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!networkSnapshot.hasData || !networkSnapshot.data!) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: Icon(
                        Icons.wifi_off_rounded,
                        size: 48,
                        color: LoginScreen._primaryColor,
                      ),
                      title: Text(
                        'No Internet Connection',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: LoginScreen._primaryColor,
                        ),
                      ),
                      content: Text(
                        'Please check your internet connection and try again.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {}); // Refresh the connection check
                          },
                          child: Text(
                            'Try Again',
                            style: GoogleFonts.poppins(
                              color: LoginScreen._primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                );
              });

              // Return a loading indicator while the dialog is being shown
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              // Prevent overflow by making the layout scrollable
              child: Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Make it fill the screen
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey, // Assign the GlobalKey to the Form
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center content
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildWelcomeText(),
                      const SizedBox(height: 40.0),
                      // Email field
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: GoogleFonts.poppins(
                              color: LoginScreen._primaryColor),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LoginScreen._primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LoginScreen._primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LoginScreen._primaryColor),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            _validateEmail, // Use the existing email validator
                      ),
                      const SizedBox(height: 20.0),
                      // Password field
                      TextFormField(
                        controller: _password,
                        obscureText: _obscurePassword!,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: GoogleFonts.poppins(
                              color: LoginScreen._primaryColor),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LoginScreen._primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LoginScreen._primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: LoginScreen._primaryColor),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(_obscurePassword!
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: _validatePassword, // Add password validator
                      ),
                      const SizedBox(height: 40.0),
                      _buildLoginButton(login),
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
          }),
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

  Widget _buildLoginButton(Function loginFunction) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Check internet before login
          final hasConnection = await _checkInternetConnection();
          if (!hasConnection) {
            if (!mounted) return;

            // Show dialog for no internet
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Icon(
                    Icons.wifi_off_rounded,
                    size: 48,
                    color: LoginScreen._primaryColor,
                  ),
                  title: Text(
                    'No Internet Connection',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: LoginScreen._primaryColor,
                    ),
                  ),
                  content: Text(
                    'Please check your internet connection and try again.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {}); // Refresh the connection check
                      },
                      child: Text(
                        'Try Again',
                        style: GoogleFonts.poppins(
                          color: LoginScreen._primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            );
            return;
          }

          // If connected, proceed with login
          loginFunction();
        }
      },
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
      onPressed: () {
        GoRouter.of(context).push('/RegisterScreen');
      },
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

  // Validator function for Email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email.';
    }
    // Regular expression for validating an Email
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null; // Return null if the input is valid
  }

  // Validator function for Password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null; // Return null if the input is valid
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
