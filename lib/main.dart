import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'device_control_page.dart'; // Import the new device control page
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Energy',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const DashboardScreen(), // Your existing Dashboard screen
      routes: {
        // Define the route for the Device Control screen
        '/deviceControl': (context) => DeviceControlPage(),
      },
    );
  }
}
