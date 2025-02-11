import 'package:flutter/material.dart';

class Benefitsrequirements extends StatefulWidget {
  const Benefitsrequirements({super.key});

  @override
  State<Benefitsrequirements> createState() => _BenefitsrequirementsState();
}

class _BenefitsrequirementsState extends State<Benefitsrequirements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requirements'),
      ),
      body: const Center(
        child: Text('Benefits Requirements'),
      ),
    );
  }
}
