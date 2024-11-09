import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // For animations
import '../modals/Food.dart';
import 'AddFoodScreen.dart';

class FoodManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Manage Food Items',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[800]!, Colors.greenAccent[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Food').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(color: Colors.greenAccent[400]),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.redAccent, fontSize: 18),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No food items available.',
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
            );
          }

          List<Food> foodItems = snapshot.data!.docs.map((doc) {
            return Food.fromMap(doc.data() as Map<String, dynamic>);
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
                  color: Colors.grey[850],
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
                          : Icon(Icons.fastfood, size: 50, color: Colors.greenAccent),
                    ),
                    title: Text(
                      food.foodName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${food.calories} Cal | ${food.protein}g Protein | ${food.fat}g Fat',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await _deleteFoodItem(context, snapshot, index);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[400],
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFoodScreen()),
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
