import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modals/Water.dart';

class WaterProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId; // Make it mutable for dynamic updates
  late Water _waterLog;

  Water get waterLog => _waterLog;

  WaterProvider({
    required this.userId,
    required double targetWaterConsumption,
  }) {
    _waterLog = Water(
      targetWaterConsumption: targetWaterConsumption,
      currentWaterConsumption: 0,
    );
    fetchWaterLog();
  }

  /// Fetch water log from Firestore
  Future<void> fetchWaterLog() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['waterLog'] != null) {
          _waterLog = Water.fromMap(data['waterLog']);
        }
      }
    } catch (e) {
      print("Error fetching water log: $e");
    } finally {
      notifyListeners();
    }
  }

  /// Update `userId` and `targetWaterConsumption` dynamically
  void update({required String userId, required double targetWaterConsumption}) {
    if (this.userId != userId || _waterLog.targetWaterConsumption != targetWaterConsumption) {
      this.userId = userId;
      _waterLog.targetWaterConsumption = targetWaterConsumption;
      fetchWaterLog();
    }
  }

  /// Set new target water consumption
  void setTargetWaterConsumption(double targetWater) {
    _waterLog.targetWaterConsumption = targetWater;
    notifyListeners();

    _firestore.collection('users').doc(userId).update({
      'waterLog.targetWaterConsumption': targetWater,
    });
  }

  /// Log water intake and update Firestore
  Future<void> logWater(double amount) async {
    _waterLog.logWaterIntake(amount);
    notifyListeners();

    try {
      await _firestore.collection('users').doc(userId).update({
        'waterLog.currentWaterConsumption': _waterLog.currentWaterConsumption,
      });
    } catch (e) {
      print("Error logging water intake: $e");
    }
  }

  /// Get remaining water intake
  double getRemainingWaterIntake() {
    return _waterLog.targetWaterConsumption - _waterLog.currentWaterConsumption;
  }

  /// Reset daily water log
  Future<void> resetDailyWaterLog() async {
    _waterLog.currentWaterConsumption = 0;
    try {
      await _firestore.collection('users').doc(userId).update({
        'waterLog.currentWaterConsumption': 0,
      });
      notifyListeners();
    } catch (e) {
      print("Error resetting water log: $e");
    }
  }
  void resetWaterLog() {
    _waterLog.currentWaterConsumption = 0.0;
    notifyListeners();
  }

}
