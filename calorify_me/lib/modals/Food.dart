class Food {
  String? id; // Firestore document ID
  String foodName;
  int calories;
  String? description;
  double protein;
  double fat;
  double foodWeight;
  String? imageUrl; // Optional field for the food image

  Food({
    this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.foodWeight,
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
      'description':description// Include the image URL in the map
    };
  }

  // Create a Food object from Firestore data
  static Food fromMap(Map<String, dynamic> map, String id) {
    return Food(
      id: id, // Assign Firestore document ID
      foodName: map['foodName'] ?? '',
      calories: map['calories'] ?? 0,
      protein: (map['protein'] ?? 0.0).toDouble(),
      fat: (map['fat'] ?? 0.0).toDouble(),
      foodWeight: (map['foodWeight'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'],
      description: map['description'] ?? "",
    );
  }
}