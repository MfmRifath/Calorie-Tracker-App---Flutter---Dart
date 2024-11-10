class Food {
  String? id;
  String foodName;
  int calories;
  double protein;
  double fat;
  double foodWeight;
  String? imageUrl; // New field for the food image

  Food({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.foodWeight,
    this.imageUrl,
    this.id// Initialize the image URL
  });



  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'foodWeight': foodWeight,
      'imageUrl': imageUrl, // Include the image URL in the map
    };
  }

  static Food fromMap(Map<String, dynamic> map, String id) {
    return Food(
      foodName: map['foodName'],
      calories: map['calories'],
      protein: map['protein'],
      fat: map['fat'],
      foodWeight: map['foodWeight'],
      imageUrl: map['imageUrl'],
      id:map['id'] // Retrieve the image URL from Firestore
    );
  }
}
