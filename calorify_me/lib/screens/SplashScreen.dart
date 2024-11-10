import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import '../main.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthWrapper()),
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Top Decorative Circle
          Positioned(
            top: -50,
            left: -50,
            child: ZoomIn(
              duration: Duration(milliseconds: 1000),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.2),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Image with Animation
                BounceInDown(
                  duration: Duration(milliseconds: 1000),
                  child: Image.asset(
                    'assets/images/logo.png', // Replace with your logo path
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  duration: Duration(milliseconds: 1400),
                  child: Text(
                    "Calorie Tracker",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: Duration(milliseconds: 1600),
                  child: Text(
                    "Track your calories and stay healthy!",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: FadeInUp(
              duration: Duration(milliseconds: 1800),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.greenAccent,
                      strokeWidth: 3.0,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Loading...",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Decorative Circle
          Positioned(
            bottom: -60,
            right: -60,
            child: ZoomIn(
              duration: Duration(milliseconds: 1500),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
