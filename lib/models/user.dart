import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String phoneNumber;
  final String? systemId;
  final DateTime registeredAt;

  User({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    this.systemId,
    required this.registeredAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      systemId: map['system_id'],
      registeredAt: (map['registered_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phone_number': phoneNumber,
      'system_id': systemId,
      'registered_at': registeredAt,
    };
  }
}
