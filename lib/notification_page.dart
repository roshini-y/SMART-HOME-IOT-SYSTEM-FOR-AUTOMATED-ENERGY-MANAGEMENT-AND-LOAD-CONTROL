import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Firestore collection reference for Notifications
  final CollectionReference _notificationsRef = FirebaseFirestore.instance
      .collection('Notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _notificationsRef
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications available.'));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final message = notification['message'] ?? 'No message';
              final timestamp =
                  notification['timestamp']?.toDate() ?? DateTime.now();
              final status = notification['status'] ?? 'unseen';
              final type = notification['type'] ?? 'General';

              // Mark the notification as "seen" when clicked
              _markAsSeen(notification.id);

              return ListTile(
                title: Text(message),
                subtitle: Text('Type: $type\nTime: ${timestamp.toLocal()}'),
                trailing: Icon(
                  Icons.check_circle,
                  color: status == 'unseen' ? Colors.grey : Colors.green,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Mark notification as "seen" in Firestore
  Future<void> _markAsSeen(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({'status': 'seen'});
  }
}
