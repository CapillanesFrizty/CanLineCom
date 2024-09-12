import 'package:flutter/material.dart';

class CardFinancial extends StatelessWidget {
  final VoidCallback onTap;

  const CardFinancial({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_atm,
              color: Colors.white,
              size: 40.0,
            ),
            SizedBox(height: 8.0),
            Text(
              'Financial Assistance',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}