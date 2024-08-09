import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PichartContainer extends StatefulWidget {
  @override
  State<PichartContainer> createState() => _PichartContainerState();
}

class _PichartContainerState extends State<PichartContainer> {
  int touchedIndex = -1;
  final double chartSize = 100.0; // Reduced chart size

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18.0 : 14.0; // Adjusted font size
      final double radius = isTouched ? 40.0 : 35.0; // Adjusted radius
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25.0,right: 10.0),
      width: chartSize + 15.0,
      height: chartSize + 50.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PieChart(
            PieChartData(
              sections: showingSections(),
              centerSpaceRadius: 40, // Reduced center space radius
              sectionsSpace: 1,
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
          Text(
            'Total\n100%',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0, // Adjusted text size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
