import 'package:cloud_firestore/cloud_firestore.dart';

import 'BMI.dart';
import 'CustomFood.dart';
import 'Food.dart';
import 'Water.dart';

class CustomUser {
  String id;
  String name;
  int age;
  String email;
  double weight;
  double height;
  String role;
  List<Food>? foodLog;
  Water? waterLog;
  late BMI bmi;
  double totalCalories;
  double totalWaterIntake;
  String? profileImageUrl;
  int targetCalories;

  List<ConsumedFood>? consumedFoodLog = [];

  CustomUser({
    required this.id,
    required this.role,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    Water? waterLog,
    required this.email,
    this.profileImageUrl,
    this.totalCalories = 0,
    this.totalWaterIntake = 0,
    this.targetCalories = 2000,
  }) : waterLog = waterLog ?? Water() {
    bmi = BMI(weight: weight, height: height);
  }

  // Calculate BMI and store it in the CustomUser object
  double calculateBMI() => bmi.calculateBMI();

  // Add the calculated BMI to the Firestore document
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

  // Convert CustomUser to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'foodLog': foodLog?.map((food) => food.toMap()).toList() ?? [],
      'waterLog': waterLog?.toMap() ?? {},
      'totalCalories': totalCalories,
      'totalWaterIntake': totalWaterIntake,
      'targetCalories': targetCalories,
      'profileImageUrl': profileImageUrl ?? '',
      'email': email,
      'role': role,
      'bmi': calculateBMI(),  // Store the calculated BMI in Firestore
    };
  }

  // Fetch user data from Firestore and calculate BMI based on retrieved data
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
      waterLog: data['waterLog'] != null ? Water.fromMap(data['waterLog']) : Water(),
      targetCalories: data['targetCalories'] ?? 2000,
      profileImageUrl: data['profileImageUrl'],
      email: data['email'] ?? '',
      role: data['role'] ?? 'USER',
    )
      ..foodLog = foodSnapshot.docs.map((doc) => Food.fromMap(doc.data(), doc.id)).toList()
      ..consumedFoodLog = consumedFoodSnapshot.docs.map((doc) => ConsumedFood.fromMap(doc.data())).toList();
  }

  // Save the consumed food log to Firestore
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