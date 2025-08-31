import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.light,
        );
      }
    } catch (e) {
      // If there's an error loading the theme, default to light mode
      state = ThemeMode.light;
    }
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    state = themeMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeMode.toString());
    } catch (e) {
      // Handle error silently or log it
      print('Error saving theme: $e');
    }
  }

  void toggleTheme() {
    final newTheme =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setTheme(newTheme);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

