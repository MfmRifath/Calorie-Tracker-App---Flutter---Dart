import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modals/CustomFood.dart';
import '../modals/Food.dart';
import '../sevices/FoodProvider.dart';
import '../sevices/UserProvider.dart';

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
    final userProvider = Provider.of<UserProvider>(context);
    final foodSuggestions = userProvider.foodLog;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text("Add Food to ${widget.mealType}"),
      content: isLoading
          ? Center(child: CircularProgressIndicator())
          : foodSuggestions.isEmpty
          ? Text("No food items found in your log.")
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
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
          onPressed: _addFood,
          child: Text("Add Food"),
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
