import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
// Import ThemeProvider
import '../../sevices/ThameProvider.dart';
import 'SignScreen.dart';
import 'StartingScreen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> _pages = [
    StartingScreen(
      Description: 'Congratulations on taking the first step toward a healthier you!',
      heading: 'Welcome!',
      img: 'welcome',
    ),
    StartingScreen(
      Description: 'Easily log your meals, snacks, and water intake',
      heading: 'Effortless Tracking',
      img: 'EFT',
    ),
    StartingScreen(
      Description: 'Set realistic goals and watch your progress unfold',
      heading: 'Goal Setting',
      img: 'goal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Color(0xFF0F2027), Color(0xFF2C5364)]
                    : [Color(0xFFffffff), Color(0xFFc3e8ff)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) => ZoomIn(
              duration: Duration(milliseconds: 800),
              child: _pages[index],
            ),
          ),
          // Navigation and Dots
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage == 0
                    ? SizedBox.shrink()
                    : FadeInLeft(
                  duration: Duration(milliseconds: 800),
                  child: IconButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.back,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 28.0,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      margin: EdgeInsets.symmetric(horizontal: 6.0),
                      width: currentPage == index ? 20.0 : 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == index
                            ? (isDarkMode ? Colors.greenAccent[400] : Colors.blueAccent)
                            : Colors.grey,
                        boxShadow: currentPage == index
                            ? [BoxShadow(color: isDarkMode ? Colors.greenAccent : Colors.blue, blurRadius: 6)]
                            : [],
                      ),
                    ),
                  ),
                ),
                currentPage == _pages.length - 1
                    ? FadeInRight(
                  duration: Duration(milliseconds: 800),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.greenAccent[700] : Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 14.0,
                      ),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : FadeInRight(
                  duration: Duration(milliseconds: 800),
                  child: IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.forward,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 28.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
