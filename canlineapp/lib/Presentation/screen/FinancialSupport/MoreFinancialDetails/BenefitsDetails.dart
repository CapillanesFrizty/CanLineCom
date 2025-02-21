import 'package:cancerline_companion/main.dart';
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
  List<bool> _isExpanded = [];

  Future<Map<String, dynamic>> _fetchBenefitsWithInclusions() async {
    // Fetch all benefits for the given institution
    final benefits = await supabase
        .from('Financial-Institution-Benefit')
        .select()
        .eq('Financial-Institution-ID', widget.fid);

    if (benefits.isEmpty) {
      return {}; // Return an empty map if no benefits found
    }

    // Create a Map to store benefits with their corresponding inclusions
    Map<String, dynamic> benefitsMap = {};

    for (var benefit in benefits) {
      final benefitId = benefit['Financial-Institution-Benefits-ID'];

      // Fetch inclusions (benefit details) for the current benefit
      final inclusions = await supabase
          .from('Benefit-Details-Financial-Institution')
          .select()
          .eq("Financial_Benefit", benefitId);

      // Store benefit and its inclusions inside the map
      benefitsMap[benefitId.toString()] = {
        "benefit": benefit,
        "inclusions": inclusions, // Store inclusions properly
      };
    }

    return benefitsMap;
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

              // TODO Add the Benefits
              FutureBuilder(
                future: _fetchBenefitsWithInclusions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || (snapshot.data as Map).isEmpty) {
                    return const Center(child: Text('No benefits found.'));
                  }

                  final data = snapshot.data as Map<String, dynamic>;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data.values.elementAt(index);
                      final benefit = item['benefit'];
                      final inclusions = item['inclusions'];

                      debugPrint('Number of benefits: ${benefit.length}');
                    },
                  );
                },
              ),

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
                        return const Center(child: Text(''));
                      } else {
                        final data = snapshot.data as List<dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap:
                                  true, // Important to use inside Column
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
                            ),
                          ],
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
