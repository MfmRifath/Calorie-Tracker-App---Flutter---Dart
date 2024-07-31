// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(CalorieTrackerApp());

class CalorieTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
