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
  File? _image; // For picked image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email; // Assuming ID is email
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
      return await ref.getDownloadURL(); // Get the uploaded image URL
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!) // Display picked image
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.user.name = _name;
                    widget.user.email = _email;

                    if (_image != null) {
                      String? imageUrl = await _uploadImage(_image!);
                      if (imageUrl != null) {
                        widget.user.profileImageUrl = imageUrl; // Save image URL to user
                      }
                    }

                    await userProvider.addUser(widget.user);
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
    );
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
}
