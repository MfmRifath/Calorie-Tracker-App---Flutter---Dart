import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final userProvider = Provider.of<UserProvider>(context);
    final CustomUser user = userProvider.user!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryBackground = isDarkMode ? Colors.black : Colors.white;
    final accentColor = themeProvider.accentColor;

    return Scaffold(
      backgroundColor: primaryBackground,
      appBar: buildAppBar(isDarkMode, accentColor, user),
      body: Column(
        children: [
          FadeInOnce(
            child: buildSearchBar(isDarkMode, accentColor),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Food').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildCustomLoader(accentColor);
                }
                if (snapshot.hasError) {
                  return buildErrorState("Error: ${snapshot.error}");
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return buildEmptyState();
                }

                final foodItems = snapshot.data!.docs.map((doc) {
                  return Food.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                final filteredFoodItems = foodItems
                    .where((food) => food.foodName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()))
                    .toList();

                return GridView.builder(
                  key: ValueKey(searchQuery),
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filteredFoodItems.length,
                  itemBuilder: (context, index) {
                    return SlideInUp(
                      duration: Duration(milliseconds: 500 + (index * 50)),
                      child: buildRecipeCard(
                        filteredFoodItems[index],
                        isDarkMode,
                        accentColor,
                        key: ValueKey(filteredFoodItems[index].id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(bool isDarkMode, Color accentColor, CustomUser? user) {
    return AppBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.green[700],
      elevation: 0,
      title: Text(
        user != null ? "Welcome Back, ${user.name}!" : "Welcome!",
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: accentColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to User Profile
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                user?.profileImageUrl ?? 'https://via.placeholder.com/150',
              ),
              backgroundColor: Colors.grey[300],
            ),
          ),
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

  Widget buildRecipeCard(Food food, bool isDarkMode, Color accentColor, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsScreen(meal: food),
          ),
        );
      },
      child: Hero(
        tag: food.foodName,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: food.imageUrl ?? 'https://via.placeholder.com/150',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.foodName,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 14, color: Colors.redAccent),
                          SizedBox(width: 5),
                          Text(
                            '${food.calories} Cal',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
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
      ),
    );
  }

  Widget buildCustomLoader(Color accentColor) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 100,
          width: 100,
          color: Colors.white,
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

class FadeInOnce extends StatefulWidget {
  final Widget child;

  FadeInOnce({required this.child});

  @override
  _FadeInOnceState createState() => _FadeInOnceState();
}

class _FadeInOnceState extends State<FadeInOnce> with SingleTickerProviderStateMixin {
  bool _hasPlayed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..forward().then((_) {
      setState(() {
        _hasPlayed = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hasPlayed
        ? widget.child
        : FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }
}

