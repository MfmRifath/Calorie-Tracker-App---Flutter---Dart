import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomFood.dart';
import 'Food.dart';
import 'Water.dart';
import 'BMI.dart';

class CustomUser {
  String id; // Unique identifier (e.g., Firebase User ID)
  String name;
  int age;
  String email;
  double weight;
  double height;
  List<Food>? foodLog;
  Water waterLog;
  late BMI bmi;
  double totalCalories;
  double totalWaterIntake;
  String? profileImageUrl;
  int targetCalories;

  List<ConsumedFood>? consumedFoodLog = [];

  CustomUser({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.waterLog,
    required this.email,
    this.profileImageUrl,
    this.totalCalories = 0,
    this.totalWaterIntake = 0,
    this.targetCalories = 2000,
  }) {
    bmi = BMI(weight: weight, height: height);
  }

  double calculateBMI() => bmi.calculateBMI();

  String getBMICategory() => bmi.getBMICategory();

  void logFood(Food food) {
    foodLog!.add(food);
    totalCalories += food.calories;
  }

  void logConsumedFood(ConsumedFood consumedFood) {
    consumedFoodLog!.add(consumedFood);
  }

  double getDailyCaloryIntake() {
    return consumedFoodLog!.fold(0, (total, food) => total + food.calories);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'foodLog': foodLog!.map((food) => food.toMap()).toList(),
      'waterLog': waterLog.toMap(),
      'totalCalories': totalCalories,
      'totalWaterIntake': totalWaterIntake,
      'targetCalories': targetCalories,
      'profileImageUrl':profileImageUrl,
      'email':email
    };
  }

  static Future<CustomUser> fromFirestore(Map<String, dynamic> data, String userId) async {
    final foodSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('foodLog')
        .get();

    final consumedFoodSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyFoodLog')
        .get();

    return CustomUser(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Unknown',
      age: data['age'] ?? 0,
      weight: (data['weight'] ?? 0.0).toDouble(),
      height: (data['height'] ?? 0.0).toDouble(),
      waterLog: Water.fromMap(data['waterLog'] ?? {}),
      targetCalories: data['targetCalories'] ?? 2000,
      profileImageUrl: data['profileImageUrl'],
      email: data['email']?? ''
    )
      ..foodLog = foodSnapshot.docs.map((doc) => Food.fromMap(doc.data(),doc.id)).toList()
      ..consumedFoodLog =
      consumedFoodSnapshot.docs.map((doc) => ConsumedFood.fromMap(doc.data())).toList();
  }
  Future<void> saveConsumedFoodLog() async {
    final batch = FirebaseFirestore.instance.batch();

    for (final consumedFood in consumedFoodLog!) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection('consumedFoodLog')
          .doc();

      batch.set(docRef, consumedFood.toMap());
    }

    await batch.commit();
  }
}
