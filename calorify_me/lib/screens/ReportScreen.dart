import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/UserProvider.dart';

class ReportsScreen extends StatelessWidget {
  final Color primaryGreen = Color(0xFF1B5E20);
  final Color lightGreen = Color(0xFF66BB6A);
  final Color darkGreen = Color(0xFF004D40);
  final Color accentGreen = Color(0xFF81C784);
  final Color black = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        elevation: 4,
        title: FadeIn(
          duration: Duration(milliseconds: 800),
          child: Text(
            "Monthly Report",
            style: TextStyle(
              color: lightGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Consumer2<FoodProvider, UserProvider>(
            builder: (context, foodProvider, userProvider, child) {
              if (foodProvider.isLoading || userProvider.user == null) {
                return Center(
                  child: CircularProgressIndicator(color: lightGreen),
                );
              }
              if (foodProvider.dailyFoodLog.isEmpty) {
                return Center(
                  child: Text(
                    "No data available for this month.",
                    style: TextStyle(
                      fontSize: 18,
                      color: lightGreen,
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: Duration(milliseconds: 700),
                    child: buildMonthlySummary(foodProvider),
                  ),
                  SizedBox(height: 30),
                  FadeInLeft(
                    duration: Duration(milliseconds: 700),
                    child: buildCaloriesTrendChart(foodProvider),
                  ),
                  SizedBox(height: 30),
                  FadeInRight(
                    duration: Duration(milliseconds: 700),
                    child: buildNutrientBreakdownChart(foodProvider),
                  ),
                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 700),
                    child: buildHydrationProgress(userProvider),
                  ),
                  SizedBox(height: 30),
                  ZoomIn(
                    duration: Duration(milliseconds: 700),
                    child: buildMealConsistencyChart(foodProvider),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildMonthlySummary(FoodProvider foodProvider) {
    final totalCalories = foodProvider.dailyFoodLog.fold(0, (sum, food) => sum + food.calories);
    final avgDailyCalories = (totalCalories / foodProvider.dailyFoodLog.length).toInt();
    final highestCalories = foodProvider.dailyFoodLog.map((e) => e.calories).reduce(max);
    final lowestCalories = foodProvider.dailyFoodLog.map((e) => e.calories).reduce(min);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkGreen, black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Monthly Summary",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: lightGreen,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSummaryCard("Total", "$totalCalories Cal", accentGreen),
              buildSummaryCard("Avg Daily", "$avgDailyCalories Cal", lightGreen),
              buildSummaryCard("Highest", "$highestCalories Cal", Colors.redAccent),
              buildSummaryCard("Lowest", "$lowestCalories Cal", darkGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget buildCaloriesTrendChart(FoodProvider foodProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Calories Trend Over the Month",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: lightGreen,
          ),
        ),
        SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      return Text(
                        (value + 1).toInt().toString(),
                        style: TextStyle(color: lightGreen, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    foodProvider.dailyFoodLog.length,
                        (index) {
                      return FlSpot(
                        index.toDouble(),
                        foodProvider.dailyFoodLog[index].calories.toDouble(),
                      );
                    },
                  ),
                  isCurved: true,
                  color: accentGreen,
                  barWidth: 4,
                  belowBarData: BarAreaData(
                    show: true,
                    color: accentGreen.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNutrientBreakdownChart(FoodProvider foodProvider) {
    final totalCarbs = foodProvider.dailyFoodLog.fold<double>(0.0, (sum, food) => sum + food.calories);
    final totalProteins = foodProvider.dailyFoodLog.fold<double>(0.0, (sum, food) => sum + food.protein);
    final totalFats = foodProvider.dailyFoodLog.fold<double>(0.0, (sum, food) => sum + food.fat);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Monthly Nutrient Breakdown",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: lightGreen,
          ),
        ),
        SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: totalCarbs,
                  color: Colors.blue,
                  title: "Carbs",
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: totalProteins,
                  color: Colors.redAccent,
                  title: "Proteins",
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: totalFats,
                  color: Colors.yellowAccent,
                  title: "Fats",
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHydrationProgress(UserProvider userProvider) {
    final waterLog = userProvider.user?.waterLog;
    final totalWater = waterLog?.currentWaterConsumption ?? 0.0;
    final targetWater = waterLog?.targetWaterConsumption ?? 3000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hydration Progress",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: lightGreen,
          ),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: totalWater / targetWater,
          color: accentGreen,
          backgroundColor: Colors.grey[800],
        ),
        SizedBox(height: 5),
        Text(
          "${totalWater.toStringAsFixed(0)} ml / ${targetWater.toStringAsFixed(0)} ml",
          style: TextStyle(color: lightGreen, fontSize: 16),
        ),
      ],
    );
  }

  Widget buildMealConsistencyChart(FoodProvider foodProvider) {
    final mealCounts = {
      "Breakfast": 0,
      "Lunch": 0,
      "Dinner": 0,
      "Snacks": 0,
    };

    for (var log in foodProvider.dailyFoodLog) {
      mealCounts[log.mealType] = (mealCounts[log.mealType] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Meal Consistency",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: lightGreen,
          ),
        ),
        SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              barGroups: mealCounts.entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key.hashCode,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: accentGreen,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                );
              }).toList(),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final meal = mealCounts.keys.firstWhere(
                              (key) => key.hashCode == value.toInt(),
                          orElse: () => '');
                      return Text(
                        meal,
                        style: TextStyle(color: lightGreen),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
