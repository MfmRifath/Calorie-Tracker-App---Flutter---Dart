import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart'; // Import Provider for Theme
import '../../sevices/ThameProvider.dart';
 // Import ThemeProvider

class StartingScreen extends StatelessWidget {
  StartingScreen({
    required this.Description,
    required this.heading,
    required this.img,
  });

  final String heading;
  final String img;
  final String Description;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              // Image Section with Animation
              Expanded(
                child: ZoomIn(
                  duration: Duration(milliseconds: 800),
                  child: Image.asset(
                    'assets/images/$img.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ),
              // Heading Text with Animation
              FadeInDown(
                duration: Duration(milliseconds: 900),
                child: Text(
                  heading,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.greenAccent : Colors.teal[800],
                    ),
                  ),
                ),
              ),
              // Description Text with Animation
              FadeInUp(
                duration: Duration(milliseconds: 1100),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    Description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Bottom Decorative Element with Bounce Animation
              BounceInUp(
                duration: Duration(milliseconds: 800),
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.greenAccent : Colors.teal[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Adaptive background
    );
  }
}
