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
        title: Text(
          'Services Offered',
          style: TextStyle(color: Color(0xff5B50A0)),
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
                        .map((service) => ExpansionTile(
                              title: Text(service,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              subtitle: Text('Price: ₱1000',
                                  style: TextStyle(fontSize: 15)),
                              trailing:
                                  Icon(Icons.arrow_drop_down_circle_outlined),
                              initiallyExpanded: false,
                              onExpansionChanged: (expanded) {
                                if (expanded) {
                                  // Do something when expanded
                                } else {
                                  // Do something when collapsed
                                }
                              },
                              childrenPadding:
                                  EdgeInsets.only(left: 20, right: 20),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Details about $service',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        'Guidelines:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      SizedBox(height: 5),
                                      Text(
                                          '1. Follow the instructions provided by the healthcare professional.'),
                                      SizedBox(height: 5),
                                      Text(
                                          '2. Ensure to bring all necessary documents.'),
                                      SizedBox(height: 5),
                                      Text(
                                          '3. Arrive at least 15 minutes before your scheduled appointment.'),
                                      SizedBox(height: 5),
                                      Text(
                                          '4. Follow the COVID-19 safety protocols.'),
                                      SizedBox(height: 5),
                                      Text(
                                          '5. Contact the institution for any queries or rescheduling.'),
                                    ],
                                  ),
                                )
                              ],
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
