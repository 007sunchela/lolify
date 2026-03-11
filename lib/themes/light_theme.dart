import 'package:flutter/material.dart';

// светлая тема 
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade100,
    onSurface: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
);
