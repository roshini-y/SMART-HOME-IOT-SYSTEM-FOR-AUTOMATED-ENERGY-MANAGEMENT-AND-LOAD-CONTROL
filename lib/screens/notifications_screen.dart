import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hems_app/services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    const systemId = 'your-system-id'; // Replace with actual system ID

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotifications(systemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Icon(
                    notification['type'] == 'LimitExceeded'
                        ? Icons.warning
                        : Icons.power_off,
                    color: Colors.red,
                  ),
                  title: Text(notification['message']),
                  subtitle: Text(
                    DateFormat('MMM dd, HH:mm').format(
                      (notification['timestamp'] as Timestamp).toDate(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
