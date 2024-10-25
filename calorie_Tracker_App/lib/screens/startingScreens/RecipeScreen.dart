import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../modals/Food.dart';
import '../mealsDetailsScreen.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final Color primaryGreen = Color(0xFF4CAF50);
  final Color lightGreen = Color(0xFFE8F5E9);
  final Color darkGreen = Color(0xFF388E3C);

  String searchQuery = '';
  late Future<List<Food>> _foodItemsFuture;

  @override
  void initState() {
    super.initState();
    _foodItemsFuture = fetchFoodItems(); // Fetch food items during initialization
  }

  Future<List<Food>> fetchFoodItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('Food').get();
    return snapshot.docs.map((doc) {
      return Food.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/bg.jpg'), // Replace with actual user image if available
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(
              "User's Recipes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {}, // Placeholder for search action
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            buildSearchBar(),
            Expanded(
              child: FutureBuilder<List<Food>>(
                future: _foodItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No recipes found."));
                  }

                  // Filter based on search query
                  final foodItems = snapshot.data!;
                  final filteredFoodItems = foodItems.where((food) =>
                      food.foodName.toLowerCase().contains(searchQuery.toLowerCase())).toList();

                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredFoodItems.length,
                    itemBuilder: (context, index) {
                      return buildRecipeCard(filteredFoodItems[index], context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for recipes",
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Roboto',
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Capture the search input and update the state
                });
              },
            ),
          ),
          Icon(Icons.filter_alt, color: primaryGreen),
        ],
      ),
    );
  }

  // Recipe Card Widget
  Widget buildRecipeCard(Food food, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsScreen(meal: food),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white, lightGreen.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Recipe Image with rounded corners
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpg'), // Placeholder image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Recipe Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.foodName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: darkGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          '60 min', // Placeholder time
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.local_fire_department, size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          '${food.calories} Cal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
