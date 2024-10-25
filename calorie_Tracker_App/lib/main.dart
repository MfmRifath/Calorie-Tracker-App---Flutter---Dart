import 'package:calorie_tracker_app/screens/startingScreens/LoginScreen.dart';
import 'package:calorie_tracker_app/screens/startingScreens/MainScreen.dart';
import 'package:calorie_tracker_app/screens/startingScreens/OnboardingScreen.dart';
import 'package:calorie_tracker_app/screens/startingScreens/RecipeScreen.dart';
import 'package:calorie_tracker_app/screens/startingScreens/SignUpScreen.dart';
import 'package:calorie_tracker_app/sevices/AuthService.dart';
import 'package:calorie_tracker_app/sevices/FoodProvider.dart';
import 'package:calorie_tracker_app/sevices/UserProvider.dart';
import 'package:calorie_tracker_app/sevices/WaterProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBJZz3Hu6nDT4wXKiFdWXXRwPWu7z6_ltY',
      appId: '1:122625667956:android:c4ac030f0104eb237e7221',
      messagingSenderId: '12262566795',
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
        // These will be initialized in AuthWrapper when the user is logged in
        ChangeNotifierProxyProvider<UserProvider, FoodProvider>(
          create: (_) => FoodProvider(userId: ''),
          update: (_, userProvider, foodProvider) =>
              FoodProvider(userId: userProvider.user?.id ?? ''),
        ),
        ChangeNotifierProxyProvider<UserProvider, WaterProvider>(
          create: (_) => WaterProvider(userId: '', targetWaterConsumption: 2000),
          update: (_, userProvider, waterProvider) =>
              WaterProvider(
                userId: userProvider.user?.id ?? '',
                targetWaterConsumption: 2000, // adjust as needed
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Calorie Tracker',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
      future: FirebaseAuth.instance
          .authStateChanges()
          .first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          // Set user ID in UserProvider when logged in
          Provider.of<UserProvider>(context, listen: false).setUserId(
              snapshot.data!.uid);
          return MainScreen();
        } else {
          return OnboardingScreen();
        }
      },
    );
  }
}