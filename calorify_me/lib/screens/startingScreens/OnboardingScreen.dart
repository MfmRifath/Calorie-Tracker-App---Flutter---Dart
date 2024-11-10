import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

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
    return Scaffold(
      body: Stack(
        children: [
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
                      color: Colors.black87,
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
                            ? Colors.greenAccent[400]
                            : Colors.black45,
                        boxShadow: currentPage == index
                            ? [BoxShadow(color: Colors.green, blurRadius: 6)]
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
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 14.0,
                      ),
                    ),
                    child: Text(
                      "Finish",
                      style: TextStyle(
                        color: Colors.white,
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
                      color: Colors.black87,
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
