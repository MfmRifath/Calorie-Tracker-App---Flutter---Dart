import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'AccountSettingScreen.dart';
import 'ThemeScreen.dart';

class UserSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.greenAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSettingsOption(
              context,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              icon: Icons.notifications_active,
              color: Colors.greenAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notification settings clicked')),
                );
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Account',
              subtitle: 'Change your account settings',
              icon: Icons.account_circle,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSettingsScreen(),
                  ),
                );

              },
            ),
            _buildSettingsOption(
              context,
              title: 'Privacy',
              subtitle: 'Manage privacy and security',
              icon: Icons.lock,
              color: Colors.redAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Privacy settings clicked')),
                );
              },
            ),
            _buildSettingsOption(
              context,
              title: 'Theme',
              subtitle: 'Switch between dark and light mode',
              icon: Icons.brightness_4,
              color: Colors.amberAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThemeScreen()),
                );

              },
            ),
            _buildSettingsOption(
              context,
              title: 'Help & Support',
              subtitle: 'Get help and find answers',
              icon: Icons.help_outline,
              color: Colors.purpleAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Help & Support clicked')),
                );
              },
            ),
            _buildSettingsOption(
              context,
              title: 'About',
              subtitle: 'Learn more about this app',
              icon: Icons.info_outline,
              color: Colors.tealAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('About clicked')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return FadeInLeft(
      duration: Duration(milliseconds: 800),
      child: Card(
        color: Colors.black87,
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
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
