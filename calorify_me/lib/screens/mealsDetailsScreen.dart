import 'package:animate_do/animate_do.dart';
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
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share, color: Color(0xFF4CAF50)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FadeIn(
          duration: Duration(milliseconds: 500),
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
                    _buildMealTitle(),
                    SizedBox(height: 10),
                    _buildMealStats(),
                    SizedBox(height: 20),
                    _buildMealDescription(),
                    SizedBox(height: 20),
                    _buildLogMealButton(userProvider, context),
                    SizedBox(height: 20),
                    _buildNutritionFacts(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealImage(String? imageUrl) {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTitle() {
    return ZoomIn(
      duration: Duration(milliseconds: 800),
      child: Text(
        meal.foodName,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF388E3C),
        ),
      ),
    );
  }

  Widget _buildMealStats() {
    return SlideInLeft(
      duration: Duration(milliseconds: 800),
      child: Text(
        '${meal.calories} Cal | ${meal.protein}g Protein | ${meal.fat}g Fat',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildMealDescription() {
    return ElasticIn(
      duration: Duration(milliseconds: 800),
      child: Container(
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
    );
  }

  Widget _buildLogMealButton(UserProvider userProvider, BuildContext context) {
    return Center(
      child: BounceInUp(
        duration: Duration(milliseconds: 600),
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionFacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInRight(
          duration: Duration(milliseconds: 500),
          child: Text(
            'Nutrition Facts',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF388E3C),
            ),
          ),
        ),
        SizedBox(height: 10),
        NutritionFactsCard(meal: meal),
      ],
    );
  }
}

class NutritionFactsCard extends StatelessWidget {
  final Food meal;

  NutritionFactsCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return FlipInX(
      duration: Duration(milliseconds: 600),
      child: Card(
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
      ),
    );
  }
}

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
