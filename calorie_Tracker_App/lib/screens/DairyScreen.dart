import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modals/Food.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/UserProvider.dart';
import '../sevices/WaterProvider.dart';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final Color primaryGreen = Color(0xFF4CAF50);
  final Color lightGreen = Color(0xFFE8F5E9);
  final Color darkGreen = Color(0xFF388E3C);

  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data and food log when the screen initializes
  }

  Future<void> loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserData(); // Load user data

    if (mounted) {
      setState(() {
        isLoading = false; // Set loading state to false after data is loaded
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Diary",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGreen,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddFoodDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildSummarySection(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final totalWater = userProvider.user?.waterLog.currentWaterConsumption ?? 0;
    final totalCalories = userProvider.user?.totalCalories ??
        0; // Get total calories from user

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCalorieInfo(
                  "Calories Consumed", "$totalCalories Cal", Colors.orange),
              buildCalorieInfo(
                  "Water Intake", "${totalWater.toStringAsFixed(1)} ml",
                  primaryGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCalorieInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget buildMealSection(BuildContext context, String mealType) {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, child) {
        // Filter foods based on meal type
        final mealFoods = foodProvider.foodLog.where((food) =>
            food.foodName.contains(mealType)).toList();
        final mealCalories = mealFoods.fold(
            0, (total, food) => total + food.calories);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 5)),
            ],
          ),
          child: ListTile(
            title: Text(
              mealType,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen),
            ),
            subtitle: Text("${mealFoods.length} items • $mealCalories Cal"),
            trailing: IconButton(
              icon: Icon(Icons.add_circle, color: primaryGreen),
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => AddFoodDialog());
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildWaterSection(BuildContext context) {
    final waterProvider = Provider.of<WaterProvider>(context);
    final targetWater = waterProvider.waterLog.targetWaterConsumption;

    return FutureBuilder<double>(
      future: Provider.of<UserProvider>(context, listen: false).fetchTotalWaterIntake(), // Call the fetch method
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}")); // Handle errors
        }

        double waterIntake = snapshot.data ?? 0.0; // Get the fetched water intake

        return Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 5)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Water Intake",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Remaining", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  Text("${(targetWater - waterIntake).toStringAsFixed(1)} ml", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
                ],
              ),
              SizedBox(height: 10),
              LinearProgressIndicator(
                value: (waterIntake / targetWater).clamp(0.0, 1.0), // Clamp to prevent overflow
                color: primaryGreen,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  waterProvider.logWater(250); // Log 250ml of water
                  // Call the UserProvider's logWater method to update Firestore
                  Provider.of<UserProvider>(context, listen: false).logWater(250);
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: Text("Log 250ml Water"),
              ),
            ],
          ),
        );
      },
    );
  }

}

class AddFoodDialog extends StatefulWidget {
  @override
  _AddFoodDialogState createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final TextEditingController _quantityController = TextEditingController();
  Food? selectedFood;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final foodSuggestions = userProvider.foodLog;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Add Food"),
      content: isLoading
          ? Center(child: CircularProgressIndicator())
          : foodSuggestions.isEmpty
          ? Text("No food items found in your log.")
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<Food>(
            hint: Text("Select Food"),
            value: selectedFood,
            items: foodSuggestions.map((food) {
              return DropdownMenuItem(
                value: food,
                child: Text(food.foodName),
              );
            }).toList(),
            onChanged: (food) => setState(() => selectedFood = food),
          ),
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Quantity (grams)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedFood != null && _quantityController.text.isNotEmpty) {
              double quantity = double.parse(_quantityController.text);
              double calories = selectedFood!.calories * (quantity / selectedFood!.foodWeight);

              // Log food using FoodProvider
              Provider.of<FoodProvider>(context, listen: false).logFood(Food(
                foodName: selectedFood!.foodName,
                calories: calories.toInt(),
                protein: selectedFood!.protein,
                fat: selectedFood!.fat,
                foodWeight: quantity,
              ));

              Navigator.pop(context);
            }
          },
          child: Text("Add Food"),
        ),
      ],
    );
  }
}
