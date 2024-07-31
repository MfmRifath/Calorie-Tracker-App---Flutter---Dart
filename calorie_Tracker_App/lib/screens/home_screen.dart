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
    AspectRatio(
    aspectRatio: 1.3,
    child: Row(
    children: <Widget>[
    const SizedBox(
    height: 18,
    ),
    Expanded(
    child: AspectRatio(
    aspectRatio: 1,
    child: PieChart(
    PieChartData(
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
    sectionsSpace: 0,
    centerSpaceRadius: 40,
    sections: showingSections(),
    ),
    ),
    ),
    ),
    const Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Indicator(
    color: AppColors.contentColorBlue,
    text: 'First',
    isSquare: true,
    ),
    SizedBox(
    height: 4,
    ),
    Indicator(
    color: AppColors.contentColorYellow,
    text: 'Second',
    isSquare: true,
    ),
    SizedBox(
    height: 4,
    ),
    Indicator(
    color: AppColors.contentColorPurple,
    text: 'Third',
    isSquare: true,
    ),
    SizedBox(
    height: 4,
    ),
    Indicator(
    color: AppColors.contentColorGreen,
    text: 'Fourth',
    isSquare: true,
    ),
    SizedBox(
    height: 18,
    ),
    ],
    ),
    const SizedBox(
    width: 28,
    ),
    ],
    ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
                    ),
                  ),

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
