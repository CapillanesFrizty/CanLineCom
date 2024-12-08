import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});
  static const Color _primaryColor = Color(0xFF5B50A0);

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

// Available options for the radio buttons
List<String> patientType = ['', 'Outpatient', 'Inpatient'];
List<String> sex = ['', 'Male', 'Female'];

class _RegisterscreenState extends State<Registerscreen> {
  // Current Step of stepper
  int _currentStep = 0;

  // Options for Patient Type and sex
  String currentPatientTypeOption = patientType[0];
  String currentSexOption = sex[0];

  // Selected Date
  DateTime? selectedDate;

  // Obscure password variable
  var _obscurePassword;

  // Dropdown initial Value
  String _DropdownValue = "none";
  // Dropdown items
  static const List<DropdownMenuItem<String>> _dropdownitems = [
    DropdownMenuItem(
      value: "none",
      child: Text("Select an option"), // Display text for "none"
    ),
    DropdownMenuItem(
      value: "Breast Cancer",
      child: Text("Breast Cancer"),
    ),
    DropdownMenuItem(
      value: "Cervical Cancer",
      child: Text("Cervical Cancer"),
    ),
    DropdownMenuItem(
      value: "Lung Cancer",
      child: Text("Lung Cancer"),
    ),
    DropdownMenuItem(
      value: "Prostate Cancer",
      child: Text("Prostate Cancer"),
    ),
    DropdownMenuItem(
      value: "Ovarian cancer",
      child: Text("Prostate Cancer"),
    ),
  ];

  // Textfield Controllers and form key
  final _formKeystep = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  late final TextEditingController _fname;
  late final TextEditingController _lname;
  late final TextEditingController _mname;
  late final TextEditingController _suffix;
  late final TextEditingController _occupation;
  late final TextEditingController _citizenship;
  late final TextEditingController _currentAddress;
  late final TextEditingController _city;
  late final TextEditingController _province;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _fname = TextEditingController();
    _lname = TextEditingController();
    _mname = TextEditingController();
    _suffix = TextEditingController();
    _occupation = TextEditingController();
    _citizenship = TextEditingController();
    _currentAddress = TextEditingController();
    _city = TextEditingController();
    _province = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();

