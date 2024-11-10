import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modals/CustomFood.dart';
import '../modals/Food.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/UserProvider.dart';
import '../sevices/ThameProvider.dart';

class AddFoodDialog extends StatefulWidget {
  final String mealType; // Meal type passed from DiaryScreen

  AddFoodDialog({required this.mealType});

  @override
  _AddFoodDialogState createState() => _AddFoodDialogState();
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final TextEditingController _quantityController = TextEditingController();
  Food? selectedFood;
  bool isLoading = true;
  String? errorMessage; // To show error messages

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserData();
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load food data. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final userProvider = Provider.of<UserProvider>(context);
    final foodSuggestions = userProvider.foodLog;

    return AlertDialog(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Add Food to ${widget.mealType}",
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: isDarkMode ? Colors.greenAccent : Colors.teal[800],
        ),
      ),
      content: isLoading
          ? Center(child: CircularProgressIndicator())
          : foodSuggestions.isEmpty
          ? Text(
        "No food items found in your log.",
        style: GoogleFonts.poppins(
          color: isDarkMode ? Colors.grey[400] : Colors.black87,
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
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
                    color: isDarkMode
                        ? Colors.greenAccent
                        : Colors.teal[800],
                  ),
                ),
              );
            }).toList(),
            onChanged: (food) => setState(() => selectedFood = food),
          ),
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
                  color:
                  isDarkMode ? Colors.greenAccent : Colors.teal,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkMode
                      ? Colors.greenAccent
                      : Colors.teal[800]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.greenAccent : Colors.teal,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _addFood,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isDarkMode ? Colors.greenAccent : Colors.teal[700],
          ),
          child: Text(
            "Add Food",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _addFood() {
    if (selectedFood == null) {
      setState(() => errorMessage = "Please select a food item.");
      return;
    }

    if (_quantityController.text.isEmpty ||
        double.tryParse(_quantityController.text) == null) {
      setState(() => errorMessage = "Please enter a valid quantity.");
      return;
    }

    double quantity = double.parse(_quantityController.text);
    double calories = selectedFood!.calories * (quantity / selectedFood!.foodWeight);

    final consumedFood = ConsumedFood(
      foodName: selectedFood!.foodName,
      calories: calories.toInt(),
      protein: selectedFood!.protein,
      fat: selectedFood!.fat,
      foodWeight: quantity,
      mealType: widget.mealType,
      timestamp: DateTime.now(),
    );

    Provider.of<FoodProvider>(context, listen: false).logConsumedFood(consumedFood);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
