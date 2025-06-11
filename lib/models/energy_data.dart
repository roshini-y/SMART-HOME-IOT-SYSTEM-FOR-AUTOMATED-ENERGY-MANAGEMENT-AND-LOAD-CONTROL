class EnergyData {
  final double voltage;
  final double current;
  final double power;
  final double energy;

  EnergyData({
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      voltage: (json['voltage'] ?? 0).toDouble(),
      current: (json['current'] ?? 0).toDouble(),
      power: (json['power'] ?? 0).toDouble(),
      energy: (json['energy'] ?? 0).toDouble(),
    );
  }
}

class PowerBudget {
  final double used;
  final double budget;
  final double percentage;
  final bool exceeded;
  final double maxBill;
  final double rate;

  PowerBudget({
    required this.used,
    required this.budget,
    required this.percentage,
    required this.exceeded,
    required this.maxBill,
    required this.rate,
  });

  factory PowerBudget.fromJson(Map<String, dynamic> json) {
    return PowerBudget(
      used: (json['used'] ?? 0).toDouble(),
      budget: (json['budget'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
      exceeded: json['exceeded'] ?? false,
      maxBill: (json['max_bill'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }
}