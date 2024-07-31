// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_meal_screen.dart';
import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart_app/presentation/widgets/indicator.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(

            children: <Widget>[
              Expanded(
                  child: Container(

                    color: Colors.white24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: Image(image: AssetImage('assets/images/app_icon.png'),
                          width: 100.0, height: 100.0,
                          fit: BoxFit.fill,),
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Calorie Tracker',
                          style:GoogleFonts.aladin(
                            textStyle: TextStyle(
                                fontSize: 50.0
                            ),
                          )
                        ),
                      ],
                    ),
                  ),

              ),
              Expanded(child: Row(
                children: <Widget>[
                  PieChart(

                    PieChartData(
                      
                    ),
                  )
                ],

              ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.fastfood),
                      title: Text('Breakfast'),
                      subtitle: Text('300 kcal'),
                    ),
                    ListTile(
                      leading: Icon(Icons.lunch_dining),
                      title: Text('Lunch'),
                      subtitle: Text('600 kcal'),
                    ),
                    ListTile(
                      leading: Icon(Icons.dinner_dining),
                      title: Text('Dinner'),
                      subtitle: Text('700 kcal'),
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
    );
  }
}
