import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../sevices/ThameProvider.dart';
import 'FoodManagement.dart';
import 'UserManagementScreen.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: TextStyle(
            color: isDarkMode ? Colors.greenAccent : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3,
          ),
          children: [
            BounceInLeft(
              duration: Duration(milliseconds: 500),
              child: _buildAdminOption(
                context,
                icon: Icons.people,
                title: 'Manage Users',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManagementScreen()),
                  );
                },
                isDarkMode: isDarkMode,
              ),
            ),
            BounceInRight(
              duration: Duration(milliseconds: 500),
              child: _buildAdminOption(
                context,
                icon: Icons.fastfood,
                title: 'Manage Food Items',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoodManagementScreen()),
                  );
                },
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        required bool isDarkMode,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: FlipInX(
        duration: Duration(milliseconds: 800),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          color: isDarkMode ? Colors.black87 : Colors.white,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey.shade800, Colors.grey.shade900]
                    : [Colors.green.shade300, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
