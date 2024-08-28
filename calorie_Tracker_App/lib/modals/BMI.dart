class BMI {
  double weight;
  double height;

  BMI({required this.weight, required this.height});

  double calculateBMI() {
    return weight / (height * height);
  }

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
