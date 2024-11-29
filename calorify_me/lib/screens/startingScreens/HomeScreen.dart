import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart';

import '../../modals/Food.dart';
import '../../modals/Users.dart';
import '../../sevices/UserProvider.dart';
import '../../sevices/ThameProvider.dart';
import '../mealsDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userProvider = Provider.of<UserProvider>(context);
    final CustomUser? user = userProvider.user;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final accentColor = themeProvider.accentColor;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: buildAppBarWithGradient(isDarkMode, accentColor, user, screenWidth),
        body: Column(
          children: [
            buildSearchBar(isDarkMode, accentColor, screenWidth, screenHeight),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Food').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmerGrid(screenWidth);
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return buildEmptyState(screenHeight);
                  } else {
                    final foodItems = snapshot.data!.docs
                        .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                        .where((food) => food.foodName.toLowerCase().contains(searchQuery.toLowerCase()))
                        .toList();

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.05,
                      ),
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        return ZoomIn(
                          duration: Duration(milliseconds: 300),
                          child: buildRecipeCard(
                            foodItems[index],
                            isDarkMode,
                            accentColor,
                            screenWidth,
                            screenHeight,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBarWithGradient(
      bool isDarkMode, Color accentColor, CustomUser? user, double screenWidth) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[700]!, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Row(
        children: [
          // Add your logo here
          SizedBox(width: screenWidth * 0.02),
          if (user != null && user.profileImageUrl != null)
            CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundImage: CachedNetworkImageProvider(user.profileImageUrl!),
            )
          else
            CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.white),
            ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Text(
              user == null ? "Welcome!" : "Hi!, ${user.name}!",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildSearchBar(
      bool isDarkMode, Color accentColor, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.04,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.08),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: accentColor, size: screenWidth * 0.06),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: TextField(
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for recipes...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.04),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          if (searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.red, size: screenWidth * 0.05),
              onPressed: () {
                setState(() {
                  searchQuery = '';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget buildRecipeCard(Food food, bool isDarkMode, Color accentColor,
      double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MealDetailsScreen(meal: food)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          gradient: LinearGradient(
            colors: [
              isDarkMode ? Colors.grey[900]! : Colors.white,
              isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(screenWidth * 0.04),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: food.imageUrl ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.foodName,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                        color: accentColor,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    '${food.calories} Cal | ${food.fat}g Fat',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerGrid(double screenWidth) {
    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.05),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: screenWidth * 0.3,
            margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget buildEmptyState(double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_food, size: screenHeight * 0.08, color: Colors.grey),
          SizedBox(height: screenHeight * 0.02),
          Text(
            "No recipes found.",
            style: TextStyle(fontSize: screenHeight * 0.02, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}