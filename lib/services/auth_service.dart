import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hems_app/models/user.dart' as app_user;

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Stream<User?> get user => _auth.authStateChanges();

  Future<String?> signInWithPhone(String phoneNumber) async {
    try {
      final completer = Completer<String?>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          completer.complete(null);
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          completer.complete(null);
        },
      );

      return await completer.future;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  app_user.User? getCurrentUser() {
    if (_user != null) {
      return app_user.User(
        uid: _user!.uid,
        phoneNumber: _user!.phoneNumber ?? '',
        username: '', // Will be set during registration
        registeredAt: DateTime.now(), // Will be updated from Firestore
      );
    }
    return null;
  }
}
