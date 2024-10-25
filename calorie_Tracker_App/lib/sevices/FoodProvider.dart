import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/Food.dart';


class FoodProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId; // Unique identifier for the user
  List<Food> _foodLog = [];
  bool _isLoading = false; // Loading state for fetching data
  String? _errorMessage; // To store any error messages

  List<Food> get foodLog => _foodLog;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FoodProvider({required this.userId}) {
    fetchFoodLog(); // Fetch food log on initialization
  }

  Future<void> fetchFoodLog() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (userId.isEmpty) {
        throw Exception("User ID is empty");
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .get();

      _foodLog = snapshot.docs.map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>)).toList();
      _errorMessage = null;
    } catch (e) {
      print("Error fetching food log: $e");
      _errorMessage = "Failed to load food log. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> logFood(Food food) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .add(food.toMap());

      _foodLog.add(food);
      await _updateTotalCalories(); // Update total calories in Firestore
      notifyListeners();
    } catch (e) {
      print("Error logging food: $e");
      _errorMessage = "Failed to log food. Please try again.";
      notifyListeners();
    }
  }

  Future<void> _updateTotalCalories() async {
    final totalCalories = getTotalCalories();
    await _firestore.collection('users').doc(userId).set({
      'totalCalories': totalCalories,
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  }

  double getTotalCalories() {
    return _foodLog.fold(0, (total, food) => total + food.calories);
  }
  /// Deletes a food item from the food log in Firestore.
  Future<void> deleteFood(Food food) async {
    try {
      // Find the document in Firestore based on the food's properties
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .where('foodName', isEqualTo: food.foodName)
          .where('calories', isEqualTo: food.calories)
          .get();

      // Delete each matching document
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      // Remove the food from the local list
      _foodLog.remove(food);
      notifyListeners();
    } catch (e) {
      print("Error deleting food: $e");
    }
  }



}
