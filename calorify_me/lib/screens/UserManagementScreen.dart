import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart'; // Ensure this is imported
import 'package:provider/provider.dart';
import '../modals/Users.dart';

import '../sevices/ThameProvider.dart';
import 'UserDetailsScreen.dart';

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.grey[100];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Manage Users',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        backgroundColor: isDarkMode ? Colors.transparent : Colors.green[700],
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading users: ${snapshot.error}",
                style: TextStyle(color: textColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No users found.",
                style: TextStyle(fontSize: 16, color: subtitleColor),
              ),
            );
          }

          List<Future<CustomUser>> usersFutures = snapshot.data!.docs.map((doc) async {
            return CustomUser.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return FutureBuilder<List<CustomUser>>(
            future: Future.wait(usersFutures),
            builder: (context, usersSnapshot) {
              if (usersSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (usersSnapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading user data: ${usersSnapshot.error}",
                    style: TextStyle(color: textColor),
                  ),
                );
              }

              if (!usersSnapshot.hasData || usersSnapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No user data available.",
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                  ),
                );
              }

              final users = usersSnapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return FadeInUp(
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: cardColor,
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[300],
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
                        ),
                        subtitle: Text(
                          'Age: ${user.age} | Weight: ${user.weight}kg',
                          style: TextStyle(fontSize: 14, color: subtitleColor),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[700]),
                          onPressed: () => _confirmDeleteUser(context, user.id, isDarkMode),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(user: user),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String userId, bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    showDialog(
      context: context,
      builder: (context) => ZoomIn(
        duration: Duration(milliseconds: 300),
        child: AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          title: Text(
            "Delete User",
            style: TextStyle(color: textColor),
          ),
          content: Text(
            "Are you sure you want to delete this user?",
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc(userId).delete();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
