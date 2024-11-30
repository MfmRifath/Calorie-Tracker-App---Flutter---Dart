import 'package:calorify_me/screens/SplashScreen.dart';
import 'package:calorify_me/screens/startingScreens/LoginScreen.dart';
import 'package:calorify_me/screens/startingScreens/MainScreen.dart';
import 'package:calorify_me/screens/startingScreens/OnboardingScreen.dart';
import 'package:calorify_me/screens/startingScreens/SignUpScreen.dart';
import 'package:calorify_me/sevices/AuthService.dart';
import 'package:calorify_me/sevices/FoodProvider.dart';
import 'package:calorify_me/sevices/ThameProvider.dart';
import 'package:calorify_me/sevices/UserProvider.dart';
import 'package:calorify_me/sevices/WaterProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Future<void> resetOnAppLaunch() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    final firestore = FirebaseFirestore.instance;
    final userDoc = await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final currentDate = DateTime.now();
      final lastReset = (userDoc.data()?['lastReset'] != null)
          ? (userDoc.data()?['lastReset'] as Timestamp).toDate()
          : null;

      if (lastReset == null || currentDate.difference(lastReset).inHours >= 24) {
        // Get all documents in the `dailyFoodLog` collection
        final dailyFoodLogCollection = firestore
            .collection('users')
            .doc(userId)
            .collection('dailyFoodLog');

        final dailyFoodLogSnapshot = await dailyFoodLogCollection.get();

        // Delete each document in the `dailyFoodLog` collection
        for (var doc in dailyFoodLogSnapshot.docs) {
          await doc.reference.delete();
        }

        // Delete the `waterLog` field from the user's document
        await firestore.collection('users').doc(userId).update({
          'waterLog': FieldValue.delete(),
          'totalCalories': 0.0,
          'totalWaterIntake': 0.0,
          'lastReset': currentDate,
        });

        print("Daily food log cleared, water log deleted, and values reset successfully.");
      } else {
        print("Reset not required. Last reset was within the specified time.");
      }
    } else {
      print("User document does not exist.");
    }
  } else {
    print("No user is currently logged in.");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBJZz3Hu6nDT4wXKiFdWXXRwPWu7z6_ltY',
      appId: '1:122625667956:android:e75744b36c2287267e7221',
      messagingSenderId: '122625667956',
      projectId: 'calorifyme-458e0',
      storageBucket: 'calorifyme-458e0.appspot.com',
    ),
  );

  await resetOnAppLaunch();
  runApp(CalorieTrackerApp());
}

class CalorieTrackerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProxyProvider<UserProvider, FoodProvider>(
          create: (_) => FoodProvider(userId: ''),
          update: (_, userProvider, previous) =>
          previous!..updateUserId(userProvider.user?.id ?? ''),
        ),
        ChangeNotifierProxyProvider<UserProvider, WaterProvider>(
          create: (_) => WaterProvider(userId: '', targetWaterConsumption: 2000),
          update: (_, userProvider, previous) => previous!
            ..update(
              userId: userProvider.user?.id ?? '',
              targetWaterConsumption: 2000,
            ),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()), // ThemeProvider

      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Calorie Tracker',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getTheme(),
            home: SplashScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/recipeScreen': (context) => MainScreen(),
              '/signUp': (context) => UserSignUpScreen(),
            },
          );
        },
      ),
    );
  }
}

