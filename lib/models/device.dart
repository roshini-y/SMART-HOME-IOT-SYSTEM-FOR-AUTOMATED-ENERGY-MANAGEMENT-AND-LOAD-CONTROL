class Device {
  final String id;
  final String name;
  final double power;
  final int priority;
  final String status;
  final String systemId;
  final DateTime? lastUpdated;
  final bool autoOff;

  Device({
    required this.id,
    required this.name,
    required this.power,
    required this.priority,
    required this.status,
    required this.systemId,
    this.lastUpdated,
    this.autoOff = false,
  });

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] ?? '',
      name: map['device_name'] ?? 'Unknown',
      power: (map['device_watt'] ?? 0).toDouble(),
      priority: map['priority'] ?? 2,
      status: map['device_status'] ?? 'OFF',
      systemId: map['system_id'] ?? '',
      lastUpdated: map['last_updated']?.toDate(),
      autoOff: map['auto_off'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'device_name': name,
      'device_watt': power,
      'priority': priority,
      'device_status': status,
      'system_id': systemId,
      'auto_off': autoOff,
      'last_updated': lastUpdated,
    };
  }
}
