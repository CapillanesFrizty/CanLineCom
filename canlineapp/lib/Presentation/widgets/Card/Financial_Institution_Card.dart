import 'package:cancerline_companion/Data/Model/FinancialInstitutionModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinancialInsitutionCard extends StatelessWidget {
  final Financial_Institution_Model institution;

  const FinancialInsitutionCard({super.key, required this.institution});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Image.network(institution.FinancialImage_URL,
            width: 50, height: 50, fit: BoxFit.cover),
        title: Text(institution.Financial_Institution_Name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Type: ${institution.Financial_Institution_Type}"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          GoRouter.of(context).push(
              '/Financial-Institution/${institution.Financial_Institution_ID}');
        },
      ),
    );
  }
}
