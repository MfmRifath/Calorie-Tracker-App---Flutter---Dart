import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // For animations
import 'package:provider/provider.dart';

import '../modals/Food.dart';
import '../sevices/ThameProvider.dart';
import 'AddFoodScreen.dart';
import 'EditFood.dart';
Future<void> importCsv(BuildContext context) async {
  try {
    // Pick a CSV file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();

      // Assuming the first row contains headers
      List<String> headers = fields[0].cast<String>();

      // Skip the headers and process rows
      for (int i = 1; i < fields.length; i++) {
        Map<String, dynamic> data = {};
        for (int j = 0; j < headers.length; j++) {
          data[headers[j]] = fields[i][j];
        }

        // Upload data to Firestore
        await FirebaseFirestore.instance.collection('Food').add(data);
      }

      // Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV data imported successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // File picker canceled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File selection canceled.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to import CSV: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
class FoodManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Manage Food Items',
          style: TextStyle(
            color: isDarkMode ? Colors.greenAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.teal,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file, color: isDarkMode ? Colors.greenAccent : Colors.white),
            onPressed: () {
              importCsv(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Food').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(
                color: isDarkMode ? Colors.greenAccent : Colors.teal,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(
                  color: isDarkMode ? Colors.redAccent : Colors.red,
                  fontSize: 18,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No food items available.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.grey,
                  fontSize: 18,
                ),
              ),
            );
          }

          List<Food> foodItems = snapshot.data!.docs.map((doc) {
            return Food.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return FadeIn(
                duration: Duration(milliseconds: 500 + (index * 100)),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                  elevation: 6,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: food.imageUrl != null && food.imageUrl!.isNotEmpty
                          ? Image.network(
                        food.imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.fastfood,
                        size: 50,
                        color: isDarkMode ? Colors.greenAccent : Colors.teal,
                      ),
                    ),
                    title: Text(
                      food.foodName,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${food.calories} Cal | ${food.protein}g Protein | ${food.fat}g Fat',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditFoodDialog(food: food),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () async {
                            await _deleteFoodItem(context, snapshot, index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkMode ? Colors.greenAccent : Colors.teal,
        child: Icon(Icons.add, color: isDarkMode ? Colors.black : Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddFoodDialog(),
          );
        },
      ),
    );
  }

  Future<void> _deleteFoodItem(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) async {
    try {
      await FirebaseFirestore.instance.collection('Food').doc(snapshot.data!.docs[index].id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Food item deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete food item.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
