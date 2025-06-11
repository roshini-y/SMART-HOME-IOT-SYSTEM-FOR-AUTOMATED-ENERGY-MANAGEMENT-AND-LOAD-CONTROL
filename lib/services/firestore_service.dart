import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hems_app/models/device.dart';
import 'package:hems_app/models/energy_data.dart';
import 'package:hems_app/models/user.dart' as app_user;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUserSystem(
      String userId, String systemName, String? ip) async {
    await _db.collection('Users').doc(userId).update({
      'system_name': systemName,
      'ip_address': ip,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getNotifications(String systemId) {
    return _db
        .collection('Notifications')
        .where('system_id', isEqualTo: systemId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // User Management
  Future<void> createUser(app_user.User user) async {
    await _db.collection('Users').doc(user.uid).set(user.toMap());
  }

  Future<app_user.User?> getUser(String uid) async {
    final doc = await _db.collection('Users').doc(uid).get();
    return doc.exists ? app_user.User.fromMap(doc.data()!) : null;
  }

  // Device Management
  Stream<List<Device>> getDevices(String systemId) {
    return _db
        .collection('Devices')
        .where('system_id', isEqualTo: systemId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Device.fromMap(doc.data())).toList());
  }

  Future<void> addDevice(Device device) async {
    await _db.collection('Devices').add(device.toMap());
  }

  Future<void> updateDeviceStatus(String deviceId, String status) async {
    await _db.collection('Devices').doc(deviceId).update({
      'device_status': status,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDevicePriority(String deviceId, int priority) async {
    await _db.collection('Devices').doc(deviceId).update({
      'priority': priority,
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  // Energy Data
  Stream<List<EnergyData>> getEnergyLogs(String systemId) {
    return _db
        .collection('EnergyLogs')
        .where('system_id', isEqualTo: systemId)
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EnergyData.fromMap(doc.data()))
            .toList());
  }

  // Budget Management
  Future<void> setBudget(String systemId, double maxBill) async {
    await _db.collection('SystemSettings').doc('power_budget').set({
      'max_bill': maxBill,
      'system_id': systemId,
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<Map<String, dynamic>> getBudget(String systemId) {
    return _db
        .collection('SystemSettings')
        .doc('power_budget')
        .snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }
}
