import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../modals/Food.dart';
import '../sevices/ThameProvider.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController foodWeightController = TextEditingController();

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
    final imageRef =
    storageRef.child('food_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = imageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Food Item',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.greenAccent : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.green,
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
                            size: 50,
                            color: isDarkMode
                                ? Colors.greenAccent
                                : Colors.grey[800]),
                      )
                          : null,
                    ),
                    if (_imageFile != null)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: FloatingActionButton(
                          mini: true,
                          onPressed: _pickImage,
                          backgroundColor: Colors.white,
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
                isDarkMode: isDarkMode,
              ),
              _buildTextField(
                controller: caloriesController,
                labelText: 'Calories',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
              ),
              _buildTextField(
                controller: proteinController,
                labelText: 'Protein (g)',
                icon: Icons.restaurant_menu,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
              ),
              _buildTextField(
                controller: fatController,
                labelText: 'Fat (g)',
                icon: Icons.bakery_dining,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
              ),
              _buildTextField(
                controller: foodWeightController,
                labelText: 'Weight (g)',
                icon: Icons.line_weight,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor:
                    isDarkMode ? Colors.greenAccent : Colors.green,
                  ),
                  child: Text(
                    'Add Food',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
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
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: isDarkMode ? Colors.greenAccent : Colors.teal[800],
          ),
          prefixIcon: Icon(icon,
              color: isDarkMode ? Colors.greenAccent : Colors.teal[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isDarkMode ? Colors.greenAccent : Colors.teal),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        validator: (value) =>
        value!.isEmpty ? 'Please enter $labelText' : null,
      ),
    );
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
        imageUrl: imageUrl,
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
}
