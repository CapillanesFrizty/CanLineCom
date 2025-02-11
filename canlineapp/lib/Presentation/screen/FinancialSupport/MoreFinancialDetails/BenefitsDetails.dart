import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Benefitsdetails extends StatefulWidget {
  final String fid;

  const Benefitsdetails({super.key, required this.fid});

  @override
  State<Benefitsdetails> createState() => _BenefitsdetailsState();
}

class _BenefitsdetailsState extends State<Benefitsdetails> {
  late List<bool> _isOpen;
  Future<void> _benefitsDetails() async {}

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
                  'Cancer patients admitted to PhilHealth-accredited hospitals can access the following benefits:'),
              const SizedBox(height: 40),
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
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  '1. PhilHealth Member Registration Form (PMRF): Fully accomplished and signed.'),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  '2. PhilHealth ID or Member Data Record (MDR): To verify membership.'),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  '3. Proof of Contribution Payments, For employed members: Latest PhilHealth contributions from the employer. For self-employed or voluntary members: Official receipt or proof of contribution payment.'),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  '4. Valid ID: Government-issued ID or other proof of identity.'),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  '5. Doctor’s recommendation or referral or Medical abstract detailing the cancer diagnosis and treatment plan.'),
              const SizedBox(height: 20),
              Divider(height: 10),
              Text(
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5B50A0),
                  ),
                  'Step-by-Step Guide to Avail of PhilHealth Benefits'),
              Column(
                children: [
                  Text(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      '1. Visit a PhilHealth-accredited hospital or facility offering cancer-related treatments.'),
                  Text(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      '2. Present the following PhilHealth ID or MDR, Valid ID. Proof of contributions.'),
                  Text(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      '3. Submit necessary medical documents (e.g., doctor’s referral, medical abstract).'),
                  Text(
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      '4. Ensure the facility files your claims directly with PhilHealth to reduce upfront expenses.'),
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
        ),
      ),
    );
  }
}
