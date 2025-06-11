import 'package:flutter/material.dart';
import 'package:hems_app/models/device.dart';
import 'package:hems_app/screens/setup/add_device_screen.dart';
import 'package:hems_app/services/firestore_service.dart';
import 'package:hems_app/widgets/device_card.dart';
import 'package:provider/provider.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    const systemId = 'your-system-id'; // Replace with actual system ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDeviceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Device>>(
        stream: firestoreService.getDevices(systemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No devices found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final device = snapshot.data![index];
              return DeviceCard(device: device);
            },
          );
        },
      ),
    );
  }
}
