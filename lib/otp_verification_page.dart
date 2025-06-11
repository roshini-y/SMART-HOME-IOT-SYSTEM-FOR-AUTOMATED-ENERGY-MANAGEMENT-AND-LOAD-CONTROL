import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home_screen.dart';

class OTPPage extends StatefulWidget {
  final String verificationId;
  final String username;
  final String phoneNumber;

  const OTPPage({
    super.key,
    required this.verificationId,
    required this.username,
    required this.phoneNumber,
  });

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _otpController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String errorMessage = '';

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      setState(() => errorMessage = 'Please enter a valid 6-digit OTP.');
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final systemId = DateTime.now().millisecondsSinceEpoch.toString();
        final token = await FirebaseMessaging.instance.getToken();

        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'username': widget.username,
          'phone_number': widget.phoneNumber,
          'system_id': systemId,
          'fcmToken': token,
          'created_time': FieldValue.serverTimestamp(),
        });

        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException {
      setState(() {
        errorMessage = 'OTP Verification failed: \${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _verifyOTP, child: Text('Verify')),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
