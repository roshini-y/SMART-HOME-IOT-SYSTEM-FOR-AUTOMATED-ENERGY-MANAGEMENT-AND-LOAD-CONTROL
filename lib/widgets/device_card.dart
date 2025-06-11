import 'package:flutter/material.dart';
import 'package:hems_app/models/device.dart';
import 'package:hems_app/services/firestore_service.dart';
import 'package:provider/provider.dart';

class DeviceCard extends StatelessWidget {
  final Device device;

  const DeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Card(
      child: ListTile(
        leading: Icon(
          _getDeviceIcon(device.name),
          color: device.status == 'ON' ? Colors.green : Colors.red,
        ),
        title: Text(device.name),
        subtitle: Text('${device.power}W | Priority: ${device.priority}'),
        trailing: Switch(
          value: device.status == 'ON',
          onChanged: (value) {
            firestoreService.updateDeviceStatus(
              device.id,
              value ? 'ON' : 'OFF',
            );
          },
        ),
        onTap: () {
          // Show device details or edit dialog
        },
      ),
    );
  }

  IconData _getDeviceIcon(String name) {
    if (name.contains('Light')) return Icons.lightbulb;
    if (name.contains('Fan')) return Icons.air;
    if (name.contains('Geyser')) return Icons.water_damage;
    if (name.contains('AC')) return Icons.ac_unit;
    return Icons.power;
  }
}
