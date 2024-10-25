import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../modals/Food.dart';
import '../modals/Users.dart';
import '../modals/Water.dart';
import 'AuthService.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  final AuthService _authService = AuthService();
  CustomUser? _user;
  List<Food> get foodLog {
    print("Current food log: ${_user?.foodLog}");
    return _user?.foodLog ?? [];
  }

  CustomUser? get user => _user;

  UserProvider();

  /// Initialize user in Firestore if it does not exist
  Future<void> createUserInFirestore() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.id).set({
        'id': _user!.id,
        'name': _user!.name,
        'age': _user!.age,
        'weight': _user!.weight,
        'height': _user!.height,
        'foodLog': _user!.foodLog.map((f) => f.toMap()).toList(),
        'waterLog': _user!.waterLog.toMap(),
      });
    }
  }
  Future<void> loadUserData() async {
    if (userId != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _user = CustomUser.fromMap(userDoc.data() as Map<String, dynamic>);
        await fetchTotalWaterIntake(); // Fetch total water intake
        await fetchTotalCalories(); // Fetch total calorie intake
        notifyListeners(); // Notify UI about the data update
      }
    }
  }


  /// Log food for the user and update Firestore
  Future<void> logFood(Food food) async {
    _user?.logFood(food);
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.id).update({
        'foodLog': _user!.foodLog.map((f) => f.toMap()).toList(),
      });
      notifyListeners();
    }
  }

  /// Log water intake for the user and update Firestore
  /// Log water intake for the user and update Firestore
  Future<void> logWater(double amount) async {
    _user?.waterLog.logWaterIntake(amount);
    if (_user != null) {
      // Update the current water consumption in Firestore
      await _firestore.collection('users').doc(_user!.id).update({
        'waterLog': _user!.waterLog.toMap(),
        'totalWaterIntake': _user!.waterLog.currentWaterConsumption, // Update total water intake
      });
      notifyListeners(); // Notify listeners to update UI
    }
  }


  /// Get the daily calorie intake from the food log
  double getDailyCaloryIntake() {
    return _user?.getDailyCaloryIntake() ?? 0.0;
  }

  /// Login user using email and password
  Future<void> login(String email, String password) async {
    try {
      User? firebaseUser = await _authService.signInWithEmail(email, password);
      if (firebaseUser != null) {
        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          _user = CustomUser.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          // Create new user in Firestore if it doesn't exist
          _user = CustomUser(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? "User",
            age: 18, // default age
            weight: 70.0, // default weight
            height: 1.75, // default height
            foodLog: [],
            waterLog: Water(targetWaterConsumption: 2000, currentWaterConsumption: 0),
          );
          await createUserInFirestore();
        }
        notifyListeners();
      }
    } catch (e) {
      print("Login error: $e");
    }
  }

  /// Logout user and reset local user state
  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  /// Listen to Firebase Auth changes and update user state
  void listenToUserChanges() {
    _authService.userChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          _user = CustomUser.fromMap(userDoc.data() as Map<String, dynamic>);
        }
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }
  Future<void> addUser(CustomUser user) async {
    final docRef = _firestore.collection('users').doc(user.id);
    await docRef.set(user.toMap());

    // Set _user to the new user and notify listeners
    _user = user;
    notifyListeners();
  }
  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }
  // Fetch total water intake from Firestore
  Future<double> fetchTotalWaterIntake() async {
    if (userId != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _user?.waterLog.currentWaterConsumption = userDoc['totalWaterIntake'] ?? 0;
        notifyListeners();
        return _user?.waterLog.currentWaterConsumption ?? 0; // Return the current water intake
      }
    }
    return 0; // Return 0 if no data is found
  }

  // Fetch total calorie intake from Firestore
  Future<void> fetchTotalCalories() async {
    if (userId != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _user?.totalCalories = userDoc['totalCalories'] ?? 0; // Fetch total calories
        notifyListeners(); // Notify listeners about the update
      }
    }
  }

}
