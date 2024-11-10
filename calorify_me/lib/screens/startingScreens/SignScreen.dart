import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SlideInUp(
          duration: Duration(milliseconds: 700),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                _buildSignInButton(
                  icon: Image.asset('assets/images/googleIcon.png', height: 24),
                  label: 'Sign in with Google',
                  onPressed: () {},
                ),
                SizedBox(height: 10.0),
                _buildSignInButton(
                  icon: Icon(CupertinoIcons.mail, color: Colors.blue),
                  label: 'Sign in with Email',
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInButton({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            side: BorderSide(color: Colors.blueAccent, width: 1.5),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElasticIn(
              duration: Duration(milliseconds: 800),
              child: Column(
                children: [
                  SizedBox(height: 250.0,),
                  Image.asset('assets/images/logo.png', height: 120),
                  Text(
                    'Welcome',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: Text(
                      'Sign in or create an account to start your journey',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _showBottomSheet(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xff006d77),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: GoogleFonts.poppins(fontSize: 14.0),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signUp'),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              color: Color(0xff006d77),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
