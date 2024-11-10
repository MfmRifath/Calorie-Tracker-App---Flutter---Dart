import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/ThameProvider.dart';
import '../sevices/UserProvider.dart';
import '../sevices/WaterProvider.dart';

import 'AddFoodDialog.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late TextEditingController caloryController;
  late TextEditingController waterController;
  late TextEditingController updateWaterController;

  @override
  void initState() {
    super.initState();
    caloryController = TextEditingController();
    waterController = TextEditingController();
    updateWaterController = TextEditingController();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.loadUserData();
      if (mounted) {
        setState(() {
          caloryController.text =
              userProvider.user?.targetCalories?.toString() ?? '2000';
          waterController.text =
              userProvider.user?.waterLog.targetWaterConsumption.toString() ??
                  '2000';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading user data: $e")),
      );
    }
  }

  @override
  void dispose() {
    caloryController.dispose();
    waterController.dispose();
    updateWaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.grey[900]!, Colors.black]
                  : [Colors.green.shade400, Colors.green.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Diary",
          style: TextStyle(
            color: isDarkMode ? Colors.greenAccent : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: FadeInUp(
            duration: Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTargetSection(context, isDarkMode),
                buildSummarySection(context, isDarkMode),
                buildMealSection(context, "Breakfast", isDarkMode),
                buildMealSection(context, "Lunch", isDarkMode),
                buildMealSection(context, "Dinner", isDarkMode),
                buildMealSection(context, "Snacks", isDarkMode),
                SizedBox(height: 20),
                buildWaterSection(context, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTargetSection(BuildContext context, bool isDarkMode) {
    return _buildAnimatedCard(
      isDarkMode: isDarkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Set Daily Targets', isDarkMode),
          SizedBox(height: 10),
          _customTextField(
            controller: caloryController,
            label: "Target Daily Calories (Cal)",
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 10),
          _customTextField(
            controller: waterController,
            label: "Target Daily Water Intake (ml)",
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final userProvider =
              Provider.of<UserProvider>(context, listen: false);
              final waterProvider =
              Provider.of<WaterProvider>(context, listen: false);
              final newCalories = int.tryParse(caloryController.text) ?? 2000;
              final newWaterIntake =
                  double.tryParse(waterController.text) ?? 2000;

              userProvider.setTargetCalories(newCalories);
              waterProvider.setTargetWaterConsumption(newWaterIntake);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Targets updated successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "Update Targets",
              style: TextStyle(
                  fontSize: 16, color: isDarkMode ? Colors.black : Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummarySection(BuildContext context, bool isDarkMode) {
    return Consumer2<FoodProvider, UserProvider>(
      builder: (context, foodProvider, userProvider, child) {
        final totalWater =
            userProvider.user?.waterLog.currentWaterConsumption ?? 0;
        final totalCalories = foodProvider.getTotalCalories();

        return _buildAnimatedCard(
          isDarkMode: isDarkMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Summary', isDarkMode),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCalorieInfo(
                      "Calories Consumed", "$totalCalories Cal", Colors.green),
                  buildCalorieInfo("Water Intake",
                      "${totalWater.toStringAsFixed(1)} ml", Colors.blue),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMealSection(
      BuildContext context, String mealType, bool isDarkMode) {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, child) {
        final mealCalories = foodProvider.getMealCalories(mealType);

        return _buildAnimatedCard(
          isDarkMode: isDarkMode,
          child: ListTile(
            title: Text(
              mealType,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            subtitle: Text(
              "Calories: $mealCalories Cal",
              style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_circle, color: Colors.greenAccent),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AddFoodDialog(mealType: mealType),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildWaterSection(BuildContext context, bool isDarkMode) {
    return Consumer<WaterProvider>(
      builder: (context, waterProvider, child) {
        final targetWater = waterProvider.waterLog.targetWaterConsumption;
        final waterIntake = waterProvider.waterLog.currentWaterConsumption;

        return _buildAnimatedCard(
          isDarkMode: isDarkMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Water Intake', isDarkMode),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remaining",
                    style: TextStyle(
                        color:
                        isDarkMode ? Colors.white70 : Colors.grey.shade700,
                        fontSize: 16),
                  ),
                  Text(
                    "${(targetWater - waterIntake).toStringAsFixed(1)} ml",
                    style: TextStyle(fontSize: 18, color: Colors.greenAccent),
                  ),
                ],
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: (waterIntake / targetWater).clamp(0.0, 1.0),
                color: Colors.greenAccent,
                backgroundColor:
                isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
              SizedBox(height: 10),
              _customTextField(
                controller: updateWaterController,
                label: "Add Water Intake (ml)",
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final addedWater =
                      double.tryParse(updateWaterController.text) ?? 0.0;
                  if (addedWater > 0) {
                    waterProvider.logWater(addedWater);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Water intake updated!")),
                    );
                    updateWaterController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Update Water Intake",
                  style: TextStyle(
                      color: isDarkMode ? Colors.black : Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required Widget child, required bool isDarkMode}) {
    return FadeIn(
      duration: Duration(milliseconds: 500),
      child: _buildCard(child: child, isDarkMode: isDarkMode),
    );
  }

  Widget _buildCard({required Widget child, required bool isDarkMode}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade300,
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.greenAccent : Colors.green.shade900),
    );
  }

  Widget _customTextField(
      {required TextEditingController controller,
        required String label,
        required bool isDarkMode}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
          color: isDarkMode ? Colors.greenAccent : Colors.green.shade900),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent)),
      ),
    );
  }

  Widget buildCalorieInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16, color: color.withOpacity(0.7))),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
