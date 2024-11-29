import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../sevices/UserProvider.dart';
import '../../sevices/ThameProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Loading state for login button

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

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
                color: isDarkMode ? Colors.greenAccent : Colors.green[700],
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: isDarkMode ? Colors.greenAccent : Colors.green[700],
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Color(0xff232526), Color(0xff414345)]
                      : [Colors.green[100]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Circular Decorations
          _buildBackgroundCircles(isDarkMode),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Lock Icon with Bounce Animation
                      _buildLockIcon(isDarkMode),
                      SizedBox(height: 30.0),
                      // Email and Password Fields
                      _buildTextField(
                        controller: emailController,
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        icon: CupertinoIcons.mail,
                        obscureText: false,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 20.0),
                      _buildTextField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        icon: CupertinoIcons.lock,
                        obscureText: true,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 30.0),
                      // Login Button
                      _buildLoginButton(
                        context,
                        isDarkMode,
                      ),
                      SizedBox(height: 10.0),
                      _buildForgotPassword(isDarkMode),
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

  Widget _buildBackgroundCircles(bool isDarkMode) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -30,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isDarkMode ? Colors.greenAccent : Colors.green[200])!.withOpacity(0.15),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          right: -40,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isDarkMode ? Colors.greenAccent : Colors.green[300])!.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockIcon(bool isDarkMode) {
    return BounceInDown(
      duration: Duration(milliseconds: 1000),
      child: Icon(
        CupertinoIcons.lock_shield_fill,
        size: 90,
        color: isDarkMode ? Colors.greenAccent : Colors.green[700],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData icon,
    required bool obscureText,
    required bool isDarkMode,
  }) {
    return FadeInUp(
      duration: Duration(milliseconds: 800),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDarkMode ? Colors.black87 : Colors.green[50],
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            textStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
          ),
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: isDarkMode ? Colors.greenAccent : Colors.green[700],
            ),
          ),
          prefixIcon: Icon(icon, color: isDarkMode ? Colors.greenAccent : Colors.green[700]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.greenAccent : Colors.green[700]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.greenAccent : Colors.green[700]!,
              width: 2.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, bool isDarkMode) {
    return BounceInUp(
      duration: Duration(milliseconds: 1200),
      child: ElevatedButton(
        onPressed: isLoading
            ? null // Disable button while loading
            : () async {
          setState(() => isLoading = true); // Show loading spinner

          String email = emailController.text.trim();
          String password = passwordController.text.trim();

          if (email.isEmpty || password.isEmpty) {
            setState(() => isLoading = false); // Hide loading spinner
            _showSnackBar(context, 'Please fill in all fields.', Colors.orangeAccent);
            return;
          }

          bool loginSuccess = await Provider.of<UserProvider>(context, listen: false)
              .login(email, password);

          setState(() => isLoading = false); // Hide loading spinner

          if (loginSuccess) {
            Navigator.pushReplacementNamed(context, '/recipeScreen');
          } else {
            _showSnackBar(context, 'Login failed. Invalid credentials.', Colors.redAccent);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.greenAccent : Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 10,
          shadowColor: Colors.greenAccent.withOpacity(0.5),
        ),
        child: isLoading
            ? SpinKitDancingSquare(
          color: isDarkMode ? Colors.black : Colors.white,
        )
            : Text(
          'Log in',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(bool isDarkMode) {
    return FadeInUp(
      duration: Duration(milliseconds: 1400),
      child: TextButton(
        onPressed: () {
          // Navigate to Forgot Password Screen
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: isDarkMode ? Colors.greenAccent : Colors.green[700],
              fontSize: 14.0,
              decoration: TextDecoration.underline,
            ),
          ),
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