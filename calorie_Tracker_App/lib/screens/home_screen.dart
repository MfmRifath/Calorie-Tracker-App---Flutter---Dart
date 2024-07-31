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

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.lightBlueAccent,
          width: 22,
        ),
      ],
    );
  }

  List<BarChartGroupData> showingBarGroups() {
    return List.generate(4, (i) {
      switch (i) {
        case 0:
          return makeGroupData(i, 40);
        case 1:
          return makeGroupData(i, 30);
        case 2:
          return makeGroupData(i, 20);
        case 3:
          return makeGroupData(i, 10);
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
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.white24,
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
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white54,
                      width: chartSize,
                      height: chartSize,
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
                      color: Colors.white54,
                      width: chartSize,
                      height: chartSize,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 50,
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipPadding: EdgeInsets.all(8),
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      String weekDay;
                                      switch (group.x.toInt()) {
                                        case 0:
                                          weekDay = 'Monday';
                                          break;
                                        case 1:
                                          weekDay = 'Tuesday';
                                          break;
                                        case 2:
                                          weekDay = 'Wednesday';
                                          break;
                                        case 3:
                                          weekDay = 'Thursday';
                                          break;
                                        default:
                                          throw Error();
                                      }
                                      return BarTooltipItem(
                                        weekDay + '\n',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: (rod.toY).toString(),
                                            style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (double value, TitleMeta meta) {
                                        const style = TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        );
                                        Widget text;
                                        switch (value.toInt()) {
                                          case 0:
                                            text = Text('Mon', style: style);
                                            break;
                                          case 1:
                                            text = Text('Tue', style: style);
                                            break;
                                          case 2:
                                            text = Text('Wed', style: style);
                                            break;
                                          case 3:
                                            text = Text('Thu', style: style);
                                            break;
                                          default:
                                            text = Text('', style: style);
                                            break;
                                        }
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space: 16,
                                          child: text,
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroups(),
                              ),
                            ),
                          ),
                          Text(
                            'Daily Calorie Consumption',
                            style: GoogleFonts.akayaTelivigala(
                              textStyle: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xff00ab00)),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Set Goal',
                            style: GoogleFonts.akayaTelivigala(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xff00ab00)),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Today's Calories",
                            style: GoogleFonts.akayaTelivigala(
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(

                  decoration: BoxDecoration(
                    color: Colors.white54,
                    border: Border.all(
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Uniform radius
                  ),
                  child: ListView(
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
