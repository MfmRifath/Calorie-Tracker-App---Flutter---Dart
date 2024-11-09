class BMI {
  double weight; // Weight in kilograms
  double height; // Height in meters

  BMI({required this.weight, required this.height});

  /// Calculates the BMI based on weight and height.
  double calculateBMI() {
    return weight / (height * height);
  }

  /// Determines the BMI category based on the calculated BMI value.
  String getBMICategory() {
    double bmiValue = calculateBMI();
    if (bmiValue < 18.5) {
      return 'Underweight';
    } else if (bmiValue >= 18.5 && bmiValue < 24.9) {
      return 'Normal weight';
    } else if (bmiValue >= 25 && bmiValue < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }
}
