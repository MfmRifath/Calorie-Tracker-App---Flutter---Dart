import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../sevices/ThameProvider.dart';
import 'ChagePassword.dart';
import 'ChangeEmail.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.teal[700],
        elevation: 0,
        title: Text(
          'Account Settings',
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
        child: ListView(
          children: [
            _buildAccountOption(
              context,
              title: 'Change Email',
              subtitle: 'Update your email address',
              icon: Icons.email_outlined,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(),
                  ),
                );
              },
            ),
            _buildAccountOption(
              context,
              title: 'Change Password',
              subtitle: 'Update your password',
              icon: Icons.lock_outline,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            _buildAccountOption(
              context,
              title: 'Update Phone Number',
              subtitle: 'Change your phone number',
              icon: Icons.phone_outlined,
              color: Colors.greenAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update Phone Number clicked')),
                );
              },
            ),
            _buildAccountOption(
              context,
              title: 'Manage Linked Accounts',
              subtitle: 'View or remove linked accounts',
              icon: Icons.link_outlined,
              color: Colors.orangeAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Manage Linked Accounts clicked')),
                );
              },
            ),
            _buildAccountOption(
              context,
              title: 'Deactivate Account',
              subtitle: 'Temporarily disable your account',
              icon: Icons.pause_circle_outline,
              color: Colors.amberAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deactivate Account clicked')),
                );
              },
            ),
            _buildAccountOption(
              context,
              title: 'Delete Account',
              subtitle: 'Permanently delete your account',
              icon: Icons.delete_forever_outlined,
              color: Colors.pinkAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete Account clicked')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return FadeInUp(
      duration: Duration(milliseconds: 800),
      child: Card(
        color: isDarkMode ? Colors.black87 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: ListTile(
          leading: Icon(icon, color: color, size: 28),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.greenAccent : Colors.teal[700],
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
