import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../modals/CustomFood.dart';
import '../modals/Food.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/ThameProvider.dart';
import '../sevices/UserProvider.dart';

class AddFoodDialog extends StatefulWidget {
  final String mealType;

  AddFoodDialog({required this.mealType});

  @override
  _AddFoodDialogState createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final TextEditingController _quantityController = TextEditingController();
  Food? selectedFood;
  bool isLoading = true; // Loading spinner state
  bool isAdding = false; // Adding food loader state
  String? errorMessage; // Error message state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserData();

      if (userProvider.foodLog.isEmpty) {
        setState(() {
          errorMessage = "No food items found in your log.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load food data. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false; // Stop spinner once data is loaded
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final userProvider = Provider.of<UserProvider>(context);
    final foodSuggestions = userProvider.foodLog;

    return ZoomIn(
      duration: Duration(milliseconds: 500),
      child: AlertDialog(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: EdgeInsets.zero,
        title: _buildDialogTitle(isDarkMode),
        content: isLoading
            ? Center(
          child: SpinKitFadingCircle(
            color: isDarkMode ? Colors.greenAccent : Colors.teal,
            size: 50.0,
          ),
        )
            : _buildDialogContent(foodSuggestions, isDarkMode),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SlideInLeft(
                duration: Duration(milliseconds: 300),
                child: TextButton(
                  onPressed: isAdding
                      ? null // Disable cancel button while adding
                      : () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(
                      color: isDarkMode
                          ? Colors.greenAccent
                          : Colors.teal[700],
                    ),
                  ),
                ),
              ),
              SlideInRight(
                duration: Duration(milliseconds: 300),
                child: isAdding
                    ? SpinKitCircle(
                  color: isDarkMode ? Colors.greenAccent : Colors.teal,
                  size: 40.0,
                )
                    : ElevatedButton(
                  onPressed: _addFood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.greenAccent
                        : Colors.teal[700],
                  ),
                  child: Text(
                    "Add Food",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTitle(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDarkMode ? Colors.green : Colors.teal,
            isDarkMode ? Colors.greenAccent : Colors.tealAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(15),
      child: Center(
        child: FadeInDown(
          duration: Duration(milliseconds: 300),
          child: Text(
            "Add Food to ${widget.mealType}",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogContent(List<Food> foodSuggestions, bool isDarkMode) {
    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: GoogleFonts.poppins(
            color: Colors.redAccent,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (foodSuggestions.isEmpty) {
      return Center(
        child: Text(
          "No food items found in your log.",
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.grey[400] : Colors.black87,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<Food>(
          hint: Text(
            "Select Food",
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.greenAccent : Colors.black,
            ),
          ),
          value: selectedFood,
          dropdownColor: isDarkMode ? Colors.black87 : Colors.white,
          items: foodSuggestions.map((food) {
            return DropdownMenuItem(
              value: food,
              child: Text(
                food.foodName,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.greenAccent : Colors.teal[800],
                ),
              ),
            );
          }).toList(),
          onChanged: (food) => setState(() => selectedFood = food),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.poppins(
            color: isDarkMode ? Colors.greenAccent : Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: "Quantity (grams)",
            labelStyle: GoogleFonts.poppins(
              color: isDarkMode ? Colors.greenAccent : Colors.teal[800],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.greenAccent : Colors.teal,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.greenAccent : Colors.teal[800]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _addFood() async {
    if (selectedFood == null) {
      setState(() => errorMessage = "Please select a food item.");
      return;
    }

    if (_quantityController.text.isEmpty ||
        double.tryParse(_quantityController.text) == null) {
      setState(() => errorMessage = "Please enter a valid quantity.");
      return;
    }

    setState(() {
      isAdding = true; // Show loader
      errorMessage = null;
    });

    try {
      double quantity = double.parse(_quantityController.text);
      double calories =
          selectedFood!.calories * (quantity / selectedFood!.foodWeight);

      final consumedFood = ConsumedFood(
        foodName: selectedFood!.foodName,
        calories: calories.toInt(),
        protein: selectedFood!.protein,
        fat: selectedFood!.fat,
        foodWeight: quantity,
        mealType: widget.mealType,
        timestamp: DateTime.now(),
        carbs: selectedFood!.carbs
      );

      await Provider.of<FoodProvider>(context, listen: false)
          .logConsumedFood(consumedFood);

      Navigator.pop(context);
    } catch (e) {
      setState(() => errorMessage = "Failed to add food. Please try again.");
    } finally {
      setState(() {
        isAdding = false; // Hide loader
      });
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}