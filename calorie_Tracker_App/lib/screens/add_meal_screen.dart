// lib/screens/add_meal_screen.dart
import 'package:flutter/material.dart';

class AddMealScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _foodNameController,
                decoration: InputDecoration(labelText: 'Food Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number of calories';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save meal to the database
                    // This can be a call to your backend or a local database
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
