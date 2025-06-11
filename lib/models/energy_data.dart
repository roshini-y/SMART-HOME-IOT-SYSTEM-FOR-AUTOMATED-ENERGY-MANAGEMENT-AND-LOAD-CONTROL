import 'package:cloud_firestore/cloud_firestore.dart';

class EnergyData {
  final String id;
  final String? deviceId;
  final String? deviceName;
  final double voltage;
  final double current;
  final double power;
  final double energy;
  final DateTime timestamp;
  final String systemId;

  EnergyData({
    required this.id,
    this.deviceId,
    this.deviceName,
    required this.voltage,
    required this.current,
    required this.power,
    required this.energy,
    required this.timestamp,
    required this.systemId,
  });

  factory EnergyData.fromMap(Map<String, dynamic> map) {
    return EnergyData(
      id: map['id'] ?? '',
      deviceId: map['device_id'],
      deviceName: map['device_name'],
      voltage: (map['voltage'] ?? 0).toDouble(),
      current: (map['current'] ?? 0).toDouble(),
      power: (map['power'] ?? 0).toDouble(),
      energy: (map['energy'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      systemId: map['system_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      'voltage': voltage,
      'current': current,
      'power': power,
      'energy': energy,
      'timestamp': timestamp,
      'system_id': systemId,
    };
  }
}
