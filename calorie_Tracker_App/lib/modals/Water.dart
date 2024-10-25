class Water {
  double targetWaterConsumption;  // The target water consumption for the user
  double currentWaterConsumption;  // The current water consumption for the user

  Water({required this.targetWaterConsumption, required this.currentWaterConsumption});

  // Method to log water intake
  void logWaterIntake(double amount) {
    currentWaterConsumption += amount; // Update current water consumption
  }

  // Convert the Water object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'targetWaterConsumption': targetWaterConsumption,
      'currentWaterConsumption': currentWaterConsumption,
    };
  }
  static Water fromMap(Map<String, dynamic> map) {
    return Water(
      targetWaterConsumption: map['targetWaterConsumption'],
      currentWaterConsumption: map['currentWaterConsumption'],
    );
  }
}

