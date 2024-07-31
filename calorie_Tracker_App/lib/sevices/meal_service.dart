// lib/services/meal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/meal_modal.dart';


class MealService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMeal(Meal meal) {
    return _db.collection('meals').add({
      'name': meal.name,
      'calories': meal.calories,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<List<Meal>> getMeals() {
    return _db.collection('meals').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Meal(
          name: doc.data()['name'],
          calories: doc.data()['calories'],
        );
      }).toList();
    });
  }
}
