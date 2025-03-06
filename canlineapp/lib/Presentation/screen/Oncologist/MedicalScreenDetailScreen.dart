import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicalSpeciaDetailScreens extends StatefulWidget {
  final String docid;
  const MedicalSpeciaDetailScreens({super.key, required this.docid});

  @override
  State<MedicalSpeciaDetailScreens> createState() =>
      _MedicalSpeciaDetailScreensState();
}

class _MedicalSpeciaDetailScreensState
    extends State<MedicalSpeciaDetailScreens> {
  late Future<Map<String, dynamic>> _future;
  final String _selectedFilter = 'all';
  final List<Map<String, dynamic>> _filteredClinics = [];
  final ValueNotifier<String> _filterNotifier = ValueNotifier<String>('all');

  @override
  void initState() {
    super.initState();
    _future = _fetchDoctorDetails();
  }

  Future<Map<String, dynamic>> _fetchDoctorDetails() async {
    if (widget.docid.isEmpty) {
      throw Exception('Invalid doctor ID');
    }
    try {
      final doctorId = int.tryParse(widget.docid);
      if (doctorId == null) {
        throw Exception('Invalid doctor ID format');
      }

      // Fetch doctor details
      final doctor = await Supabase.instance.client
          .from('Doctor')
          .select()
          .eq('id', doctorId)
          .single();

      // Fetch clinics with their details
      final clinics =
          await Supabase.instance.client.from('ClinicDetails').select('''
          *,
          Health-Institution (
            *
          )
        ''').eq('Affailated_Doctors', doctorId);

      // Combine the data
      return {
        ...doctor,
        'clinics': clinics,
      };
    } catch (e) {
      throw Exception('Failed to fetch doctor details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _buildIconButton(
          Icons.arrow_back,
          () => context.go('/Medical-Specialists'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDoctorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView(
              children: [
                _buildBackgroundImage(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header in the screen include name and specialization
                      _buildHeaderSection(data),
                      _buildDividerWithSpacing(),
                      _buildClinicSection(data),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return SizedBox(
      height: 300,
      child: ClipRRect(
        child: Center(
            child: Icon(Icons.person_4_rounded, color: Colors.grey, size: 300)),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 20,
        color: const Color(0xff5B50A0),
      ),
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildTitle('${data['Doctor-Firstname']} ${data['Doctor-Lastname']}'),
        _buildSubtitle(data['Specialization'] ?? 'Unknown Specialization'),
      ],
    );
  }

  Widget _buildDividerWithSpacing() {
    return Column(
      children: const [
        SizedBox(height: 32),
        Divider(color: Colors.black),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xff5B50A0),
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xff5B50A0),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          data['Medical Background'] ?? 'No description available',
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildClinicSection(Map<String, dynamic> data) {
    final clinics = data['clinics'] as List<dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clinic Locations',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff5B50A0),
              ),
            ),
            // Keep existing PopupMenuButton
          ],
        ),
        const SizedBox(height: 20),
        if (clinics != null && clinics.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              return _buildClinicCard(clinics[index]);
            },
          )
        else
          Text(
            'No clinics available',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _buildClinicCard(Map<String, dynamic> clinic) {
    final healthInstitution =
        clinic['Health-Institution'] as Map<String, dynamic>?;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E6ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff5B50A0).withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section with clinic name and appointment type
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff5B50A0).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff5B50A0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Color(0xff5B50A0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        healthInstitution?['Health-Institution-Name'] ??
                            'Unknown Clinic',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff5B50A0),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: clinic['isAppointmentBased']
                              ? const Color(0xFFE3F2FD)
                              : const Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          clinic['isAppointmentBased']
                              ? 'By Appointment'
                              : 'Walk-in',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: clinic['isAppointmentBased']
                                ? const Color(0xFF1976D2)
                                : const Color(0xFF689F38),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Details section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.location_on_rounded,
                  clinic['Clinic-Address'] ?? 'No address available',
                  const Color(0xFF6B7280),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.phone_rounded,
                  clinic['Clinic-ContactNumber'] ?? 'No contact available',
                  const Color(0xFF6B7280),
                ),
                if (clinic['Clinic-OpenHours'] != null) ...[
                  const SizedBox(height: 12),
                  _buildScheduleSection(clinic['Clinic-OpenHours']),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xff5B50A0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: const Color(0xff5B50A0)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: textColor,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection(Map<String, dynamic> schedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xff5B50A0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: Color(0xff5B50A0),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Schedule',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...schedule.entries.map((e) => Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      '${e.key}:',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${e.value}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // List<Map<String, dynamic>> _filterClinics(
  //     List<Map<String, dynamic>> clinics, String filter) {
  //   if (filter == 'all') {
  //     return clinics;
  //   }

  //   return clinics.where((clinic) {
  //     switch (filter) {
  //       case 'hospital':
  //         return clinic['type'] == 'Hospital';
  //       case 'private':
  //         return clinic['type'] == 'Private Practice';
  //       case 'virtual':
  //         return clinic['type'] == 'Virtual';
  //       default:
  //         return false;
  //     }
  //   }).toList();
  // }

  // Widget _buildInfoRow(IconData icon, String text, Color textColor) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Icon(
  //         icon,
  //         size: 18,
  //         color: const Color(0xff5B50A0),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: Text(
  //           text,
  //           style: GoogleFonts.poppins(
  //             fontSize: 13,
  //             color: textColor,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void _showClinicDetails(Map<String, dynamic> clinic) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => DraggableScrollableSheet(
  //       initialChildSize: 0.7,
  //       minChildSize: 0.5,
  //       maxChildSize: 0.95,
  //       builder: (_, controller) => Container(
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //         ),
  //         padding: const EdgeInsets.all(20),
  //         child: ListView(
  //           controller: controller,
  //           children: [
  //             // ... Detailed clinic information
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // IconData _getClinicIcon(String type) {
  //   switch (type) {
  //     case 'Hospital':
  //       return Icons.local_hospital;
  //     case 'Virtual':
  //       return Icons.videocam;
  //     case 'Private Practice':
  //       return Icons.medical_services;
  //     default:
  //       return Icons.local_hospital;
  //   }
  // }

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'Primary':
  //       return Colors.green;
  //     case 'Secondary':
  //       return Colors.orange;
  //     case 'By Appointment':
  //       return Colors.blue;
  //     case 'Available':
  //       return Colors.green;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  // List<Widget> _buildScheduleRows(Map<String, String> schedule) {
  //   return schedule.entries
  //       .map(
  //         (e) => Padding(
  //           padding: const EdgeInsets.only(bottom: 4),
  //           child: Row(
  //             children: [
  //               Container(
  //                 width: 80,
  //                 child: Text(
  //                   '${e.key}:',
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 e.value,
  //                 style: GoogleFonts.poppins(fontSize: 14),
  //               ),
  //             ],
  //           ),
  //         ),
  //       )
  //       .toList();
  // }

  // Widget _buildClinicInfoRow(IconData icon, String text) {
  //   return Row(
  //     children: [
  //       Icon(icon, size: 16, color: Colors.grey[600]),
  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: Text(
  //           text,
  //           style: GoogleFonts.poppins(fontSize: 14),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
