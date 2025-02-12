import 'package:flutter/material.dart';

class Accreditedinsurances extends StatefulWidget {
  final List<String> acreditedinsurances;
  const Accreditedinsurances({super.key, required this.acreditedinsurances});

  @override
  State<Accreditedinsurances> createState() => _AccreditedinsurancesState();
}

class _AccreditedinsurancesState extends State<Accreditedinsurances> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff5B50A0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.acreditedinsurances.isEmpty
                ? Text('No Acredited Insurances')
                : Column(
                    children: widget.acreditedinsurances
                        .map((e) => ListTile(
                              leading:
                                  Text('•', style: TextStyle(fontSize: 30)),
                              title: Text(e,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
