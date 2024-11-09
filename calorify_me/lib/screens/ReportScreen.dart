import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import '../sevices/FoodProvider.dart';

class ReportsScreen extends StatelessWidget {
  final Color primaryGreen = Color(0xFF4CAF50);
  final Color lightGreen = Color(0xFFE8F5E9);
  final Color darkGreen = Color(0xFF388E3C);
  final Color orangeAccent = Color(0xFFFFA726);
  final Color blueAccent = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeIn(
          duration: Duration(milliseconds: 800),
          child: Text(
            "Monthly Report",
            style: TextStyle(
              color: darkGreen,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [lightGreen, primaryGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Consumer<FoodProvider>(
            builder: (context, foodProvider, child) {
              if (foodProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (foodProvider.dailyFoodLog.isEmpty) {
                return Center(
                  child: Text(
                    "No data available for this month.",
                    style: TextStyle(
                      fontSize: 18,
                      color: darkGreen,
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
                    child: buildHydrationProgress(foodProvider),
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
          colors: [lightGreen, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              color: darkGreen,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSummaryCard("Total", "$totalCalories Cal", orangeAccent),
              buildSummaryCard("Avg Daily", "$avgDailyCalories Cal", blueAccent),
              buildSummaryCard("Highest", "$highestCalories Cal", Colors.red),
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
            color: darkGreen,
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
                        style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
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
                  color: orangeAccent,
                  barWidth: 4,
                  belowBarData: BarAreaData(
                    show: true,
                    color: orangeAccent.withOpacity(0.3),
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
            color: darkGreen,
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
                  color: Colors.red,
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
                  color: Colors.yellow,
                  title: "Fats",
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

  Widget buildHydrationProgress(FoodProvider foodProvider) {
    final totalWater = foodProvider.dailyFoodLog.fold<double>(0.0, (sum, food) => sum + food.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hydration Progress",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: totalWater / 3000,
          color: Colors.blue,
          backgroundColor: Colors.grey[300],
        )
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
            color: darkGreen,
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
                      color: primaryGreen,
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
                      return Text(meal);
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
