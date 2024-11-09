import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.0), // Added space at the top
              // Image Section
              Expanded(
                child: Image.asset(
                  'assets/images/$img.png',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              // Heading Text
              Text(
                heading,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              // Description Text
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  Description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
