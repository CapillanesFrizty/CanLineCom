import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AffiliatedProfessional extends StatefulWidget {
  final String healthInstitutionid;
  const AffiliatedProfessional({super.key, required this.healthInstitutionid});

  @override
  State<AffiliatedProfessional> createState() => _AffiliatedProfessionalState();
}

class _AffiliatedProfessionalState extends State<AffiliatedProfessional> {
  Future<Map<String, dynamic>> _getAffiliatedProfessional() async {
    // Get the affiliated Doctors of the insitution
    final response = await Supabase.instance.client
        .from('Doctor')
        .select()
        .eq('Affailated_at', widget.healthInstitutionid);
    return {'data': response};
  }

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
                  Text('Filters',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 8),
                  Text('Select filters to narrow down your search',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  SizedBox(height: 24),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _getAffiliatedProfessional(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      final specializations = (snapshot.data?['data'] as List)
                          .map((e) => e['Specialization'].toString())
                          .toSet()
                          .toList();

                      return DropdownButton<String>(
                        value: selectedSpecialization,
                        isExpanded: true,
                        hint: Text('Select Specialization'),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text('All'),
                          ),
                          ...specializations.map((String specialization) {
                            return DropdownMenuItem<String>(
                              value: specialization,
                              child: Text(specialization),
                            );
                          }),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            selectedSpecialization = value;
                          });
                        },
                      );
                    },
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getAffiliatedProfessional(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No affiliated professionals found'));
          }

          final affiliatedProf = snapshot.data!['data'] as List;

          return ListView.builder(
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
                    borderRadius: BorderRadius.circular(5),
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
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700])),
                        SizedBox(height: 4),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