    _obscurePassword = true;
  }

  // Init Supabase Client
  final supabase = Supabase.instance.client;

  // Sign Up Function
  Future<void> signup() async {
    try {
      // Attempt to sign up with validated data
      final response = await supabase.auth.signUp(
        password: _password.text.trim(),
        email: _email.text.trim(),
        data: {
          'firstname': _fname.text.trim(),
          'lastname': _lname.text.trim(),
          'middlename': _mname.text.trim(),
          'suffix': _suffix.text.trim(),
          'sex': currentSexOption,
          'occupation': _occupation.text.trim(),
          'citizenship': _citizenship.text.trim(),
          'current_address': _currentAddress.text.trim(),
          'city': _city.text.trim(),
          'province': _province.text.trim(),
          'patient_type': currentPatientTypeOption,
          'date_of_birth': selectedDate?.toIso8601String() ?? '',
          'cancer_type': _DropdownValue, // Use validated dropdown value
        },
      );

      if (!mounted) return;

      // Check if signup was successful
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
      debugPrint('Error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Navigate back to the previous screen
          },
          tooltip: 'Go back',
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Create an Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Registerscreen._primaryColor,
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
                  steps: getSteps(),
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _handleStepContinue,
                  onStepCancel: _handleStepCancel,
                  controlsBuilder: (context, details) =>
                      _buildStepperControls(details),
                  onStepTapped: (value) {
                    setState(() {
                      _currentStep = value;
                    });
                  },
                  physics:
                      const ClampingScrollPhysics(), // Smooth scrolling inside the Stepper
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handle Step Continue and the Form Validation
  void _handleStepContinue() {
    final isLastStep = _currentStep == getSteps().length - 1;

    bool isValid = _formKeystep[_currentStep].currentState?.validate() ?? false;

    // Additional validation for Step 4 (Medical Information)
    if (_currentStep == 3) {
      // Validate Date of Birth
      if (selectedDate == null) {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your Date of Birth')),
        );
        return;
      }

      // Validate Dropdown Value
      if (_DropdownValue == "none") {
        isValid = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select the type of cancer')),
        );
        return;
      }

      // Add more custom validations if needed
    }

    if (isValid) {
      if (isLastStep) {
        signup();
      } else {
        setState(() {
          _currentStep += 1;
        });
        debugPrint('Next Step');
      }
    } else {
      // If the form is invalid, display a snackbar or handle accordingly
      return;
    }
  }

  // Handle Step Cancel
  void _handleStepCancel() {
    setState(() {
      if (_currentStep == 0) {
        context.go('/');
      } else {
        _currentStep -= 1;
      }
    });
  }

  // Build Stepper Controls
  Widget _buildStepperControls(ControlsDetails details) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Row(
        children: [
          if (_currentStep < 3)
            Expanded(
              child: ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Registerscreen._primaryColor),
                  ),
                  backgroundColor: Registerscreen._primaryColor,
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

          // if (_currentStep == 0 && _currentStep < 3)
          //   Expanded(
          //     child: ElevatedButton(
          //       onPressed: details.onStepCancel,
          //       style: ElevatedButton.styleFrom(
          //         padding: const EdgeInsets.symmetric(vertical: 15),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //           side: const BorderSide(color: Colors.grey),
          //         ),
          //         backgroundColor: Colors.grey,
          //       ),
          //       child: Text(
          //         'Back',
          //         style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          //       ),
          //     ),
          //   ),
          // const SizedBox(width: 12),
          if (_currentStep == 3)
            Expanded(
              child: ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Registerscreen._primaryColor),
                  ),
                  backgroundColor: Registerscreen._primaryColor,
                ),
                child: Text(
                  'Finish',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    return [
      // Step 1 of registration process (Basic Personal Information)
      Step(
        isActive: _currentStep >= 0,
        title: const Text('Step 1'),
        subtitle: const Text('Personal Information'),
        content: Form(
          key: _formKeystep[0],
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(color: Colors.yellow[700]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.yellow[700],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Kindly fill out all required fields (*), leave blank if not applicable.',
                        style: GoogleFonts.poppins(
                          color: Colors.yellow[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextfield('First Name*', _fname),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child:
                        _buildTextfield('Suffix', _suffix, isRequired: false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextfield('Middle Name', _mname, isRequired: false),
              const SizedBox(height: 20),
              _buildTextfield('Last Name*', _lname),
              const SizedBox(height: 20),
              _buildTextfield('Occupation*', _occupation),
            ],
          ),
        ),
      ),

      // Step 2 of registration process (Address)
      Step(
        isActive: _currentStep >= 1,
        label: null,
        subtitle: const Text('Address'),
        title: const Text('Step 2'),
        content: Form(
          key: _formKeystep[1],
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(color: Colors.yellow[700]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.yellow[700],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Kindly fill out all required fields (*), leave blank if not applicable.',
                        style: GoogleFonts.poppins(
                          color: Colors.yellow[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextfield('Citizenship*', _citizenship),
              const SizedBox(height: 20),
              _buildTextfield('Current Address*', _currentAddress),
              const SizedBox(height: 20),
              _buildTextfield('City*', _city),
              const SizedBox(height: 20),
              _buildTextfield('Province*', _province),
            ],
          ),
        ),
      ),

      // Step 3 of registration process (Account Information)
      Step(
        isActive: _currentStep >= 2,
        label: null,
        subtitle: const Text('Account Information'),
        title: const Text('Step 3'),
        content: Form(
          key: _formKeystep[2],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              _buildTextfield('Email Address*', _email),
              const SizedBox(height: 20),
              TextFormField(
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
                  return null; // Validation passed
                },
                controller: _password,
                obscureText: _obscurePassword!,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      GoogleFonts.poppins(color: Registerscreen._primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Registerscreen._primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Registerscreen._primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Registerscreen._primaryColor),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword!
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Step 4 of registration process (Medical Information)
      Step(
        isActive: _currentStep >= 3,
        label: null,
        subtitle: const Text('Medical Information'),
        title: const Text('Step 4'),
        content: Form(
          key: _formKeystep[3],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Warning Sign
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(color: Colors.yellow[700]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.yellow[700],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Kindly fill out all required fields (*), leave blank if not applicable.',
                        style: GoogleFonts.poppins(
                          color: Colors.yellow[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Patient Type
              Text(
                'Patient Type*',
                style: GoogleFonts.poppins(
                  fontSize: 16, // Adjusted to 16 for consistency
                  color: Registerscreen._primaryColor,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero, // Align with the label
                      title: Text(
                        'Outpatient',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: patientType[0],
                      groupValue: currentPatientTypeOption,
                      onChanged: (value) {
                        setState(() {
                          currentPatientTypeOption = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero, // Align with the label
                      title: Text(
                        'Inpatient',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: patientType[1],
                      groupValue: currentPatientTypeOption,
                      onChanged: (value) {
                        setState(() {
                          currentPatientTypeOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Date of Birth
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(
                    color: selectedDate == null
                        ? Registerscreen._primaryColor
                        : Registerscreen._primaryColor,
                  ),
                  fixedSize: Size(double.infinity, 50), // Make it responsive
                ),
                onPressed: () async {
                  final DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (dateTime != null) {
                    setState(() {
                      selectedDate = dateTime;
                    });
                  }
                },
                child: Text(
                  selectedDate == null
                      ? 'Select Date of Birth*'
                      : 'Date of Birth: ${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}',
                  style: GoogleFonts.poppins(
                      color: selectedDate == null
                          ? Registerscreen._primaryColor
                          : Registerscreen._primaryColor,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ),
              // Display error message if Date of Birth is not selected

              const SizedBox(height: 10),
              // Sex
              Text(
                'Sex*',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Registerscreen._primaryColor,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero, // Align with the label
                      title: Text(
                        'Male',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: sex[0],
                      groupValue: currentSexOption,
                      onChanged: (value) {
                        setState(() {
                          currentSexOption = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      contentPadding: EdgeInsets.zero, // Align with the label
                      title: Text(
                        'Female',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      value: sex[1],
                      groupValue: currentSexOption,
                      onChanged: (value) {
                        setState(() {
                          currentSexOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Type of Cancer
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align label and dropdown to the start
                children: [
                  const Text(
                    "Type of Cancer*", // Label text
                    style: TextStyle(
                      color: Registerscreen._primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 8.0), // Spacing between label and dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Dropdown background color
                      border: Border.all(
                          color: Colors.grey, width: 1.5), // Outline color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12), // Padding for the dropdown
                    child: DropdownButton<String>(
                      value: _DropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      iconEnabledColor: Colors.blue,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      items: _dropdownitems,
                      onChanged: _DropdownCallabck,
                      dropdownColor: Colors.white,
                      underline: Container(), // Removes the default underline
                      isExpanded: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ];
  }

  void _DropdownCallabck(String? Selectedvalue) {
    if (Selectedvalue is String) {
      setState(() {
        _DropdownValue = Selectedvalue;
        debugPrint(_DropdownValue);
      });
    }
  }

  Widget _buildTextfield(String labelText, TextEditingController controller,
      {bool isRequired = true}) {
    return TextFormField(
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return 'This Field in Required';
        }
        return null; // Valid if not required or if there's a value
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Registerscreen._primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Registerscreen._primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Registerscreen._primaryColor),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fname.dispose();
    _lname.dispose();
    _mname.dispose();
    _suffix.dispose();
    _occupation.dispose();
    _citizenship.dispose();
    _currentAddress.dispose();
    _city.dispose();
    _province.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
