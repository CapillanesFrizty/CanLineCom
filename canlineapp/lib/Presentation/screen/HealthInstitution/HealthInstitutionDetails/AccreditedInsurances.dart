import 'package:flutter/material.dart';

class Accreditedinsurances extends StatefulWidget {
  const Accreditedinsurances({super.key});

  @override
  State<Accreditedinsurances> createState() => _AccreditedinsurancesState();
}

class _AccreditedinsurancesState extends State<Accreditedinsurances> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          children: const [
            ListTile(
              title: Text('What are Accredited Insurances',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff5B50A0),
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Text('•', style: TextStyle(fontSize: 30)),
              title: Text('Maxicare',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            ListTile(
                leading: Text('•', style: TextStyle(fontSize: 30)),
                title: Text('Inellicare',
                    style: TextStyle(
                      fontSize: 20,
                    ))),
            ListTile(
                leading: Text('•', style: TextStyle(fontSize: 30)),
                title: Text('PhilHealth',
                    style: TextStyle(
                      fontSize: 20,
                    ))),
          ],
        ),
      ),
    );
  }
}
