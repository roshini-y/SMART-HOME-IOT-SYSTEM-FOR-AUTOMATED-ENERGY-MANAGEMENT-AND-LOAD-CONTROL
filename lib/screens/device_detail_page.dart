import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceDetailPage extends StatefulWidget {
  final String deviceId;
  const DeviceDetailPage({super.key, required this.deviceId});

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _wattController;

  bool _status = false;
  String _deviceName = '';
  int _watts = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _wattController = TextEditingController();
    _fetchDeviceData();
  }

  @override
  void dispose() {
    _wattController.dispose();
    super.dispose();
  }

  void _fetchDeviceData() async {
    final doc =
        await _firestore.collection('Devices').doc(widget.deviceId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _deviceName = data['device_name'] ?? 'Unnamed Device';
        _status = data['device_status'] == 'ON';
        _watts = int.tryParse(data['device_watt'].toString()) ?? 0;
        _wattController.text = _watts.toString();
        _isLoading = false;
      });
    } else {
      setState(() {
        _deviceName = 'Device not found';
        _isLoading = false;
      });
    }
  }

  void _updateDevice() async {
    final updatedWatts = int.tryParse(_wattController.text) ?? 0;
    final statusString = _status ? 'ON' : 'OFF';

    await _firestore.collection('Devices').doc(widget.deviceId).update({
      'device_status': statusString,
      'device_watt': updatedWatts,
    });

    await _firestore.collection('Notifications').add({
      'title': 'Device Status Changed',
      'body': '$_deviceName turned $statusString',
      'time': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Device updated successfully")));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_deviceName)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Device Status (${_status ? 'ON' : 'OFF'})'),
              value: _status,
              onChanged: (val) => setState(() => _status = val),
            ),
            TextField(
              controller: _wattController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Power (Watts)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _updateDevice, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
