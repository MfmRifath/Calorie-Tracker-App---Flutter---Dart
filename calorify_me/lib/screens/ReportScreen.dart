import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/ThameProvider.dart';
import '../sevices/UserProvider.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color primaryColor = isDarkMode ? Colors.greenAccent : Color(0xFF4CAF50);
    final Color secondaryColor = isDarkMode ? Colors.green : Color(0xFF81C784);
    final Color backgroundColor = isDarkMode ? Colors.black : Color(0xFFE8F5E9);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 4,
        title: Text(
          "Reports Overview",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<FoodProvider, UserProvider>(
          builder: (context, foodProvider, userProvider, child) {
            if (foodProvider.isLoading || userProvider.user == null) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }
            if (foodProvider.dailyFoodLog.isEmpty) {
              return Center(
                child: Text(
                  "No data available for this month.",
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryColor,
                  ),
                ),
              );
            }

            return ListView(
              children: [
                _buildAnimatedSectionHeader("Summary", primaryColor),
                _buildAnimatedSummaryCard(foodProvider, primaryColor),
                SizedBox(height: 20),
                _buildAnimatedSectionHeader("Calories Trend", primaryColor),
                _buildAnimatedCaloriesTrendChart(foodProvider, primaryColor),
                SizedBox(height: 20),
                _buildAnimatedSectionHeader("Nutrient Breakdown", primaryColor),
                _buildAnimatedNutrientBreakdownChart(foodProvider, primaryColor),
                SizedBox(height: 20),
                _buildAnimatedSectionHeader("Hydration Progress", primaryColor),
                _buildAnimatedHydrationProgress(userProvider, primaryColor, secondaryColor),
                SizedBox(height: 20),
                _buildAnimatedSectionHeader("Meal Consistency", primaryColor),
                _buildAnimatedMealConsistencyChart(foodProvider, primaryColor, secondaryColor),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedSectionHeader(String title, Color color) {
    return FadeInLeft(
      duration: Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSummaryCard(FoodProvider foodProvider, Color primaryColor) {
    final totalCalories = foodProvider.dailyFoodLog.fold(0, (sum, food) => sum + food.calories);
    final avgDailyCalories = (totalCalories / foodProvider.dailyFoodLog.length).toInt();
    final highestCalories = foodProvider.dailyFoodLog.map((e) => e.calories).reduce(max);
    final lowestCalories = foodProvider.dailyFoodLog.map((e) => e.calories).reduce(min);

    return SlideInUp(
      duration: Duration(milliseconds: 800),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryTile("Total", "$totalCalories Cal", primaryColor),
                  _buildSummaryTile("Avg Daily", "$avgDailyCalories Cal", Colors.teal),
                  _buildSummaryTile("Highest", "$highestCalories Cal", Colors.redAccent),
                  _buildSummaryTile("Lowest", "$lowestCalories Cal", Colors.orangeAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTile(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildAnimatedCaloriesTrendChart(FoodProvider foodProvider, Color primaryColor) {
    return ZoomIn(
      duration: Duration(milliseconds: 1000),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      foodProvider.dailyFoodLog.length,
                          (index) => FlSpot(
                          index.toDouble(), foodProvider.dailyFoodLog[index].calories.toDouble()),
                    ),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.6), primaryColor],
                    ),
                    barWidth: 4,
                    belowBarData: BarAreaData(show: true, color: primaryColor.withOpacity(0.2)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNutrientBreakdownChart(FoodProvider foodProvider, Color primaryColor) {
    final carbs = foodProvider.dailyFoodLog.fold(0.0, (sum, food) => sum + food.calories);
    final protein = foodProvider.dailyFoodLog.fold(0.0, (sum, food) => sum + food.protein);
    final fats = foodProvider.dailyFoodLog.fold(0.0, (sum, food) => sum + food.fat);

    return FadeInRight(
      duration: Duration(milliseconds: 800),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: carbs, color: Colors.lightGreen, title: "Carbs"),
                  PieChartSectionData(value: protein, color: Colors.teal, title: "Protein"),
                  PieChartSectionData(value: fats, color: Colors.yellowAccent, title: "Fats"),
                ],
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHydrationProgress(UserProvider userProvider, Color primaryColor, Color secondaryColor) {
    final waterLog = userProvider.user?.waterLog;
    final currentWater = waterLog?.currentWaterConsumption ?? 0.0;
    final targetWater = waterLog?.targetWaterConsumption ?? 3000.0;

    return SlideInLeft(
      duration: Duration(milliseconds: 800),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: currentWater / targetWater,
                color: primaryColor,
                backgroundColor: secondaryColor.withOpacity(0.3),
                minHeight: 8,
              ),
              SizedBox(height: 10),
              Text(
                "${currentWater.toInt()} ml / ${targetWater.toInt()} ml",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMealConsistencyChart(FoodProvider foodProvider, Color primaryColor, Color secondaryColor) {
    final mealData = {
      "Breakfast": foodProvider.dailyFoodLog.where((food) => food.mealType == "Breakfast").length,
      "Lunch": foodProvider.dailyFoodLog.where((food) => food.mealType == "Lunch").length,
      "Dinner": foodProvider.dailyFoodLog.where((food) => food.mealType == "Dinner").length,
      "Snacks": foodProvider.dailyFoodLog.where((food) => food.mealType == "Snacks").length,
    };

    return ZoomIn(
      duration: Duration(milliseconds: 1000),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                barGroups: mealData.entries
                    .map(
                      (entry) => BarChartGroupData(
                    x: entry.key.hashCode,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
                        width: 16,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                )
                    .toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}