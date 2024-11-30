import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:provider/provider.dart';
import 'dart:io';

import '../modals/Users.dart';
import '../sevices/ThameProvider.dart';
import '../sevices/UserProvider.dart';

class EditProfileScreen extends StatefulWidget {
  final CustomUser user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late int _age;
  late double _weight;
  late double _height;
  late int _targetCalories;
  File? _image; // For picked image
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
    _age = widget.user.age;
    _weight = widget.user.weight;
    _height = widget.user.height;
    _targetCalories = widget.user.targetCalories;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'profile_images/${widget.user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.greenAccent : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.teal,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.greenAccent : Colors.white,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : (widget.user.profileImageUrl != null
                            ? NetworkImage(widget.user.profileImageUrl!)
                            : AssetImage('assets/profile_placeholder.png')) as ImageProvider,
                        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Tap to change profile picture',
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        color: isDarkMode ? Colors.white54 : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextFormField(
                      label: 'Name',
                      initialValue: _name,
                      onSaved: (value) {
                        _name = value ?? _name;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 10),
                    _buildTextFormField(
                      label: 'Email',
                      initialValue: _email,
                      onSaved: (value) {
                        _email = value ?? _email;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 10),
                    _buildNumberFormField(
                      label: 'Age',
                      initialValue: _age.toString(),
                      onSaved: (value) {
                        _age = int.parse(value!);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 10),
                    _buildNumberFormField(
                      label: 'Weight (kg)',
                      initialValue: _weight.toString(),
                      onSaved: (value) {
                        _weight = double.parse(value!);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 10),
                    _buildNumberFormField(
                      label: 'Height (cm)',
                      initialValue: _height.toString(),
                      onSaved: (value) {
                        _height = double.parse(value!);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 10),
                    _buildNumberFormField(
                      label: 'Target Calories',
                      initialValue: _targetCalories.toString(),
                      onSaved: (value) {
                        _targetCalories = int.parse(value!);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          _formKey.currentState!.save();
                          widget.user.name = _name;
                          widget.user.email = _email;
                          widget.user.age = _age;
                          widget.user.weight = _weight;
                          widget.user.height = _height;
                          widget.user.targetCalories = _targetCalories;

                          if (_image != null) {
                            String? imageUrl = await _uploadImage(_image!);
                            if (imageUrl != null) {
                              widget.user.profileImageUrl = imageUrl;
                            }
                          }

                          await userProvider.addUser(widget.user);
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.greenAccent : Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.greenAccent : Colors.teal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    required bool isDarkMode,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      style: TextStyle(color: isDarkMode ? Colors.greenAccent : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white54 : Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? Colors.greenAccent : Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberFormField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
    required bool isDarkMode,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty || double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
      style: TextStyle(color: isDarkMode ? Colors.greenAccent : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white54 : Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? Colors.greenAccent : Colors.teal,
          ),
        ),
      ),
    );
  }
