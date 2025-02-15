import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Benefitsdetails extends StatefulWidget {
  final String fid;

  const Benefitsdetails({super.key, required this.fid});

  @override
  State<Benefitsdetails> createState() => _BenefitsdetailsState();
}

class _BenefitsdetailsState extends State<Benefitsdetails> {
  late List<bool> _isOpen;

  Future<PostgrestList> _benefitsDetails() async {
    final benfits = await Supabase.instance.client
        .from('Financial-Institution-Benefit')
        .select()
        .eq('Financial-Institution-Benefits-ID', widget.fid);

    return benfits;
  }

  Future<PostgrestList> _requirementsDetails() async {
    final requirements = await Supabase.instance.client
        .from('Financial-Institution-Requirement')
        .select()
        .eq("Fiancial-Institution-ID", widget.fid);

    return requirements;
  }

  Future<PostgrestList> _ProcessDetails() async {
    final requirements = await Supabase.instance.client
        .from('financialinstitutionprocess')
        .select()
        .eq("financialinstitutionid", widget.fid)
        .order('ProcessNumber', ascending: true);

    return requirements;
  }

  @override
  void initState() {
    super.initState();
    _isOpen = List.generate(3, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff5B50A0),
                ),
                'What Benefits Offer for Cancer Patients?',
              ),
              const SizedBox(height: 20),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                  'Cancer patients admitted to this accredited hospitals can access the following benefits:'),
              const SizedBox(height: 40),

              //TODO Make this Dynamic
              ExpansionPanelList(
                dividerColor: Colors.black,
                expansionCallback: (i, isOpen) {
                  setState(() {
                    _isOpen[i] = !_isOpen[i];
                  });
                },
                children: [
                  ExpansionPanel(
                    backgroundColor: Colors.white,
                    headerBuilder: (context, isOpen) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5B50A0),
                            ),
                            'Benefit 1: Inpatient Care Package'),
                      );
                    },
                    body: Column(
                      spacing: 40,
                      children: [
                        Text(
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            "\u2022 Coverage for hospital room and board, drugs and medicines, laboratory exams, operating room, and professional fees."),
                        Text(
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            "\u2022 Drugs and Medicines: Includes chemotherapy drugs administered during hospitalization."),
                        Text(
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            "\u2022 Laboratory and Diagnostic Procedures: Coverage for necessary tests such as biopsies, imaging (e.g., CT scan, MRI), and blood tests."),
                        Text(
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            "\u2022 Doctors’ Professional Fees: Includes fees for oncologists, surgeons, and other specialists."),
                        Text(
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            "\u2022 Operating Room Fees: Coverage for surgeries such as tumor removal or related procedures."),
                      ],
                    ),
                    isExpanded: _isOpen[0],
                  ),
                  ExpansionPanel(
                    backgroundColor: Colors.white,
                    headerBuilder: (context, isOpen) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5B50A0),
                            ),
                            'Benefit 2: Outpatient Care Package'),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        spacing: 30,
                        children: [
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022  Outpatient Chemotherapy Package: Coverage for approved chemotherapy drugs and administration."),
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022  For specific cancers (e.g., breast, lung, colorectal cancers)."),
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022 Outpatient Radiation Therapy Package: Support for radiotherapy sessions to manage cancer."),
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022 Palliative Radiation Therapy Package: Covers pain relief and symptom management for advanced-stage cancer."),
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022 Coverage: ₱3,000 per session (up to 10 sessions)."),
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022 Outpatient Hemodialysis: For cancer patients with kidney complications requiring dialysis."),
                          Text(
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              "\u2022 Palliative and Supportive Care: Includes pain management, symptom relief, and end-of-life care."),
                        ],
                      ),
                    ),
                    isExpanded: _isOpen[1],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(height: 10),
              const SizedBox(height: 20),
              Text(
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5B50A0),
                  ),
                  'Requirements to Avail of Benefits'),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  'To avail of these benefits, cancer patients must meet certain requirements:'),
              const SizedBox(height: 20),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5B50A0),
                  ),
                  'General Requirements:'),
              const SizedBox(height: 20),

              // TODO Add the Requirements
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _requirementsDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          (snapshot.data as List).isEmpty) {
                        return const Center(
                            child: Text('No requirements found.'));
                      } else {
                        final data = snapshot.data as List<dynamic>;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true, // Important to use inside Column
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return ListTile(
                              title: Text(
                                "${index + 1}.) ${item['Financial-Institution-Requirements-Name'].toString()}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                item['Financial-Institution-Requirements-Desc']
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(height: 10),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5B50A0),
                  ),
                  'Step-by-Step Guide to Avail of the Benefits'),

              const SizedBox(height: 20),
              // TODO Make this Dynamic
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _ProcessDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          (snapshot.data as List).isEmpty) {
                        return const Center(child: Text('No Process found.'));
                      } else {
                        final data = snapshot.data as List<dynamic>;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true, // Important to use inside Column
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return ListTile(
                              title: Text(
                                "Step ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                item['financialinstitutionprocessdesc']
                                    .toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(height: 10),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5B50A0),
                  ),
                  "Notes and Reminders"),
              const SizedBox(height: 20),

              // TODO Make this Dynamic
              Column(
                children: [
                  Text(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      "1. Accredited Facilities: Ensure treatments are received in PhilHealth-accredited hospitals and clinics to qualify for benefits."),
                  Text(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      "2. Active Membership: Contributions must be updated to avail of benefits. Members under the Indigent or Senior Citizen categories are automatically covered."),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
