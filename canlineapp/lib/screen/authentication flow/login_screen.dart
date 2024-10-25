import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
    return const Text(
      'Hello,\nWelcome!',
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.purple,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return const TextField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return const TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.visibility),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Log in'),
    );
  }

  Widget _buildOrText() {
    return const Center(
      child: Text(
        '- OR -',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCreateAccountText() {
    return const Center(
      child: Text(
        "Don't have account yet?",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.purple,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Text('Create new account'),
    );
  }
}