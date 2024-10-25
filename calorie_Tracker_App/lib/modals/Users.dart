import 'Food.dart';
import 'Water.dart';
import 'BMI.dart';

class CustomUser {
  String id; // Unique identifier (e.g., Firebase User ID)
  String name;
  int age;
  double weight;
  double height;
  List<Food> foodLog;
  Water waterLog;
  late BMI bmi;
  double totalCalories;
  double totalWaterIntake;// Add totalCalories field

  CustomUser({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.foodLog,
    required this.waterLog,
    this.totalCalories = 0,
    this.totalWaterIntake = 0,// Initialize with a default value
  }) {
    bmi = BMI(weight: weight, height: height);
  }

  double calculateBMI() {
    return bmi.calculateBMI();
  }

  String getBMICategory() {
    return bmi.getBMICategory();
  }

  void logFood(Food food) {
    foodLog.add(food);
    totalCalories += food.calories; // Update totalCalories when food is logged
  }

  double getDailyCaloryIntake() {
    return foodLog.fold(0, (total, food) => total + food.calories);
  }

  /// Convert the User object to a map for storing in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'foodLog': foodLog.map((food) => food.toMap()).toList(),
      'waterLog': waterLog.toMap(),
      'totalCalories': totalCalories,
      'totalWaterIntake': totalWaterIntake// Add totalCalories to the map
    };
  }

  /// Convert a Firestore document snapshot to a User object.
  static CustomUser fromMap(Map<String, dynamic> map) {
    return CustomUser(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
      foodLog: (map['foodLog'] as List<dynamic>)
          .map((foodMap) => Food.fromMap(foodMap))
          .toList(),
      waterLog: Water.fromMap(map['waterLog']),
      totalWaterIntake: map['totalWaterIntake']?.toDouble() ?? 0,
        totalCalories: map['totalCalories']?.toDouble() ?? 0// Read totalCalories from Firestore
    );
  }
}
