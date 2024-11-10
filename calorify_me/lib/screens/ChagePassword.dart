import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../sevices/ThameProvider.dart';

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.green,
        elevation: 0,
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.greenAccent : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ZoomIn(
              duration: Duration(milliseconds: 800),
              child: TextField(
                controller: _currentPasswordController,
                obscureText: true,
                style: TextStyle(color: isDarkMode ? Colors.greenAccent : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: isDarkMode ? Colors.greenAccent : Colors.green),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDarkMode ? Colors.greenAccent : Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock, color: isDarkMode ? Colors.greenAccent : Colors.green),
                ),
              ),
            ),
            SizedBox(height: 20),
            ZoomIn(
              duration: Duration(milliseconds: 800),
              child: TextField(
                controller: _newPasswordController,
                obscureText: true,
                style: TextStyle(color: isDarkMode ? Colors.greenAccent : Colors.black),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: isDarkMode ? Colors.greenAccent : Colors.green),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDarkMode ? Colors.greenAccent : Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock_outline, color: isDarkMode ? Colors.greenAccent : Colors.green),
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill out both fields.')),
                    );
                    return;
                  }

                  // Replace this with actual password change logic.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password changed successfully.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.greenAccent : Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.black : Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
