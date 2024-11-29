import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../modals/Food.dart';
import '../modals/Users.dart';
import '../modals/Water.dart';
import 'AuthService.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  CustomUser? _user;
  List<Food> _foodLog = [];
  String? _userId;

  List<Food> get foodLog => _foodLog;
  CustomUser? get user => _user;
  String? get userId => _userId;

  UserProvider();

  String _role = 'USER'; // Default role
  bool _isLoading = true;

  String get role => _role;
  bool get isLoading => _isLoading;

  Future<void> fetchUserRole() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        _role = userDoc.data()?['role'] ?? 'USER'; // Default to 'USER' if role is not found
      } else {
        _role = 'USER';
      }
    } catch (e) {
      print('Error fetching user role: $e');
      _role = 'USER'; // Fallback to 'USER' in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  void setUserId(String id) {
    _userId = id;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Ensure this runs after the build phase
    });
  }
  Future<void> createUserInFirestore() async {
    if (_user == null) {
      print("Error: User object is null.");
      return;
    }
    try {
      await _firestore.collection('users').doc(_user!.id).set(
        _user!.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      print("Error creating user in Firestore: $e");
    }
  }

  Future<void> loadUserData() async {
    if (_userId == null) {
      print("Error: User ID is null.");
      return;
    }
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        _user = await CustomUser.fromFirestore(userDoc.data() as Map<String, dynamic>, _userId!);
        await fetchFoodLog();
        notifyListeners();
      } else {
        print("No user document found for ID: $_userId");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> fetchFoodLog() async {
    if (_userId == null) {
      print("Error: User ID is null.");
      return;
    }
    try {
      QuerySnapshot foodLogSnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('foodLog')
          .get();

      _foodLog = foodLogSnapshot.docs
          .map((doc) => Food.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching food log: $e");
    }
  }

  Future<void> logFood(Food food) async {
    if (_userId == null) {
      print("Error: User ID is null.");
      return;
    }
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('foodLog')
          .add(food.toMap());
      _foodLog.add(food);
      notifyListeners();
    } catch (e) {
      print("Error logging food: $e");
    }
  }

  Future<void> logWater(double amount) async {
    if (_userId == null || _user == null) {
      print("Error: User ID or User object is null.");
      return;
    }
    try {
      _user?.waterLog.logWaterIntake(amount);
      await _firestore.collection('users').doc(_userId).update({
        'waterLog': _user?.waterLog.toMap(),
      });
      notifyListeners();
    } catch (e) {
      print("Error logging water: $e");
    }
  }

  double getDailyCaloryIntake() {
    return _foodLog.fold(0.0, (sum, food) => sum + food.calories);
  }

  Future<void> addUser(CustomUser user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
      _user = user;
      notifyListeners();
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      User? firebaseUser = await _authService.signInWithEmail(email, password);
      if (firebaseUser != null) {
        setUserId(firebaseUser.uid);
        await loadUserData();
        return true;
      }
    } catch (e) {
      print("Login error: $e");
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _user = null;
      _foodLog = [];
      _userId = null;
      notifyListeners();
    } catch (e) {
      print("Logout error: $e");
    }
  }

  void listenToUserChanges() {
    _authService.userChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        setUserId(firebaseUser.uid);
        await loadUserData();
      } else {
        _user = null;
        _foodLog = [];
        _userId = null;
        notifyListeners();
      }
    });
  }

  Future<double> fetchTotalWaterIntake() async {
    if (_userId == null || _userId!.isEmpty) {
      print("Error: User ID is null or empty.");
      return 0.0;
    }
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        return userDoc['waterLog']['currentWaterConsumption'] ?? 0.0;
      }
    } catch (e) {
      print("Error fetching water intake: $e");
    }
    return 0.0;
  }

  void setTargetCalories(int targetCalories) {
    if (_user != null && _userId != null) {
      _user!.targetCalories = targetCalories;
      _firestore.collection('users').doc(_userId).update({
        'targetCalories': targetCalories,
      });
      notifyListeners();
    } else {
      print("Error setting target calories: User or User ID is null.");
    }
  }
  Future<void> deleteFood(String foodId) async {
    if (_userId == null) {
      print("Error: User ID is null.");
      return;
    }
    try {
      // Remove from Firestore
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('foodLog')
          .doc(foodId)
          .delete();

      // Remove from local food log
      _foodLog.removeWhere((food) => food.id == foodId);

      notifyListeners();
    } catch (e) {
      print("Error deleting food log: $e");
    }
  }

  Future<void> deleteAllFoodLogs() async {
    if (_userId == null) {
      print("Error: User ID is null.");
      return;
    }
    try {
      // Remove all food logs from Firestore
      final foodLogCollection = _firestore
          .collection('users')
          .doc(_userId)
          .collection('foodLog');

      final foodLogDocs = await foodLogCollection.get();

      for (final doc in foodLogDocs.docs) {
        await doc.reference.delete();
      }

      // Clear local food log
      _foodLog.clear();

      notifyListeners();
    } catch (e) {
      print("Error deleting all food logs: $e");
    }
  }
}
