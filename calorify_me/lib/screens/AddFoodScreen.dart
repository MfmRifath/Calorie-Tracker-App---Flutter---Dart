import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../modals/Food.dart';

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
    final imageRef = storageRef.child('food_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = imageRef.putFile(image);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Item'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
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
                        child: Icon(Icons.camera_alt, size: 50, color: Colors.grey[800]),
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

              // Food Name
              TextFormField(
                controller: foodNameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  prefixIcon: Icon(Icons.fastfood),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter food name' : null,
              ),
              SizedBox(height: 15),

              // Calories
              TextFormField(
                controller: caloriesController,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  prefixIcon: Icon(Icons.local_fire_department),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter calories' : null,
              ),
              SizedBox(height: 15),

              // Protein
              TextFormField(
                controller: proteinController,
                decoration: InputDecoration(
                  labelText: 'Protein (g)',
                  prefixIcon: Icon(Icons.restaurant_menu),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter protein' : null,
              ),
              SizedBox(height: 15),

              // Fat
              TextFormField(
                controller: fatController,
                decoration: InputDecoration(
                  labelText: 'Fat (g)',
                  prefixIcon: Icon(Icons.bakery_dining),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter fat' : null,
              ),
              SizedBox(height: 15),

              // Weight
              TextFormField(
                controller: foodWeightController,
                decoration: InputDecoration(
                  labelText: 'Weight (g)',
                  prefixIcon: Icon(Icons.line_weight),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter weight' : null,
              ),
              SizedBox(height: 30),

              // Submit Button
              _isUploading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
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
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Add Food',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
