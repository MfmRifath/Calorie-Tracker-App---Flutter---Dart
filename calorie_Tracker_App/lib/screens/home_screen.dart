import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modals/chart_modal.dart';
import 'add_meal_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int touchedIndex = -1;
  int _selectedIndex = 0;

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25.0 : 18.0;
      final double radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Add logic to handle navigation or other actions based on the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    double chartSize = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  border: Border.all(
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Uniform radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const ClipOval(
                      child: Image(
                        image: AssetImage('assets/images/app_icon.png'),
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Calorie Tracker',
                      style: GoogleFonts.aladin(
                        textStyle: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15.0),
                    width: chartSize + 15.0,
                    height: chartSize + 50.0,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sections: showingSections(),
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                              startDegreeOffset: 0,
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Calorie %',
                          style: GoogleFonts.akayaTelivigala(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    height:chartSize + 50.0,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.flag),
                            Text(
                              'Calorie %',
                              style: GoogleFonts.akayaTelivigala(
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.spoon),
                            Text(
                              'Calorie %',
                              style: GoogleFonts.akayaTelivigala(
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.fire),
                            Text(
                              'Calorie %',
                              style: GoogleFonts.akayaTelivigala(
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  border: Border.all(
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Uniform radius
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: const <Widget>[
                    ListTile(
                      leading: Icon(Icons.fastfood),
                      title: Text('Breakfast'),
                      subtitle: Text('300 kcal'),
                      focusColor: Colors.white24,
                    ),
                    ListTile(
                      leading: Icon(Icons.lunch_dining),
                      title: Text('Lunch'),
                      subtitle: Text('600 kcal'),
                      focusColor: Colors.white24,
                    ),
                    ListTile(
                      leading: Icon(Icons.dinner_dining),
                      title: Text('Dinner'),
                      subtitle: Text('700 kcal'),
                      focusColor: Colors.white24,
                      hoverColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff8f8),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff00ab00),
        onTap: _onItemTapped,
      ),
    );
  }
}
