class Water {
  double targetWaterConsumption;
  double currentWaterConsumption;

  Water({
    required this.targetWaterConsumption,
    required this.currentWaterConsumption,
  });

  void logWaterIntake(double amount) {
    currentWaterConsumption += amount;
  }

  double getRemainingWaterIntake() {
    return targetWaterConsumption - currentWaterConsumption;
  }
}
