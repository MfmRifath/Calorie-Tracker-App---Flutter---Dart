import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import '../../modals/Users.dart';
import '../../modals/Water.dart';
import '../../sevices/AuthService.dart';
import '../../sevices/UserProvider.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeInDown(
          duration: Duration(milliseconds: 800),
          child: Text(
            'Create Account',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ZoomIn(
                        duration: Duration(milliseconds: 800),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                            backgroundColor: Colors.grey[300],
                            child: _profileImage == null
                                ? Icon(Icons.camera_alt, color: Colors.grey[800], size: 30)
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Personal Information'),
                    _buildTextFormField(
                      controller: nameController,
                      labelText: 'Full Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your name';
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: ageController,
                      labelText: 'Age',
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your age';
                        if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Enter a valid age';
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: weightController,
                      labelText: 'Weight (kg)',
                      icon: Icons.monitor_weight,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your weight';
                        if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid weight';
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: heightController,
                      labelText: 'Height (m)',
                      icon: Icons.height,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your height';
                        if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Enter a valid height';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Account Details'),
                    _buildTextFormField(
                      controller: emailController,
                      labelText: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: passwordController,
                      labelText: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: BounceInUp(
                        duration: Duration(milliseconds: 1000),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[700],
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FadeInLeft(
        duration: Duration(milliseconds: 600),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.teal[800]),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: FadeInUp(
        duration: Duration(milliseconds: 700),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon, color: Colors.teal[800]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String name = nameController.text.trim();
    final int age = int.tryParse(ageController.text.trim()) ?? 0;
    final double weight = double.tryParse(weightController.text.trim()) ?? 0.0;
    final double height = double.tryParse(heightController.text.trim()) ?? 0.0;

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firebaseUser = await authService.registerWithEmail(email, password);

      if (firebaseUser != null) {
        CustomUser newUser = CustomUser(
          id: firebaseUser.uid,
          email: email,
          name: name,
          age: age,
          weight: weight,
          height: height,
          waterLog: Water(targetWaterConsumption: 2000, currentWaterConsumption: 0),
          profileImageUrl: _profileImage != null ? _profileImage!.path : null,
        );

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.addUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up successful!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    }
  }
}
