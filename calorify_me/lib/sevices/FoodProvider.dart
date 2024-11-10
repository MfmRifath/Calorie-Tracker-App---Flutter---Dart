import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modals/Food.dart';
import '../modals/CustomFood.dart';

class FoodProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId;

  List<Food> _foodLog = [];
  List<ConsumedFood> _dailyFoodLog = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Food> get foodLog => _foodLog;
  List<ConsumedFood> get dailyFoodLog => _dailyFoodLog;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FoodProvider({required this.userId}) {
    fetchFoodLog();
    fetchDailyFoodLog();
  }

  void updateUserId(String newUserId) {
    if (userId != newUserId) {
      userId = newUserId;
      fetchFoodLog();
      fetchDailyFoodLog();
    }
  }

  Future<void> fetchDailyFoodLog() async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyFoodLog')
          .orderBy('timestamp', descending: true)
          .get();

      _dailyFoodLog = snapshot.docs
          .map((doc) => ConsumedFood.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _setError(null);
    } catch (e) {
      _setError("Failed to fetch daily food log.");
      print("Error fetching daily food log: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logConsumedFood(ConsumedFood food) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyFoodLog')
          .doc();

      await docRef.set(food.toMap());
      _dailyFoodLog.insert(0, food); // Insert at the top
      notifyListeners();
    } catch (e) {
      _setError("Failed to log consumed food.");
      print("Error logging consumed food: $e");
    }
  }

  Future<void> clearOldEntries() async {
    final now = DateTime.now();
    final batch = _firestore.batch();

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyFoodLog')
          .get();

      for (var doc in snapshot.docs) {
        final consumedFood = ConsumedFood.fromMap(doc.data());
        if (now.difference(consumedFood.timestamp).inHours >= 24) {
          batch.delete(doc.reference);
        }
      }

      await batch.commit();
      await fetchDailyFoodLog();
    } catch (e) {
      _setError("Failed to clear old entries.");
      print("Error clearing old entries: $e");
    }
  }

  int getTotalCalories() {
    return _dailyFoodLog.fold(0, (sum, item) => sum + item.calories);
  }

  int getMealCalories(String mealType) {
    return _dailyFoodLog
        .where((food) => food.mealType == mealType)
        .fold(0, (sum, food) => sum + food.calories);
  }

  Future<void> fetchFoodLog() async {
    _setLoading(true);
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .get();

      _foodLog = snapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      _setError(null);
    } catch (e) {
      _setError("Failed to load food log.");
      print("Error fetching food log: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logFood(Food food) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .doc();

      await docRef.set(food.toMap());
      _foodLog.add(food);
      notifyListeners();
    } catch (e) {
      _setError("Failed to log food.");
      print("Error logging food: $e");
    }
  }

  Future<void> deleteFood(Food food) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .where('foodName', isEqualTo: food.foodName)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      _foodLog.removeWhere((item) => item.foodName == food.foodName);
      notifyListeners();
    } catch (e) {
      _setError("Failed to delete food.");
      print("Error deleting food: $e");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
