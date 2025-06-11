import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeviceControlPage extends StatelessWidget {
  // Define the device and IP address for the relay control
  final String ipAddress = "172.24.113.45";
  final Map<String, int> relayPins = {
    "Light-5W": 11,
    "Fan-9W": 12,
    "Geyser-12W": 13,
    "AC-90W": 15,
    "Buzzer": 16,
  };

  // Function to send HTTP request to turn off the device
  Future<void> turnOffDevice(String deviceName) async {
    final relayPin = relayPins[deviceName];
    if (relayPin != null) {
      // Create URL to call the Flask server (ensure Flask server is running and handles the POST request)
      final url = Uri.parse('http://$ipAddress/turnoff/$relayPin');

      try {
        // Send HTTP POST request to turn off the device
        final response = await http.post(url);

        if (response.statusCode == 200) {
          // Successfully turned off the device
          print('$deviceName is now off.');
        } else {
          // Handle errors (non-200 response)
          print('Failed to turn off $deviceName.');
        }
      } catch (e) {
        // Handle any errors that occur while sending the request
        print('Error: $e');
      }
    } else {
      print('Device not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...relayPins.keys.map((deviceName) {
              return ElevatedButton(
                onPressed: () {
                  // Turn off the device when the button is pressed
                  turnOffDevice(deviceName);
                },
                child: Text('Turn Off $deviceName'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: DeviceControlPage()));
}
