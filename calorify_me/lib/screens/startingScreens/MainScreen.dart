import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../sevices/ThameProvider.dart';

import '../../sevices/UserProvider.dart';
import '../AdminScreen.dart';
import '../DairyScreen.dart';

import '../ReportScreen.dart';
import '../UserProfileScreen.dart';
import 'HomeScreen.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUserRole();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Show a loading indicator while fetching user role
    if (userProvider.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Define screens dynamically based on the user's role
    final List<Widget> _screens = [
      HomeScreen(),
      DiaryScreen(),
      ReportsScreen(),
      if (userProvider.role == 'ADMIN') AdminScreen(),
      UserProfileScreen(),
    ];

    // Define BottomNavigationBar items dynamically based on the user's role
    final List<BottomNavigationBarItem> _bottomNavItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Recipes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.note_alt),
        label: 'Diary',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: 'Reports',
      ),
      if (userProvider.role == 'ADMIN')
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black45 : Colors.grey.withOpacity(0.2),
              offset: Offset(0, -2),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: isDarkMode ? Colors.greenAccent : Colors.green[700],
          unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
          items: _bottomNavItems,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.greenAccent : Colors.green[700],
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12.0,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }
}