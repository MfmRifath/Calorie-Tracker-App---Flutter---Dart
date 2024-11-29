class Water {
  double targetWaterConsumption;  // The target water consumption for the user
  double currentWaterConsumption;  // The current water consumption for the user

  Water({this.currentWaterConsumption = 0.0, // Default value
  this.targetWaterConsumption = 2000.0, // Default value
   });

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
      targetWaterConsumption: map['targetWaterConsumption']?? 0.0,
      currentWaterConsumption: map['currentWaterConsumption' ] ?? 2000.0,
    );
  }
}

