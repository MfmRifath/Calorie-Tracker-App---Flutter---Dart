import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modals/Users.dart';
import '../../modals/Water.dart';
import '../../sevices/AuthService.dart';
import '../../sevices/UserProvider.dart';


class UserSignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  UserSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _registerUser(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;
    final String name = nameController.text;
    final int age = int.tryParse(ageController.text) ?? 0;
    final double weight = double.tryParse(weightController.text) ?? 0.0;

    try {
      // Use AuthService to register the user with email and password
      final authService = Provider.of<AuthService>(context, listen: false);
      final firebaseUser = await authService.registerWithEmail(email, password);

      if (firebaseUser != null) {
        // Create a CustomUser object with additional profile information
        CustomUser newUser = CustomUser(
          id: firebaseUser.uid,
          name: name,
          age: age,
          weight: weight,
          height: 1.75, // Default height, can be updated later
          foodLog: [],
          waterLog: Water(targetWaterConsumption: 2000, currentWaterConsumption: 0),
        );

        // Add the user to Firestore
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.addUser(newUser);

        // Navigate to the home screen or display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up successful!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    }
  }
}
