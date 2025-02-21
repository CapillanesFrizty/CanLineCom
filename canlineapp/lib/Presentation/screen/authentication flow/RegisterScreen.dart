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
  bool _obscurePassword = true;
  String _selectedCancerType = "none";
  String _selectedCitizenship = "none";

  final List<DropdownMenuItem<String>> _dropdownItems = [
    DropdownMenuItem(value: "none", child: Text("Select an option")),
    DropdownMenuItem(value: "Breast Cancer", child: Text("Breast Cancer")),
  ];

  final List<DropdownMenuItem<String>> _citizenshipItems = [
    DropdownMenuItem(value: "none", child: Text("Select an option")),
    DropdownMenuItem(value: "Filipino", child: Text("Filipino")),
    DropdownMenuItem(value: "Foreigner", child: Text("Foreigner")),
  ];

  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final _controllers = List.generate(10, (_) => TextEditingController());
  final supabase = Supabase.instance.client;

  Future<void> signup() async {
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
          'citizenship': _selectedCitizenship,
          'current_address': _controllers[5].text.trim(),
          'city': _controllers[6].text.trim(),
          'province': _controllers[7].text.trim(),
          'patient_type': currentPatientTypeOption,
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $message')));
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
                const SizedBox(height: 20),
                Text(
                  'By creating an account, you agree to our Terms and Conditions and Privacy Policy.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/terms-and-conditions'),
                  child: Text(
                    'Read Terms and Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: RegisterScreen.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
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
              _buildDropdown(
                  'Citizenship*', _selectedCitizenship, _citizenshipItems,
                  (value) {
                setState(() => _selectedCitizenship = value!);
              }),
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
              _buildRadioGroup('Patient Type*', ['Outpatient', 'Inpatient'],
                  currentPatientTypeOption, (value) {
                setState(() => currentPatientTypeOption = value!);
              }),
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
        color: Colors.grey[50],
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
