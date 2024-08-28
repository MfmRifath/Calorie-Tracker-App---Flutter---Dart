import 'package:calorie_tracker_app/screens/startingScreens/StartingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SignScreen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  List<Widget> _pages = [
    StartingScreen(Description: 'Congratulations on taking the first step toward a healthier you!',
        heading: 'Welcome!', img: 'welcome'),
    StartingScreen(Description: 'Easily log your meals, snacks and water intake', 
        heading: 'Effortless Tracking', img: 'EFT'),
    StartingScreen(Description: 'Set realistic goals and watch your progress unfold',
        heading: 'Goal Setting', img: 'goal')
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
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentPage == 0
                    ? SizedBox.shrink()
                    : IconButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  icon: Icon(CupertinoIcons.back),
                ),
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      width: currentPage == index ? 12.0 : 8.0,
                      height: currentPage == index ? 12.0 : 8.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == index
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                currentPage == _pages.length - 1
                    ? TextButton(
                  onPressed: () {
                    // Handle end of onboarding, like navigation to the home screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignScreen(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Color(0xff58B9A8))
                  ),
                  child: Text("Finish",
                  style: TextStyle(
                    color: Colors.white
                  ),),
                )
                    : IconButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  icon: Icon(CupertinoIcons.forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
