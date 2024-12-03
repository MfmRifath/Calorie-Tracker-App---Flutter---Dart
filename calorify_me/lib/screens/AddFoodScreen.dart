import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modals/Food.dart';

class AddFoodDialog extends StatefulWidget {
  @override
  _AddFoodDialogState createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController foodWeightController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();


  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('food_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = imageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _handleAddFood() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      final food = Food(
        foodName: foodNameController.text,
        calories: int.parse(caloriesController.text),
        protein: double.parse(proteinController.text),
        fat: double.parse(fatController.text),
        foodWeight: double.parse(foodWeightController.text),
        description: descriptionController.text,
        imageUrl: imageUrl,
        carbs: double.parse(carbsController.text),
      );

      await FirebaseFirestore.instance.collection('Food').add(food.toMap());

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Add Food Item',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          image: _imageFile != null
                              ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _imageFile == null
                            ? Center(
                          child: Icon(Icons.camera_alt,
                              size: 50, color: Colors.grey[800]),
                        )
                            : null,
                      ),
                      if (_imageFile != null)
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Icon(Icons.edit, color: Colors.green),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: foodNameController,
                  labelText: 'Food Name',
                  icon: Icons.fastfood,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: descriptionController,
                  labelText: 'Food Description',
                  icon: Icons.description,
                ),
                _buildTextField(
                  controller: caloriesController,
                  labelText: 'Calories',
                  icon: Icons.local_fire_department,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: proteinController,
                  labelText: 'Protein (g)',
                  icon: Icons.restaurant_menu,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
              controller: carbsController,
              labelText: 'Carbs (g)',
              icon: Icons.restaurant_menu,
              keyboardType: TextInputType.number,
            ),

                _buildTextField(
                  controller: fatController,
                  labelText: 'Fat (g)',
                  icon: Icons.bakery_dining,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: foodWeightController,
                  labelText: 'Weight (g)',
                  icon: Icons.line_weight,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 30),
                _isUploading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleAddFood,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.teal.shade500,
                    ),
                    child: Text(
                      'Add Food',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        validator: (value) =>
        value!.isEmpty ? 'Please enter $labelText' : null,
      ),
    );
  }
}