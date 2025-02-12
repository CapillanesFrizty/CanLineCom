import 'package:flutter/material.dart';

class Servicesoffered extends StatefulWidget {
  final List<String> servicename;
  const Servicesoffered({super.key, required this.servicename});

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
          children: [
            widget.servicename.isEmpty
                ? Text('No Services Offered')
                : Column(
                    children: widget.servicename
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
