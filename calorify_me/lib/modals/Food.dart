class Food {
  String? id; // Firestore document ID
  String foodName;
  int calories;
  String? description;
  double protein;
  double fat;
  double foodWeight;
  String? imageUrl;
  double carbs; // Optional field for the food image

  Food({
    this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.foodWeight,
    required this.carbs,
    this.description,
    this.imageUrl,
  });

  // Convert the Food object into a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'foodWeight': foodWeight,
      'imageUrl': imageUrl,
      'carbs': carbs,
      'description': description, // Include the description in the map
    };
  }

  // Create a Food object from Firestore data
  static Food fromMap(Map<String, dynamic> map, String id) {
    return Food(
      id: id, // Assign Firestore document ID
      foodName: map['foodName'] ?? '',
      calories: map['calories'] ?? 0,
      protein: _convertToDouble(map['protein']),
      fat: _convertToDouble(map['fat']),
      foodWeight: _convertToDouble(map['foodWeight']),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      carbs: _convertToDouble(map['carbs']),
    );
  }

  // Enhanced method to handle int, double, and String conversions to double
  static double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble(); // Convert int to double
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0; // Attempt to parse String to double
    } else {
      return 0.0; // Default value in case of null or unexpected type
    }
  }
}