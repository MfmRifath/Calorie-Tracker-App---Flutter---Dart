import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../sevices/UserProvider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeInDown(
          duration: Duration(milliseconds: 800),
          child: Text(
            'Login',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.greenAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Layer
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff232526), Color(0xff414345)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Top Circular Decoration
          Positioned(
            top: -60,
            left: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.withOpacity(0.15),
              ),
            ),
          ),
          // Bottom Circular Decoration
          Positioned(
            bottom: -50,
            right: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Lock Icon with BounceIn Animation
                      BounceInDown(
                        duration: Duration(milliseconds: 1000),
                        child: Icon(
                          CupertinoIcons.lock_shield_fill,
                          size: 90,
                          color: Colors.greenAccent,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      // Email Text Field
                      _buildTextField(
                        controller: emailController,
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        icon: CupertinoIcons.mail,
                        obscureText: false,
                      ),
                      SizedBox(height: 20.0),
                      // Password Text Field
                      _buildTextField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        icon: CupertinoIcons.lock,
                        obscureText: true,
                      ),
                      SizedBox(height: 30.0),
                      // Animated Login Button
                      BounceInUp(
                        duration: Duration(milliseconds: 1200),
                        child: AnimatedButton(
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              _showSnackBar(
                                  context, 'Please fill in all fields.', Colors.orangeAccent);
                              return;
                            }

                            bool loginSuccess = await Provider.of<UserProvider>(context, listen: false)
                                .login(email, password);

                            if (loginSuccess) {
                              Navigator.pushReplacementNamed(context, '/recipeScreen');
                            } else {
                              _showSnackBar(
                                  context, 'Login failed. Invalid credentials.', Colors.redAccent);
                            }
                          },
                          buttonText: 'Log in',
                        ),
                      ),
                      SizedBox(height: 10.0),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: TextButton(
                          onPressed: () {
                            // Navigate to Forgot Password Screen
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData icon,
    required bool obscureText,
  }) {
    return FadeInUp(
      duration: Duration(milliseconds: 800),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black87,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white54),
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.greenAccent),
          ),
          prefixIcon: Icon(icon, color: Colors.greenAccent),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 14.0)),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        elevation: 10,
        shadowColor: Colors.greenAccent.withOpacity(0.5),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
