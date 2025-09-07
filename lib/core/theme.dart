import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _brandPrimary = Color(0xFF635BFF);
const Color _brandAccent = Color(0xFF00D4FF);
const Color _bgDark = Color(0xFF0F1221);
const Color _cardBg = Color(0xFF171827);
const Color _success = Color(0xFF22C55E);
const Color _error = Color(0xFFEF4444);

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: _brandPrimary, brightness: Brightness.dark),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: Colors.white),
    scaffoldBackgroundColor: _bgDark,
    cardColor: _cardBg,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF20243A),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: _brandAccent, foregroundColor: Colors.black),
    ),
  );
}

Color get brandPrimary => _brandPrimary;
Color get brandAccent => _brandAccent;
Color get successColor => _success;
Color get errorColor => _error;
