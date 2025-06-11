class Device {
  final String id;
  final String name;
  final String status;
  final double watt;
  final int priority;

  Device({
    required this.id,
    required this.name,
    required this.status,
    required this.watt,
    required this.priority,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      name: json['device_name'] ?? '',
      status: json['device_status'] ?? 'OFF',
      watt: (json['device_watt'] ?? 0).toDouble(),
      priority: json['priority'] ?? 2,
    );
  }
}