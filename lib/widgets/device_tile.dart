import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/energy_data.dart';

class DeviceTile extends StatefulWidget {
  final Device device;
  final VoidCallback onRefresh;

  const DeviceTile({required this.device, required this.onRefresh, super.key});

  @override
  State<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
  bool isMeasuring = false;

  Future<void> toggleDevice() async {
    final newStatus = widget.device.status == 'ON' ? 'OFF' : 'ON';
    await FirebaseFirestore.instance
        .collection('Devices')
        .doc(widget.device.id)
        .update({
          'device_status': newStatus,
          'last_updated': FieldValue.serverTimestamp(),
        });
    widget.onRefresh();
  }

  Future<void> measurePower() async {
    setState(() => isMeasuring = true);

    // Simulate measurement values (replace with real API if needed)
    await Future.delayed(const Duration(seconds: 2));
    final measuredPower =
        (50 + (widget.device.name.hashCode % 50)).toDouble(); // mock

    final voltage = 230.0;
    final current = measuredPower / voltage;
    final energy = (measuredPower / 1000.0) * (5 / 60); // 5 minutes assumption

    await FirebaseFirestore.instance
        .collection('Devices')
        .doc(widget.device.id)
        .update({
          'device_watt': measuredPower,
          'last_updated': FieldValue.serverTimestamp(),
        });

    await FirebaseFirestore.instance.collection('EnergyLogs').add({
      'device_id': widget.device.id,
      'device_name': widget.device.name,
      'power': measuredPower,
      'voltage': voltage,
      'current': current,
      'energy': energy,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => isMeasuring = false);
    widget.onRefresh();
  }

  Future<void> updatePriority(int newPriority) async {
    await FirebaseFirestore.instance
        .collection('Devices')
        .doc(widget.device.id)
        .update({
          'priority': newPriority,
          'last_updated': FieldValue.serverTimestamp(),
        });
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.device.status == 'ON' ? Colors.green : Colors.grey;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.devices, color: color),
        ),
        title: Text(
          widget.device.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.device.watt} W | Priority ${widget.device.priority} | Status: ${widget.device.status}",
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Set Priority:"),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: widget.device.priority,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("1")),
                    DropdownMenuItem(value: 2, child: Text("2")),
                    DropdownMenuItem(value: 3, child: Text("3")),
                  ],
                  onChanged: (val) {
                    if (val != null) updatePriority(val);
                  },
                ),
              ],
            ),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon:
                  isMeasuring
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Icon(Icons.flash_on),
              tooltip: "Measure",
              onPressed: isMeasuring ? null : measurePower,
            ),
            IconButton(
              icon: Icon(
                widget.device.status == 'ON'
                    ? Icons.power_settings_new
                    : Icons.power,
              ),
              tooltip: widget.device.status == 'ON' ? "Turn Off" : "Turn On",
              onPressed: toggleDevice,
            ),
          ],
        ),
      ),
    );
  }
}
