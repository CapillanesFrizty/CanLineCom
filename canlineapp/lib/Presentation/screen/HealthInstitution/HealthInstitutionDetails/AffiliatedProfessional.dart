import 'package:flutter/material.dart';

class AffiliatedProfessional extends StatefulWidget {
  const AffiliatedProfessional({super.key});

  @override
  State<AffiliatedProfessional> createState() => _AffiliatedProfessionalState();
}

class _AffiliatedProfessionalState extends State<AffiliatedProfessional> {
  final List<Map<String, dynamic>> affiliatedProf = [
    {
      'Doctor-Firstname': 'John',
      'Doctor-Lastname': 'Doe',
      'Specialization': 'Oncologist',
      'Doctor-Email': 'john.doe@example.com',
      'Visiting': true
    },
    {
      'Doctor-Firstname': 'Jane',
      'Doctor-Lastname': 'Smith',
      'Specialization': 'Oncologist',
      'Doctor-Email': 'jane.smith@example.com',
      'Visiting': false
    },
    {
      'Doctor-Firstname': 'Alice',
      'Doctor-Lastname': 'Johnson',
      'Specialization': 'Hematologist',
      'Doctor-Email': 'alice.johnson@example.com',
      'Visiting': true
    },
    {
      'Doctor-Firstname': 'Bob',
      'Doctor-Lastname': 'Brown',
      'Specialization': 'Radiation Oncologist',
      'Doctor-Email': 'bob.brown@example.com',
      'Visiting': false
    },
    {
      'Doctor-Firstname': 'Carol',
      'Doctor-Lastname': 'Davis',
      'Specialization': 'Surgical Oncologist',
      'Doctor-Email': 'carol.davis@example.com',
      'Visiting': true
    },
  ];

  String? selectedSpecialization;
  bool? visitingDoctor;
  final Color brandColor = Color(0xff5B50A0);

  void _applyFilters() {
    setState(() {});
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: brandColor)),
                  SizedBox(height: 16),
                  Text('Specialization', style: TextStyle(color: brandColor)),
                  DropdownButton<String>(
                    value: selectedSpecialization,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text('All'),
                      ),
                      ...affiliatedProf
                          .map((e) => e['Specialization'])
                          .toSet()
                          .map((specialization) => DropdownMenuItem<String>(
                                value: specialization,
                                child: Text(specialization),
                              ))
                          .toList(),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        selectedSpecialization = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Visiting Doctor', style: TextStyle(color: brandColor)),
                  ToggleButtons(
                    isSelected: [
                      visitingDoctor == null,
                      visitingDoctor == true,
                      visitingDoctor == false
                    ],
                    onPressed: (index) {
                      setState(() {
                        if (index == 0) visitingDoctor = null;
                        if (index == 1) visitingDoctor = true;
                        if (index == 2) visitingDoctor = false;
                      });
                    },
                    selectedColor: Colors.white,
                    color: Colors.grey,
                    fillColor: brandColor,
                    borderRadius: BorderRadius.circular(8),
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('All')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Visiting')),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Non-Visiting')),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: brandColor),
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: Text('Apply Filters',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Affiliated Professionals',
            style: TextStyle(color: brandColor)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: brandColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: brandColor),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: affiliatedProf.length,
        itemBuilder: (context, index) {
          final doctor = affiliatedProf[index];
          if ((selectedSpecialization == null ||
                  doctor['Specialization'] == selectedSpecialization) &&
              (visitingDoctor == null ||
                  doctor['Visiting'] == visitingDoctor)) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/placeholder.png'),
                ),
                title: Text(
                  '${doctor['Doctor-Firstname']} ${doctor['Doctor-Lastname']}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brandColor),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor['Specialization'],
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[700])),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: doctor['Visiting'] ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doctor['Visiting']
                            ? 'Visiting Doctor'
                            : 'Non-Visiting Doctor',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
