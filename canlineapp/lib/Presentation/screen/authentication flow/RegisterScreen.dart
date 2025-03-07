import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const Color primaryColor = Color(0xFF5B50A0);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;
  String currentPatientTypeOption = 'Outpatient';
  String currentSexOption = 'Male';
  DateTime? selectedDate;
  late bool _obscurePassword;
  String _selectedCancerType = "none";
  bool isaccepted = false;
  bool _hasShownTnC = false;

  @override
  void initState() {
    super.initState();
    _obscurePassword = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasShownTnC) {
      _hasShownTnC = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Terms and Conditions',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: RegisterScreen.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              'Welcome to CanLine',
                              'By accessing and using the CanLine application, you agree to be bound by these Terms and Conditions. Please read them carefully before proceeding with registration.',
                            ),
                            _buildSection(
                              '1. LICENSE GRANT',
                              '''Subject to your compliance with this Agreement, the Company grants you a limited, non-exclusive, non-transferable, and revocable license to install and use the Software for personal or professional healthcare-related purposes, strictly in accordance with applicable laws and regulations.''',
                            ),
                            _buildSection(
                              '2. RESTRICTIONS ON USE',
                              '''You agree not to:
\u2022The medical information you provide will be used for patient care coordination.
\u2022While we maintain strict privacy standards, no method of electronic storage is 100% secure.
\u2022You agree to provide accurate medical history and current health status information.''',
                            ),
                            _buildSection(
                              '3.  HEALTHCARE DISCLAIMER',
                              '''The Software is intended to assist healthcare professionals and patients but is not a substitute for professional medical advice, diagnosis, or treatment. You should always seek the advice of a qualified healthcare provider before making any medical decisions. The Company is not responsible for any adverse outcomes resulting from reliance on the Software. The User acknowledges that the Software may contain errors or limitations that could impact its accuracy and should not be solely relied upon for critical healthcare decisions.
''',
                            ),
                            _buildSection(
                              '4.  DATA PRIVACY AND SECURITY',
                              '''\u2022 The Company collects, stores, and processes personal and health-related information through the Software. By using the Software, users consent to the Company's collection and use of such data as outlined in the [Privacy Policy].
\u2022 The Company is committed to implementing industry-standard security measures to protect user data. However, it does not guarantee absolute security against data breaches, and users are responsible for taking necessary precautions to protect their information.
\u2022 The Company ensures compliance with applicable data protection laws, including but not limited to HIPAA (for U.S. users) and GDPR (for EU users).
\u2022 The Company reserves the right to anonymize and aggregate collected data for analytics, research, and product development while ensuring that no personally identifiable information is disclosed.''',
                            ),
                            _buildSection(
                              '5. UPDATES, MODIFICATIONS, AND SUPPORT',
                              '''\u2022 The Company reserves the right to update, modify, or discontinue the Software at any time without notice. Updates may be required for continued use.
\u2022 The Company is not obligated to provide technical support or maintenance services but may do so at its discretion.
              ''',
                            ),
                            _buildSection(
                              '6. TERMINATION',
                              '''This Agreement is effective until terminated by you or the Company. Your rights under this Agreement will automatically terminate if you fail to comply with any terms. Upon termination, you must cease all use of the Software and delete all copies. The Company reserves the right to suspend or terminate access without liability if it determines that your use of the Software poses a risk to security, legal compliance, or operational integrity.
''',
                            ),
                            _buildSection(
                              '7. DISCLAIMER OF WARRANTIES',
                              '''\u2022 The Software is provided "as is" and "as available" without warranties of any kind, either express or implied.
\u2022 The Company does not warrant that the Software will be free from defects, errors, viruses, or interruptions.
\u2022 The Company disclaims all warranties, including but not limited to merchantability, fitness for a particular purpose, and non-infringement.''',
                            ),
                            _buildSection(
                              '8. LIMITATION OF LIABILITY',
                              '''To the fullest extent permitted by law, the Company shall not be liable for any direct, indirect, incidental, consequential, or special damages arising from the use or inability to use the Software. This includes but is not limited to loss of data, revenue, or profits, business interruption, and unauthorized access to personal data.  ''',
                            ),
                            _buildSection(
                              '9. COMPLIANCE WITH LAWS',
                              '''
\u2022 Users are responsible for ensuring that their use of the Software complies with all applicable local, state, and federal laws, including healthcare regulations.
\u2022 The Company does not assume liability for any misuse of the Software that results in non-compliance with healthcare regulations. ''',
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setModalState) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isaccepted,
                                          onChanged: (bool? value) {
                                            setModalState(() {
                                              isaccepted = value ?? false;
                                            });
                                          },
                                          activeColor:
                                              RegisterScreen.primaryColor,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'I have read and agree to these Terms and Conditions',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: isaccepted
                                          ? () {
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isaccepted
                                            ? RegisterScreen.primaryColor
                                            : Colors.grey,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Accept Terms',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: RegisterScreen.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  final List<DropdownMenuItem<String>> _dropdownItems = [
    DropdownMenuItem(value: "none", child: Text("None")),
    DropdownMenuItem(value: "Breast Cancer", child: Text("Breast Cancer")),
    DropdownMenuItem(value: "Cervical cancer", child: Text("Cervical cancer")),
    DropdownMenuItem(value: "Liver cancer", child: Text("Liver cancer")),
    DropdownMenuItem(value: "Lung Cancer", child: Text("Lung Cancer")),
    DropdownMenuItem(value: "Prostate Cancer", child: Text("Prostate Cancer")),
    DropdownMenuItem(
        value: "Endometrial  Cancer", child: Text("Endometrial  Cancer")),
    DropdownMenuItem(
        value: "Colorectal cancer", child: Text("Colorectal cancer")),
  ];

  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final _controllers = List.generate(10, (_) => TextEditingController());
  final supabase = Supabase.instance.client;

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  Future<void> signup() async {
    // Check internet connection first
    final hasInternet = await _checkInternetConnection();
    if (!hasInternet) {
      _showError(
          'No internet connection. Please check your network and try again.');
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        password: _controllers[9].text.trim(),
        email: _controllers[8].text.trim(),
        data: {
          'firstname': _controllers[0].text.trim(),
          'lastname': _controllers[1].text.trim(),
          'middlename': _controllers[2].text.trim(),
          'suffix': _controllers[3].text.trim(),
          'sex': currentSexOption,
          'occupation': _controllers[4].text.trim(),
          'current_address': _controllers[5].text.trim(),
          'city': _controllers[6].text.trim(),
          'province': _controllers[7].text.trim(),
          'date_of_birth': selectedDate?.toIso8601String() ?? '',
          'cancer_type': _selectedCancerType,
        },
      );

      if (!mounted) return;

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Registered successfully! You may proceed to login.')),
        );
        context.go('/');
      } else {
        throw AuthException('Sign-up failed. Please try again.');
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Unexpected Error: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars(); // Clear existing snackbars
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE53935),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 16,
          left: 16,
        ),
        elevation: 4,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
          tooltip: 'Go back',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Create an Account',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: RegisterScreen.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Stepper(
                  steps: _getSteps(),
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _handleStepContinue,
                  onStepCancel: _handleStepCancel,
                  controlsBuilder: (context, details) =>
                      _buildStepperControls(details),
                  onStepTapped: (value) => setState(() => _currentStep = value),
                  physics: const ClampingScrollPhysics(),
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  stepIconBuilder: (stepIndex, stepState) {
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: stepState == StepState.complete ||
                                stepIndex <= _currentStep
                            ? RegisterScreen.primaryColor
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: stepState == StepState.complete
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : Text(
                                '${stepIndex + 1}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleStepContinue() {
    final isLastStep = _currentStep == _getSteps().length - 1;
    bool isValid = _formKeys[_currentStep].currentState?.validate() ?? false;

    if (_currentStep == 3) {
      if (_controllers[0].text.isEmpty) {
        isValid = false;
        _showError('Please enter your First Name');
        return;
      }
      if (_controllers[1].text.isEmpty) {
        isValid = false;
        _showError('Please enter your Last Name');
        return;
      }
      if (_controllers[4].text.isEmpty) {
        isValid = false;
        _showError('Please enter your Occupation');
        return;
      }
      if (selectedDate == null) {
        isValid = false;
        _showError('Please select your Date of Birth');
        return;
      }
      if (_selectedCancerType == "none") {
        isValid = false;
        _showError('Please select the type of cancer');
        return;
      }
    }

    if (isValid) {
      if (isLastStep) {
        signup();
      } else {
        setState(() => _currentStep += 1);
      }
    }
  }

  void _handleStepCancel() {
    setState(() {
      if (_currentStep == 0) {
        context.go('/');
      } else {
        _currentStep -= 1;
      }
    });
  }

  Widget _buildStepperControls(ControlsDetails details) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: RegisterScreen.primaryColor,
                elevation: 2,
              ),
              child: Text(
                _currentStep == 3 ? 'Create Account' : 'Continue',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (_currentStep > 0) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: details.onStepCancel,
              child: Text(
                'Back',
                style: GoogleFonts.poppins(
                  color: RegisterScreen.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        isActive: _currentStep >= 0,
        title: const Text('Step 1'),
        subtitle: const Text('Personal Information'),
        content: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField('First Name*', _controllers[0])),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 100,
                      child: _buildTextField('Suffix', _controllers[3],
                          isRequired: false)),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField('Middle Name', _controllers[2],
                  isRequired: false),
              const SizedBox(height: 20),
              _buildTextField('Last Name*', _controllers[1]),
              const SizedBox(height: 20),
              _buildTextField('Occupation*', _controllers[4]),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 1,
        title: const Text('Step 2'),
        subtitle: const Text('Address'),
        content: Form(
          key: _formKeys[1],
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField('Current Address*', _controllers[5]),
              const SizedBox(height: 20),
              _buildTextField('City*', _controllers[6]),
              const SizedBox(height: 20),
              _buildTextField('Province*', _controllers[7]),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 2,
        title: const Text('Step 3'),
        subtitle: const Text('Account Information'),
        content: Form(
          key: _formKeys[2],
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTextField('Email Address*', _controllers[8]),
              const SizedBox(height: 20),
              _buildPasswordField('Password', _controllers[9]),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep >= 3,
        title: const Text('Step 4'),
        subtitle: const Text('Medical Information'),
        content: Form(
          key: _formKeys[3],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildDatePicker('Birthday*', selectedDate, (date) {
                setState(() => selectedDate = date);
              }),
              const SizedBox(height: 20),
              _buildRadioGroup('Sex*', ['Male', 'Female'], currentSexOption,
                  (value) {
                setState(() => currentSexOption = value!);
              }),
              const SizedBox(height: 20),
              _buildDropdown(
                  'Type of Cancer*', _selectedCancerType, _dropdownItems,
                  (value) {
                setState(() => _selectedCancerType = value!);
              }),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool isRequired = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'This field is required';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          floatingLabelStyle: GoogleFonts.poppins(
            color: RegisterScreen.primaryColor,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        if (!RegExp(r'[A-Z]').hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!RegExp(r'[a-z]').hasMatch(value)) {
          return 'Password must contain at least one lowercase letter';
        }
        if (!RegExp(r'[0-9]').hasMatch(value)) {
          return 'Password must contain at least one number';
        }
        return null;
      },
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(color: RegisterScreen.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon:
              Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Widget _buildDropdown(String labelText, String value,
      List<DropdownMenuItem<String>> items, ValueChanged<String?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        icon: Icon(Icons.arrow_drop_down, color: RegisterScreen.primaryColor),
      ),
    );
  }

  Widget _buildRadioGroup(String labelText, List<String> options,
      String groupValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          ...options.map((option) {
            return RadioListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                option,
                style: GoogleFonts.poppins(fontSize: 15),
              ),
              value: option,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: RegisterScreen.primaryColor,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String labelText, DateTime? selectedDate,
      ValueChanged<DateTime?> onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
            style: GoogleFonts.poppins(
                fontSize: 16, color: RegisterScreen.primaryColor)),
        const SizedBox(height: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(color: RegisterScreen.primaryColor),
            fixedSize: Size(double.infinity, 50),
          ),
          onPressed: () async {
            final dateTime = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            onDateSelected(dateTime);
          },
          child: Text(
            selectedDate == null
                ? 'Select Date of Birth*'
                : 'Date of Birth: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            style: GoogleFonts.poppins(
                color: RegisterScreen.primaryColor,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
