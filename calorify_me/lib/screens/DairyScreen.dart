import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals/Users.dart';
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
              userProvider.user?.waterLog?.targetWaterConsumption?.toString() ?? '2000';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Increased height for visual prominence
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.greenAccent.shade400, Colors.black]
                  : [Colors.green.shade400, Colors.green.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Smoothly rounded bottom corners
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section with Ripple Effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          center: Alignment.center,
                          radius: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.greenAccent.withOpacity(0.8)
                              : Colors.white.withOpacity(0.7),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png', // Replace with the path to your app logo
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                // Title Section
                Text(
                  "Diary",
                  style: TextStyle(
                    fontFamily: 'Pacifico', // Elegant font for a premium feel
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.greenAccent : Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(3, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSummarySection(context, isDarkMode),
              SizedBox(height: 20),
              buildMealSection(context, "Breakfast", isDarkMode),
              buildMealSection(context, "Lunch", isDarkMode),
              buildMealSection(context, "Dinner", isDarkMode),
              buildMealSection(context, "Snacks", isDarkMode),
              SizedBox(height: 20),
              buildWaterSection(context, isDarkMode),
              SizedBox(height: 20),
              buildTargetSection(context, isDarkMode),

            ],
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
          SizedBox(height: 15),
          _customAnimatedTextField(
            controller: caloryController,
            label: "Target Daily Calories (Cal)",
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 15),
          _customAnimatedTextField(
            controller: waterController,
            label: "Target Daily Water Intake (ml)",
            isDarkMode: isDarkMode,
          ),
          SizedBox(height: 25),
          Center(
            child: ElevatedButton(
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
                  SnackBar(
                    content: Text("Targets updated successfully!"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: isDarkMode
                    ? Colors.greenAccent.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
              ),
              child: Text(
                "Update Targets",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom animated text field with smooth focus transitions.
  Widget _customAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required bool isDarkMode,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: Duration(milliseconds: 500),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.grey[900],
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.greenAccent : Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.grey[850]
                  : Colors.grey[200], // Subtle background
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.greenAccent : Colors.green,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[850] ?? Colors.black : Colors.grey[200] ?? Colors.white,),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget buildSummarySection(BuildContext context, bool isDarkMode) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder<CustomUser?>(
      future: userProvider.findCurrentCustomUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error loading user data: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          final customUser = snapshot.data!;

          return _buildAnimatedCard(
            isDarkMode: isDarkMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Your Daily Summary', isDarkMode),
                SizedBox(height: 20),
                Text(
                  "Keep up the great work! Stay hydrated and eat healthy.",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEnhancedProgressIndicator(
                      "Calories",
                      customUser.getDailyCaloryIntake(),
                      customUser.targetCalories?.toDouble() ?? 2000.0,
                      Colors.green,
                      Icons.local_fire_department,
                    ),
                    _buildEnhancedProgressIndicator(
                      "Water",
                      customUser.waterLog?.currentWaterConsumption ?? 0.0,
                      customUser.waterLog?.targetWaterConsumption ?? 2000.0,
                      Colors.blue,
                      Icons.water_drop,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        } else {
          return Center(child: Text("No user data found."));
        }
      },
    );
  }
// Enhanced progress indicator with animations and icons
  Widget _buildEnhancedProgressIndicator(
      String title, double value, double max, Color color, IconData icon) {
    double progressValue = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;

    return Column(
      children: [
        AnimatedCircularProgressIndicator(
          value: progressValue,
          color: color,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          "${value.toInt()} / ${max.toInt()}",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }


  Widget buildMealSection(
      BuildContext context, String mealType, bool isDarkMode) {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, child) {
        final mealCalories = foodProvider.getMealCalories(mealType);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFoodDialog(mealType: mealType),
              ),
            );
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isHovered = false;

              return MouseRegion(
                onEnter: (event) {
                  setState(() {
                    isHovered = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    isHovered = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(isHovered ? 12 : 10),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? (isDarkMode
                        ? Colors.grey[700]
                        : Colors.green[50])
                        : (isDarkMode
                        ? Colors.grey[850]
                        : Colors.white),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(isHovered ? 0.7 : 0.5)
                            : Colors.grey.withOpacity(isHovered ? 0.5 : 0.3),
                        blurRadius: isHovered ? 15 : 10,
                        offset: Offset(0, isHovered ? 8 : 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isHovered
                              ? (isDarkMode
                              ? Colors.greenAccent
                              : Colors.green[300])
                              : (isDarkMode
                              ? Colors.greenAccent.withOpacity(0.9)
                              : Colors.green[100]),
                        ),
                        padding: EdgeInsets.all(isHovered ? 12 : 10),
                        child: Icon(
                          Icons.fastfood,
                          color: isDarkMode
                              ? Colors.black
                              : (isHovered
                              ? Colors.green
                              : Colors.greenAccent),
                          size: isHovered ? 28 : 24,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mealType,
                              style: TextStyle(
                                fontSize: isHovered ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: isHovered
                                    ? (isDarkMode
                                    ? Colors.greenAccent
                                    : Colors.green[900])
                                    : (isDarkMode
                                    ? Colors.greenAccent
                                    : Colors.green[800]),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Calories: $mealCalories Cal",
                              style: TextStyle(
                                fontSize: 14,
                                color: isHovered
                                    ? (isDarkMode
                                    ? Colors.white
                                    : Colors.black87)
                                    : (isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: isHovered ? 1.0 : 0.8,
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: isHovered ? 18 : 16,
                          color: isHovered
                              ? (isDarkMode ? Colors.white : Colors.grey[800])
                              : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
        final remainingWater = (targetWater - waterIntake).clamp(0.0, targetWater);

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
                    "Remaining:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    "${remainingWater.toStringAsFixed(1)} ml",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.greenAccent : Colors.green[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                    begin: 0.0, end: (waterIntake / targetWater).clamp(0.0, 1.0)),
                duration: Duration(milliseconds: 500),
                builder: (context, value, _) {
                  return Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width * value,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _customTextField(
                      controller: updateWaterController,
                      label: "Add Water (ml)",
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  SizedBox(width: 10),
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
                      "Add",
                      style: TextStyle(
                          color: isDarkMode ? Colors.black : Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: remainingWater == 0 ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Goal Achieved!",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required Widget child, required bool isDarkMode}) {
    return SlideInUp(
      duration: Duration(milliseconds: 500),
      child: _buildCard(child: child, isDarkMode: isDarkMode),
    );
  }

  Widget _buildCard({required Widget child, required bool isDarkMode}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
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
        color: isDarkMode ? Colors.greenAccent : Colors.green.shade900,
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String label,
    required bool isDarkMode,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: isDarkMode ? Colors.greenAccent : Colors.green.shade900,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
  }
}// Circular progress indicator with smooth animation
class AnimatedCircularProgressIndicator extends StatelessWidget {
  final double value;
  final Color color;

  const AnimatedCircularProgressIndicator({
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double validatedValue = value.clamp(0.0, 1.0);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: validatedValue),
      duration: Duration(seconds: 2),
      builder: (context, double animatedValue, child) {
        return CircularProgressIndicator(
          value: animatedValue,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 6,
        );
      },
    );
  }
}