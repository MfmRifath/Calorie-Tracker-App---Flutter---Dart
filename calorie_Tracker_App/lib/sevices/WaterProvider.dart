import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modals/Water.dart';


class WaterProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId; // Unique identifier for the user
  late Water _waterLog;
  Water waterLog = Water(targetWaterConsumption: 2000, currentWaterConsumption: 0);
  WaterProvider({required this.userId, required double targetWaterConsumption})
      : _waterLog = Water(
    targetWaterConsumption: targetWaterConsumption,
    currentWaterConsumption: 0,
  );






  Future<void> _updateTotalWaterIntake() async {
    await _firestore.collection('users').doc(userId).set({
      'totalWaterIntake': _waterLog.currentWaterConsumption,
    }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields
  }

  // Log water intake
  void logWater(double amount) {
    waterLog.logWaterIntake(amount); // Use the method from Water class
    notifyListeners(); // Notify listeners to update the UI
  }

  double getRemainingWaterIntake() {
    return waterLog.targetWaterConsumption - waterLog.currentWaterConsumption; // Calculate remaining intake
  }

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

}
