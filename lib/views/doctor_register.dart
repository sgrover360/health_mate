import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_mate/pages/login/login_controller.dart';
import 'package:intl/intl.dart';

import 'AuthenticationCompletePage.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final LoginController _controller = LoginController();
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _specializationController = TextEditingController();
  TextEditingController _medicalIdController = TextEditingController();
  TextEditingController _researchPaperURLController = TextEditingController();

  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _specializationController.dispose();
    _medicalIdController.dispose();
    _researchPaperURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registration")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildTextField(_firstNameController, "First Name"),
              buildTextField(_emailController, "Email"),
              buildTextField(_passwordController, "Password", isPassword: true),
              buildTextField(_confirmPasswordController, "Confirm Password", isPassword: true),
              buildTextField(_specializationController, "Specialization"),
              buildTextField(_medicalIdController, "Medical ID"),
              buildDateField(),
              buildTextField(_researchPaperURLController, "Research Paper URL (optional)", isRequired: false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit Information"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool isPassword = false, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget buildDateField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Date of Birth'),
      controller: TextEditingController(text: _dateOfBirth != null ? _dateFormat.format(_dateOfBirth!) : ''),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // Prevent opening default keyboard
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked != _dateOfBirth) {
          setState(() {
            _dateOfBirth = picked;
          });
        }
      },
    );
  }
/*
  void _submitForm() {
    if (_validateForm()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationCompletePage()),
      );
    }
  }*/

  void _submitForm() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields correctly")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords don't match!")),
      );
      return;
    }

    try {
      Map<String, dynamic> doctorData = {
        'name': _firstNameController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'medicalId': _medicalIdController.text.trim(), // Assuming you have this field
        'researchPaperURL': _researchPaperURLController.text.trim(),
        'dateOfBirth': _dateOfBirth,//?.toIso8601String(),
        // Do not include password here
      };

      // Call registerDoctor method from the controller
      await _controller.registerDoctor(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        doctorData,
      );

      // Clear the fields after successful registration
      _firstNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _specializationController.clear();
      _medicalIdController.clear();
      _researchPaperURLController.clear();
      _dateOfBirth = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doctor account created successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthenticationCompletePage()),
      );

      // Navigate to the next page or perform other actions as needed
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ex.message ?? "Registration failed")),
      );
    }
  }



  bool _validateForm() {
    bool isValid = _firstNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _specializationController.text.isNotEmpty &&
        _medicalIdController.text.isNotEmpty &&
        _dateOfBirth != null;
    // Add other validation as needed

    if (!isValid) {
      // Show an error message, e.g., using a snackbar
      return false;
    }
    return true;
  }
}
