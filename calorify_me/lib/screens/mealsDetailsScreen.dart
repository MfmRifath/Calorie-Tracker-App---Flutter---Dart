import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals/Food.dart';
import '../sevices/ThameProvider.dart';
import '../sevices/UserProvider.dart';

class MealDetailsScreen extends StatelessWidget {
  final Food meal;

  MealDetailsScreen({required this.meal});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Meal Details',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Bounce(
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Color(0xFF4CAF50)),
              onPressed: () {},
            ),
          ),
          Bounce(
            child: IconButton(
              icon: Icon(Icons.share, color: Color(0xFF4CAF50)),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideInDown(
              duration: Duration(milliseconds: 700),
              child: _buildMealImage(meal.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  SlideInLeft(
                    duration: Duration(milliseconds: 800),
                    child: _buildMealStats(isDarkMode),
                  ),
                  SizedBox(height: 20),
                  ElasticIn(
                    duration: Duration(milliseconds: 800),
                    child: _buildMealDescription(isDarkMode),
                  ),
                  SizedBox(height: 20),
                  BounceInUp(
                    duration: Duration(milliseconds: 600),
                    child: _buildLogMealButton(userProvider, context, isDarkMode),
                  ),
                  SizedBox(height: 20),
                  FadeInRight(
                    duration: Duration(milliseconds: 500),
                    child: _buildNutritionFactsTitle(isDarkMode),
                  ),
                  SizedBox(height: 10),
                  NutritionFactsCard(meal: meal, isDarkMode: isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealImage(String? imageUrl) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl ?? 'https://via.placeholder.com/150'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            meal.foodName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.7),
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildMealStats(bool isDarkMode) {
    return Text(
      '${meal.calories} Cal | ${meal.protein}g Protein | ${meal.fat}g Fat',
      style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white54 : Colors.grey),
    );
  }

  Widget _buildMealDescription(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        meal.description != '' ? meal.description! : "No Description",
         style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildLogMealButton(UserProvider userProvider, BuildContext context, bool isDarkMode) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4CAF50),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          await userProvider.logFood(meal);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Meal added to your food log!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Text(
          'Log this Meal',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionFactsTitle(bool isDarkMode) {
    return Text(
      'Nutrition Facts',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.greenAccent : Color(0xFF388E3C),
      ),
    );
  }
}

class NutritionFactsCard extends StatelessWidget {
  final Food meal;
  final bool isDarkMode;

  NutritionFactsCard({required this.meal, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: Duration(milliseconds: 600),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutritionFactRow(label: 'Calories', value: '${meal.calories}', isDarkMode: isDarkMode),
              NutritionFactRow(label: 'Protein', value: '${meal.protein}g', isDarkMode: isDarkMode),
              NutritionFactRow(label: 'Fat', value: '${meal.fat}g', isDarkMode: isDarkMode),
              NutritionFactRow(label: 'Weight', value: '${meal.foodWeight}g', isDarkMode: isDarkMode),
            ],
          ),
        ),
      ),
    );
  }
}

class NutritionFactRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkMode;

  NutritionFactRow({required this.label, required this.value, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.grey[800])),
            Text(value, style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}