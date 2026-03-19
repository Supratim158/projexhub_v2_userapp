import 'package:flutter/material.dart';

class AppTheme {

  static const Color primary = Color(0xff6C63FF);
  static const Color secondary = Color(0xff9C27B0);
  static const Color dark = Color(0xff0F0F1B);

  static LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0xff0F0F1B),
      Color(0xff1A1A2E),
      Color(0xff2A1F5D)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

}