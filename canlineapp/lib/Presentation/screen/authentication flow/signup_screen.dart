import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('This is a Register Screen'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              const userId = '12345';
              // context.go('/homescreen');
              context.go('/homescreen/$userId');
              debugPrint('/homescreen');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
