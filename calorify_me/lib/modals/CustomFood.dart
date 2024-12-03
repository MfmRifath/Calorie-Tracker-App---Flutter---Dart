class ConsumedFood {
  final String foodName;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double foodWeight;
  final String mealType; // Breakfast, Lunch, Dinner, Snacks
  final DateTime timestamp; // Track when the food was consumed

  ConsumedFood({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.foodWeight,
    required this.mealType,
    required this.timestamp,
    required this.carbs
  });

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'foodWeight': foodWeight,
      'mealType': mealType,
      'timestamp': timestamp.toIso8601String(),
      'carbs': carbs,
    };
  }

  /// Create object from Firestore map
  factory ConsumedFood.fromMap(Map<String, dynamic> map) {
    return ConsumedFood(
      foodName: map['foodName'] ?? 'Unknown Food',
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0).toDouble(),
      fat: (map['fat'] ?? 0).toDouble(),
      foodWeight: (map['foodWeight'] ?? 0).toDouble(),
      mealType: map['mealType'] ?? 'Unknown Meal',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      carbs: map['carbs']
    );
  }





  /// Create a copy with updated fields
  ConsumedFood copyWith({
    String? foodName,
    int? calories,
    double? protein,
    double? fat,
    double? carbs,
    double? foodWeight,
    String? mealType,
    DateTime? timestamp,
  }) {
    return ConsumedFood(
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      foodWeight: foodWeight ?? this.foodWeight,
      mealType: mealType ?? this.mealType,
      timestamp: timestamp ?? this.timestamp,
      carbs: carbs ?? this.carbs
    );
  }
}
