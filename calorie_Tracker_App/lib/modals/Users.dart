import 'BMI.dart';
import 'Food.dart';
import 'Water.dart';

class User {
  String name;
  int age;
  double weight;
  double height;
  List<Food> foodLog;
  Water waterLog;
  BMI bmi;

  User({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.foodLog,
    required this.waterLog,
  }) : bmi = BMI(weight: weight, height: height);

  double calculateBMI() {
    return bmi.calculateBMI();
  }

  void logFood(Food food) {
    foodLog.add(food);
  }

  double getDailyCaloryIntake() {
    return foodLog.fold(0, (total, food) => total + food.calories);
  }
}
