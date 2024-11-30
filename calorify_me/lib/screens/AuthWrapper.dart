import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../sevices/UserProvider.dart';
import 'startingScreens/MainScreen.dart';
import 'startingScreens/OnboardingScreen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // If the user is logged in, load user data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserId(firebaseUser.uid);
      userProvider.loadCurrentUserData();
      return MainScreen(); // Navigate to MainScreen
    } else {
      return OnboardingScreen(); // Navigate to OnboardingScreen
    }
  }
}