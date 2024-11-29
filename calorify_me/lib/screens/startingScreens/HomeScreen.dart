import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../modals/Food.dart';
import '../../modals/Users.dart';
import '../../sevices/ThameProvider.dart';
import '../../sevices/UserProvider.dart';
import '../mealsDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  String searchQuery = '';
  QueryDocumentSnapshot? lastDocument;
  bool isLoadingMore = false;
  final int pageSize = 10;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userProvider = Provider.of<UserProvider>(context);
    final CustomUser? user = userProvider.user;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryBackground = isDarkMode ? Colors.black : Colors.white;
    final accentColor = themeProvider.accentColor;

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBackground,
        appBar: buildAppBarWithGradient(isDarkMode, accentColor, user),
        body: user == null
            ? buildShimmerUserPlaceholder()
            : Column(
          children: [
            buildSearchBar(isDarkMode, accentColor),
            Expanded(
              child: StreamBuilder<List<Food>>(
                stream: fetchPaginatedFoodItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildShimmerGrid();
                  }

                  if (snapshot.hasError) {
                    return buildErrorState("Error: ${snapshot.error}");
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return buildEmptyState();
                  }

                  final foodItems = snapshot.data!;
                  final filteredFoodItems = foodItems
                      .where((food) => food.foodName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                      .toList();

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoadingMore &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        loadMoreFoodItems();
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      itemCount: filteredFoodItems.length,
                      itemBuilder: (context, index) {
                        return ZoomIn(
                          duration: Duration(milliseconds: 300),
                          child: buildRecipeCard(
                            filteredFoodItems[index],
                            isDarkMode,
                            accentColor,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            if (isLoadingMore)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        floatingActionButton: BounceInUp(
          duration: Duration(milliseconds: 800),
          child: FloatingActionButton(
            onPressed: () {
              // Global action (e.g., Add Recipe)
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Stream<List<Food>> fetchPaginatedFoodItems() {
    Query query = FirebaseFirestore.instance.collection('Food').limit(pageSize);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }
    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
      }
      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  void loadMoreFoodItems() async {
    setState(() => isLoadingMore = true);
    final query = FirebaseFirestore.instance
        .collection('Food')
        .startAfterDocument(lastDocument!)
        .limit(pageSize);
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;
    }
    setState(() => isLoadingMore = false);
  }

  AppBar buildAppBarWithGradient(bool isDarkMode, Color accentColor, CustomUser? user) {
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
          if (user != null && user.profileImageUrl != null)
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(user.profileImageUrl!),
              backgroundColor: Colors.grey[300],
            )
          else
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.white),
            ),
          SizedBox(width: 10),
          Text(
            user == null ? "Welcome!" : "Welcome Back, ${user.name}!",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Navigate to settings
          },
        ),
      ],
    );
  }

  Widget buildSearchBar(bool isDarkMode, Color accentColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(30),
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
          Icon(Icons.search, color: accentColor, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for recipes...",
                hintStyle: TextStyle(color: Colors.grey),
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
              icon: Icon(Icons.clear, color: Colors.red),
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

  Widget buildRecipeCard(Food food, bool isDarkMode, Color accentColor) {
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
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: food.imageUrl ?? 'https://via.placeholder.com/150',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.redAccent, size: 28),
                    onPressed: () {
                      // Handle favorite action
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.foodName,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: accentColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_fire_department, size: 18, color: Colors.redAccent),
                          SizedBox(width: 4),
                          Text(
                            '${food.calories} Cal',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.restaurant, size: 18, color: Colors.orangeAccent),
                          SizedBox(width: 4),
                          Text(
                            '${food.fat}g Fat',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerGrid() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 150,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget buildShimmerUserPlaceholder() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: 100,
              height: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 50, color: Colors.red),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_food, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No recipes found.",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}