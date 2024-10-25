import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals/Food.dart';
import '../sevices/UserProvider.dart';

class MealDetailsScreen extends StatelessWidget {
  final Food meal;

  MealDetailsScreen({required this.meal});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Meal Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Color(0xFF4CAF50)),
            onPressed: () {
              // Add functionality to save meal as favorite
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Color(0xFF4CAF50)),
            onPressed: () {
              // Add functionality to share meal details
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'), // Placeholder image path
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.foodName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${meal.calories} Cal | ${meal.protein}g Protein | ${meal.fat}g Fat',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),

                  // Meal Description
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      'A delicious ${meal.foodName} recipe with balanced nutrition. Perfect for any meal!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Log Meal Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      onPressed: () async {
                        await userProvider.logFood(meal);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Meal added to your food log!')),
                        );
                      },
                      child: Text(
                        'Log this Meal',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Nutrition Facts Section
                  Text(
                    'Nutrition Facts',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  SizedBox(height: 10),
                  NutritionFactsCard(meal: meal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nutrition Facts Card for Meal Details
class NutritionFactsCard extends StatelessWidget {
  final Food meal;

  NutritionFactsCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NutritionFactRow(label: 'Calories', value: '${meal.calories}'),
            NutritionFactRow(label: 'Protein', value: '${meal.protein}g'),
            NutritionFactRow(label: 'Fat', value: '${meal.fat}g'),
            NutritionFactRow(label: 'Weight', value: '${meal.foodWeight}g'),
          ],
        ),
      ),
    );
  }
}

// Individual Nutrition Fact Row
class NutritionFactRow extends StatelessWidget {
  final String label;
  final String value;

  NutritionFactRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
