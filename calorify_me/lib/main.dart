import 'package:calorify_me/screens/startingScreens/LoginScreen.dart';
import 'package:calorify_me/screens/startingScreens/MainScreen.dart';
import 'package:calorify_me/screens/startingScreens/OnboardingScreen.dart';
import 'package:calorify_me/screens/startingScreens/SignUpScreen.dart';
import 'package:calorify_me/sevices/AuthService.dart';
import 'package:calorify_me/sevices/FoodProvider.dart';
import 'package:calorify_me/sevices/UserProvider.dart';
import 'package:calorify_me/sevices/WaterProvider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      ],
      child: MaterialApp(
        title: 'Calorie Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
          hintColor: Colors.lightGreen,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        home: AuthWrapper(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/recipeScreen': (context) => MainScreen(),
          '/signUp': (context) => UserSignUpScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error);
        }

        if (snapshot.hasData && snapshot.data != null) {
          Provider.of<UserProvider>(context, listen: false).setUserId(snapshot.data!.uid);
          return MainScreen();
        } else {
          return OnboardingScreen();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Loading..."),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(Object? error) {
    return Scaffold(
      body: Center(
        child: Text(
          "An error occurred: $error",
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
