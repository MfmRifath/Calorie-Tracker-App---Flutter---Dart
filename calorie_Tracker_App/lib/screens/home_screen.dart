// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

import 'add_meal_screen.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.fastfood),
            title: Text('Breakfast'),
            subtitle: Text('300 kcal'),
          ),
          ListTile(
            leading: Icon(Icons.lunch_dining),
            title: Text('Lunch'),
            subtitle: Text('600 kcal'),
          ),
          ListTile(
            leading: Icon(Icons.dinner_dining),
            title: Text('Dinner'),
            subtitle: Text('700 kcal'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
