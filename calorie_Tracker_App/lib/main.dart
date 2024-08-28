// lib/main.dart
import 'package:calorie_tracker_app/screens/startingScreens/LoginScreen.dart';
import 'package:calorie_tracker_app/screens/startingScreens/OnboardingScreen.dart';
import 'package:calorie_tracker_app/screens/startingScreens/StartingScreen.dart';
import 'package:flutter/material.dart';


void main() => runApp(CalorieTrackerApp());

class CalorieTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/login':(context) => Loginscreen(),
      },
    );
  }
}
