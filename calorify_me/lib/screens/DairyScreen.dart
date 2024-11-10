import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/UserProvider.dart';
import '../sevices/WaterProvider.dart';
import 'AddFoodDialog.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final Color primaryGreen = Color(0xFF1B5E20);
  final Color lightGreen = Color(0xFFA5D6A7);
  final Color darkGreen = Color(0xFF004D40);
  final Color accentColor = Color(0xFF66BB6A);
  final Color black = Colors.black;

  late TextEditingController caloryController;
  late TextEditingController waterController;
  late TextEditingController updateWaterController;

  @override
  void initState() {
    super.initState();
    caloryController = TextEditingController();
    waterController = TextEditingController();
    updateWaterController = TextEditingController(); // Ensures initialization
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkGreen, accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Diary",
          style: TextStyle(
            color: Colors.white,
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
                buildTargetSection(context),
                buildSummarySection(context),
                buildMealSection(context, "Breakfast"),
                buildMealSection(context, "Lunch"),
                buildMealSection(context, "Dinner"),
                buildMealSection(context, "Snacks"),
                SizedBox(height: 20),
                buildWaterSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTargetSection(BuildContext context) {
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Set Daily Targets'),
          SizedBox(height: 10),
          _customTextField(
            controller: caloryController,
            label: "Target Daily Calories (Cal)",
          ),
          SizedBox(height: 10),
          _customTextField(
            controller: waterController,
            label: "Target Daily Water Intake (ml)",
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final waterProvider = Provider.of<WaterProvider>(context, listen: false);
              final newCalories = int.tryParse(caloryController.text) ?? 2000;
              final newWaterIntake = double.tryParse(waterController.text) ?? 2000;

              userProvider.setTargetCalories(newCalories);
              waterProvider.setTargetWaterConsumption(newWaterIntake);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Targets updated successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "Update Targets",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummarySection(BuildContext context) {
    return Consumer2<FoodProvider, UserProvider>(
      builder: (context, foodProvider, userProvider, child) {
        final totalWater = userProvider.user?.waterLog.currentWaterConsumption ?? 0;
        final totalCalories = foodProvider.getTotalCalories();

        return _buildAnimatedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Summary'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildCalorieInfo("Calories Consumed", "$totalCalories Cal", accentColor),
                  buildCalorieInfo("Water Intake", "${totalWater.toStringAsFixed(1)} ml", primaryGreen),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMealSection(BuildContext context, String mealType) {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, child) {
        final mealCalories = foodProvider.getMealCalories(mealType);

        return _buildAnimatedCard(
          child: ListTile(
            title: Text(
              mealType,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accentColor),
            ),
            subtitle: Text(
              "Calories: $mealCalories Cal",
              style: TextStyle(color: Colors.white70),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_circle, color: accentColor),
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

  Widget buildWaterSection(BuildContext context) {
    return Consumer<WaterProvider>(
      builder: (context, waterProvider, child) {
        final targetWater = waterProvider.waterLog.targetWaterConsumption;
        final waterIntake = waterProvider.waterLog.currentWaterConsumption;

        return _buildAnimatedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Water Intake'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remaining",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    "${(targetWater - waterIntake).toStringAsFixed(1)} ml",
                    style: TextStyle(fontSize: 18, color: accentColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: (waterIntake / targetWater).clamp(0.0, 1.0),
                color: accentColor,
                backgroundColor: Colors.grey[800],
              ),
              SizedBox(height: 10),
              _customTextField(
                controller: updateWaterController,
                label: "Add Water Intake (ml)",
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final addedWater = double.tryParse(updateWaterController.text) ?? 0.0;
                  if (addedWater > 0) {
                    waterProvider.logWater(addedWater);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Water intake updated!")),
                    );
                    updateWaterController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Update Water Intake",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return FadeIn(
      duration: Duration(milliseconds: 500),
      child: _buildCard(child: child),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent),
    );
  }

  Widget _customTextField({required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
      ),
    );
  }

  Widget buildCalorieInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.white70)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  void _showAddFoodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddFoodDialog(mealType: "General"),
    );
  }
}
