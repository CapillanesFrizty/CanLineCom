import 'package:flutter/material.dart';

class Servicesoffered extends StatefulWidget {
  const Servicesoffered({super.key});

  @override
  State<Servicesoffered> createState() => _ServicesofferedState();
}

class _ServicesofferedState extends State<Servicesoffered> {
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
          children: const [
            ListTile(
              title: Text('What Services Offers',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff5B50A0),
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Text('•', style: TextStyle(fontSize: 30)),
              title: Text('Therapeutics',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            ListTile(
              leading: Text('•', style: TextStyle(fontSize: 30)),
              title: Text('Diagnostic',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            ListTile(
              leading: Text('•', style: TextStyle(fontSize: 30)),
              title: Text('Laboratory Services',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            ListTile(
              leading: Text('•', style: TextStyle(fontSize: 30)),
              title: Text('Radiology',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            ListTile(
              leading: Text('•', style: TextStyle(fontSize: 30)),
              title: Text('Pharmacy',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
