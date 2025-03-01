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

  // Login function
  Future<void> login() async {
    try {
      await supabase.auth.signInWithPassword(
        password: _password.text.trim(),
        email: _email.text.trim(),
      );

      if (!mounted) return;

      final user = await supabase.auth.getUser();

      context.go('/HomeScreen/${user.user?.id}');
    } on AuthException catch (e) {
      debugPrint('Error: ${e.message}');
      // Display error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      // Handle other types of errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  // Check session
  Future<void> checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    debugPrint('Session: $session');
    if (session != null && session.user != null) {
      final userId = session.user.id;
      debugPrint('User ID: $userId');
      context.go('/HomeScreen/$userId');
    } else {
      context.go('/');
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
          child: Form(
            key: _formKey, // Assign the GlobalKey to the Form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildWelcomeText(),
                const SizedBox(height: 40.0),
                // Email field
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        GoogleFonts.poppins(color: LoginScreen._primaryColor),
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
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail, // Use the existing email validator
                ),
                const SizedBox(height: 20.0),
                // Password field
                TextFormField(
                  controller: _password,
                  obscureText: _obscurePassword!,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:
                        GoogleFonts.poppins(color: LoginScreen._primaryColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: LoginScreen._primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: LoginScreen._primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: LoginScreen._primaryColor),
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

  Widget _buildLoginButton(Function loginFunction) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // If the form is valid, proceed with login
          loginFunction();
        } else {
          // If the form is invalid, display a snackbar or handle accordingly
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //       content:
          //           Text('Please enter the nessecary credentials submitting.')),
          // );
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
        GoRouter.of(context).go('/RegisterScreen');
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
