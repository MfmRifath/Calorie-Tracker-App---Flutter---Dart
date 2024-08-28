class Food {
  String foodName;
  int calories;
  double protein;
  double fat;
  double foodWeight;

  Food({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.foodWeight
  });

  String getNutritionalInfo() {
    return 'Food: $foodName, Calories: $calories, Protein: $protein g, Fat: $fat g';
  }

  double calculateCaloriesPerGram() {
    return calories / foodWeight;
  }
}
