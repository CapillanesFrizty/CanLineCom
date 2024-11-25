import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class MoreSignupScreen extends StatefulWidget {
  const MoreSignupScreen({super.key});

  @override
  State<MoreSignupScreen> createState() => _MoreSignupScreenState();
  static const Color _primaryColor = Color(0xFF5B50A0);
}

class _MoreSignupScreenState extends State<MoreSignupScreen> {
  String patientType = '';
  String sex = '';
  bool hasNoCancerType = false;
  DateTime? selectedDate;
  String? selectedCancerType;
  final Map<String, List<String>> cancerTypesGrouped = {
    'B': ["Breast Cancer", "Bladder Cancer", "Brain & CNS Cancer"],
    'C': ["Cervical Cancer", "Colorectal Cancer"],
    'E': ["Esophageal Cancer"],
    'L': ["Lung Cancer", "Leukemia"],
    'M': ["Melanoma", "Multiple Myeloma"],
    'N': ["Non-Hodgkin Lymphoma"],
    'O': ["Ovarian Cancer"],
    'P': ["Pancreas Cancer", "Prostate Cancer"],
    'S': ["Stomach Cancer"],
    'T': ["Thyroid Cancer"],
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showCancerTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the modal full-screen and scrollable
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Cancer Type',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MoreSignupScreen._primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: cancerTypesGrouped.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        String group = cancerTypesGrouped.keys.elementAt(index);
                        List<String> cancers = cancerTypesGrouped[group]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                group,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ...cancers.map((cancer) {
                              return ListTile(
                                title:
                                    Text(cancer, style: GoogleFonts.poppins()),
                                onTap: () {
                                  setState(() {
                                    selectedCancerType = cancer;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            }),
                          ],
                        );
                      },
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
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildPatientTypeSection(),
              const SizedBox(height: 20),
              _buildBirthdayField(),
              const SizedBox(height: 20),
              _buildSexSection(),
              const SizedBox(height: 20),
              _buildCancerTypeField(),
              _buildNoCancerTypeCheckbox(),
              const SizedBox(height: 10),
              _buildSpecifyCancerTypeField(),
              const SizedBox(height: 30),
              _buildFinishButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0), // Adjust the height here
      child: AppBar(
        title: Container(
          margin: const EdgeInsets.only(
              top: 20.0), // Add margin to vertically center
          child: Text(
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: MoreSignupScreen._primaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: MoreSignupScreen._primaryColor),
            onPressed: () => context.go('/'),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Type',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: MoreSignupScreen._primaryColor,
          ),
        ),
        const SizedBox(height: 10), // Add spacing between label and options
        Column(
          children: [
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero, // Align with the label
              title: Text(
                'Inpatient',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              value: 'Inpatient',
              groupValue: patientType,
              onChanged: (value) {
                setState(() {
                  patientType = value!;
                });
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero, // Align with the label
              title: Text(
                'Outpatient',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              value: 'Outpatient',
              groupValue: patientType,
              onChanged: (value) {
                setState(() {
                  patientType = value!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBirthdayField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: selectedDate == null
                ? 'Birthday: 00/00/0000'
                : 'Birthday: ${selectedDate!.toLocal()}'.split(' ')[0],
            labelStyle: GoogleFonts.poppins(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSexSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sex',
          style: GoogleFonts.poppins(
              fontSize: 16, color: MoreSignupScreen._primaryColor),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Text('Male', style: GoogleFonts.poppins(fontSize: 14)),
                value: 'Male',
                groupValue: sex,
                onChanged: (value) {
                  setState(() {
                    sex = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Text('Female', style: GoogleFonts.poppins(fontSize: 14)),
                value: 'Female',
                groupValue: sex,
                onChanged: (value) {
                  setState(() {
                    sex = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancerTypeField() {
    return GestureDetector(
      onTap: () => _showCancerTypeSelector(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: selectedCancerType ?? 'Cancer Type',
            labelStyle: GoogleFonts.poppins(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoCancerTypeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: hasNoCancerType,
          onChanged: (value) {
            setState(() {
              hasNoCancerType = value!;
            });
          },
        ),
        Text(
          "I didn't found my cancer type",
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  Widget _buildSpecifyCancerTypeField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'If not been found please specify:',
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Finish action
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color: MoreSignupScreen._primaryColor), // Add border color here
          ),
        ),
        child: Text(
          'Finish',
          style: GoogleFonts.poppins(
              fontSize: 16, color: MoreSignupScreen._primaryColor),
        ),
      ),
    );
  }
}
