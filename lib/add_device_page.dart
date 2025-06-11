import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/device_detail_page.dart';

class AddDevicePage extends StatelessWidget {
  AddDevicePage({super.key}); // ✅ Removed 'const', used 'super.key'

  final CollectionReference devices = FirebaseFirestore.instance.collection(
    'Devices',
  );

  void _showAddDeviceDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Device'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter device name'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    devices.add({
                      'device_name': controller.text,
                      'device_status': 'OFF',
                      'device_watt': 0,
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Device')),
      body: StreamBuilder<QuerySnapshot>(
        stream: devices.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              return ListTile(
                title: Text(doc['device_name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeviceDetailPage(deviceId: doc.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeviceDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
