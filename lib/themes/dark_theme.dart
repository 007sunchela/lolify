import 'package:flutter/material.dart';

// темная тема
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    onSurface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
);
