import 'package:canerline_app/widgets/Card/Carddesign2Carousellist.dart';
import 'package:flutter/material.dart';

import '../../Layouts/BarrelFileLayouts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinancialSupportScreen extends StatelessWidget {
  FinancialSupportScreen({super.key});

  // Select all Public Institutions
  final _future_Public_Institutions = Supabase.instance.client
      .from('financial_institutions')
      .select()
      .eq('type_of_assistance', 'Public Institution');

  // Select all Private Institutions
  final _future_Private_Institutions = Supabase.instance.client
      .from('financial_institutions')
      .select()
      .eq("type_of_assistance", "Private Institution");

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Listviewlayout(
        childrenProps: [
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Financial Support",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide.none),
                hintText: "Search",
                hintStyle:
                    TextStyle(color: Colors.grey.shade500, fontSize: 14.0),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Government Assistance",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),

          //! FutureBuilder for the Public Institutions
          FutureBuilder(
            future: _future_Public_Institutions,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<Map<String, dynamic>> healthinst =
                  snapshot.data as List<Map<String, dynamic>>;

              if (healthinst.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              // Enter the Card here for the Public Institutions
              return SizedBox(
                child: ListView(children: const [
                  Carddesign2Carousellist(
                    title: "Hello",
                  ),
                ]),
              );
            },
            
          ),
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "Private Assistance",
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
          //! FutureBuilder for the Private Institutions
          FutureBuilder(
            future: _future_Private_Institutions,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<Map<String, dynamic>> healthinst =
                  snapshot.data as List<Map<String, dynamic>>;

              if (healthinst.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              // Enter the Card here for the Public Institutions
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
