// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAh6_ot0Ls-2hyULOJWHYlPuve8WtLk4KY',
    appId: '1:591590592947:web:1362d4ce76fb15c6c8fbc6',
    messagingSenderId: '591590592947',
    projectId: 'hems-app-fba72',
    authDomain: 'hems-app-fba72.firebaseapp.com',
    storageBucket: 'hems-app-fba72.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwPD1hOXwttO3fYQ63qk6l04hFr5Ap6-k',
    appId: '1:591590592947:android:b692d75b9eae6f24c8fbc6',
    messagingSenderId: '591590592947',
    projectId: 'hems-app-fba72',
    storageBucket: 'hems-app-fba72.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJlICTCGwyE5dQp3Yv5N8yyxWRa_Iuvos',
    appId: '1:591590592947:ios:1f09e8dfaa6182d6c8fbc6',
    messagingSenderId: '591590592947',
    projectId: 'hems-app-fba72',
    storageBucket: 'hems-app-fba72.firebasestorage.app',
    iosBundleId: 'com.example.smartHome',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJlICTCGwyE5dQp3Yv5N8yyxWRa_Iuvos',
    appId: '1:591590592947:ios:1f09e8dfaa6182d6c8fbc6',
    messagingSenderId: '591590592947',
    projectId: 'hems-app-fba72',
    storageBucket: 'hems-app-fba72.firebasestorage.app',
    iosBundleId: 'com.example.smartHome',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAh6_ot0Ls-2hyULOJWHYlPuve8WtLk4KY',
    appId: '1:591590592947:web:8800ebe800b11b2ec8fbc6',
    messagingSenderId: '591590592947',
    projectId: 'hems-app-fba72',
    authDomain: 'hems-app-fba72.firebaseapp.com',
    storageBucket: 'hems-app-fba72.firebasestorage.app',
  );
}
