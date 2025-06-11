import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'HEMS';
  static const String firebaseProjectId = 'hems-app-fba72';
  static const String defaultSystemName = 'Home Energy System';

  // Colors
  static const Color primaryColor = Color(0xFF4e73df);
  static const Color successColor = Color(0xFF1cc88a);
  static const Color dangerColor = Color(0xFFe74a3b);
  static const Color warningColor = Color(0xFFf6c23e);

  // Text Styles
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardValueStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cardUnitStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}
