// lib/device_control_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceControlPage extends StatefulWidget {
  @override
  _DeviceControlPageState createState() => _DeviceControlPageState();
}

class _DeviceControlPageState extends State<DeviceControlPage> {
  Future<void> controlDevice(String device, String action) async {
    final url =
        'http://172.24.113.45:5000/control'; // Replace with your Raspberry Pi's IP
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'device': device, 'action': action}),
    );

    if (response.statusCode == 200) {
      print('Device controlled successfully');
    } else {
      print('Failed to control device');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Control')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Device 1'),
            trailing: IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () => controlDevice('device1', 'on'),
            ),
          ),
          ListTile(
            title: Text('Device 2'),
            trailing: IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () => controlDevice('device2', 'on'),
            ),
          ),
          ListTile(
            title: Text('Device 3'),
            trailing: IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () => controlDevice('device3', 'on'),
            ),
          ),
        ],
      ),
    );
  }
}
