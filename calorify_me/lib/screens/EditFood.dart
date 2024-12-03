import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/Food.dart';

class EditFoodDialog extends StatefulWidget {
  final Food food;

  EditFoodDialog({required this.food});

  @override
  _EditFoodDialogState createState() => _EditFoodDialogState();
}

class _EditFoodDialogState extends State<EditFoodDialog> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _foodNameController.text = widget.food.foodName;
    _caloriesController.text = widget.food.calories.toString();
    _proteinController.text = widget.food.protein.toString();
    _fatController.text = widget.food.fat.toString();
    _descriptionController.text = widget.food.description!;
    _carbsController.text = widget.food.carbs.toString();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return widget.food.imageUrl;

    setState(() {
      _isUploading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('food_images/${widget.food.id}.jpg');

      await storageRef.putFile(_selectedImage!);
      final downloadUrl = await storageRef.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image.'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  Future<void> _saveChanges() async {
    final updatedImageUrl = await _uploadImage();
    if (updatedImageUrl == null) return;

    await FirebaseFirestore.instance
        .collection('Food')
        .doc(widget.food.id)
        .update({
      'foodName': _foodNameController.text.trim(),
      'calories': int.parse(_caloriesController.text.trim()),
      'protein': double.parse(_proteinController.text.trim()),
      'fat': double.parse(_fatController.text.trim()),
      'imageUrl': updatedImageUrl,
      'description': _descriptionController.text,
      'carbs':_carbsController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Food item updated successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Edit Food',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : widget.food.imageUrl != null
                            ? NetworkImage(widget.food.imageUrl!)
                        as ImageProvider
                            : AssetImage('assets/placeholder.png'),
                        backgroundColor: Colors.white,
                      ),
                      if (_isUploading)
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            color: Colors.tealAccent,
                          ),
                        ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 20,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(_foodNameController, 'Food Name', Icons.fastfood),
                SizedBox(height: 30),
                _buildTextField(_descriptionController, 'Food Description', Icons.description),
                SizedBox(height: 15),
                _buildTextField(_caloriesController, 'Calories', Icons.local_fire_department, isNumber: true),
                SizedBox(height: 15),
                _buildTextField(_proteinController, 'Protein (g)', Icons.fitness_center, isNumber: true),
                SizedBox(height: 15),
                _buildTextField(_proteinController, 'Carbs (g)', Icons.rice_bowl, isNumber: true),

                SizedBox(height: 15),
                _buildTextField(_fatController, 'Fat (g)', Icons.bubble_chart, isNumber: true),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.tealAccent.shade700,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.tealAccent),
        prefixIcon: Icon(icon, color: Colors.tealAccent),
        filled: true,
        fillColor: Colors.teal.shade800.withOpacity(0.5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent.shade100),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}