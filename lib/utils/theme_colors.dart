import 'package:flutter/material.dart';

final customTheme = ThemeData(
  primaryColor: const Color(0xFFE9516E),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Color(0xFFE9516E),
    ),
  ),
  colorScheme: const ColorScheme(
    primary: Color(0xFFE9516E),
    background: Color(0xFF444A5C),
    surface: Color(0xFF444A5C),
    onPrimary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
    onSecondary: Colors.white,
    onError: Colors.white,
    brightness: Brightness.light,
    error: Colors.red,
    secondary: Colors.blue,
  ),
);
