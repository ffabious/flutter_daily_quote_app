import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  ThemeMode? themeMode;
  FontStyle? fontStyle;

  MyAppState() {
    _loadInitState();
  }

  Future<void> _loadInitState() async {
    final prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    final isItalic = prefs.getBool('isItalic') ?? false;
    fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;

    notifyListeners();
  }

  void toggleDarkMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = SharedPreferences.getInstance();
    prefs.then((preferences) {
      preferences.setBool('isDarkMode', isDark);
    });
    notifyListeners();
  }

  void toggleItalicStyle(bool isItalic) {
    fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;
    final prefs = SharedPreferences.getInstance();
    prefs.then((preferences) {
      preferences.setBool('isItalic', isItalic);
    });
    notifyListeners();
  }
}
