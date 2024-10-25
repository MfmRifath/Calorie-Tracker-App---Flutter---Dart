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
    required this.foodWeight,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'foodWeight': foodWeight,
    };
  }

  static Food fromMap(Map<String, dynamic> map) {
    return Food(
      foodName: map['foodName'],
      calories: map['calories'],
      protein: map['protein'],
      fat: map['fat'],
      foodWeight: map['foodWeight'],
    );
  }
}
