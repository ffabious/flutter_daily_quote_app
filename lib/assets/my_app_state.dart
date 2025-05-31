import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppState extends ChangeNotifier {
  ThemeMode? themeMode;
  FontStyle? fontStyle;
  String? dailyQuote;
  String? lastFetchDate;
  bool isLiked = false;
  List<String> likedQuotes = [];

  MyAppState() {
    _loadInitState();
  }

  Future<void> _loadInitState() async {
    final prefs = await SharedPreferences.getInstance();

    final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    final isItalic = prefs.getBool('is_italic') ?? false;
    fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;

    dailyQuote = prefs.getString('daily_quote');
    lastFetchDate = prefs.getString('last_fetch_date');

    isLiked = prefs.getBool('is_liked') ?? false;
    likedQuotes = prefs.getStringList('liked_quotes') ?? [];

    notifyListeners();
  }

  void toggleDarkMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = SharedPreferences.getInstance();
    prefs.then((preferences) {
      preferences.setBool('is_dark_mode', isDark);
    });
    notifyListeners();
  }

  void toggleItalicStyle(bool isItalic) {
    fontStyle = isItalic ? FontStyle.italic : FontStyle.normal;
    final prefs = SharedPreferences.getInstance();
    prefs.then((preferences) {
      preferences.setBool('is_italic', isItalic);
    });
    notifyListeners();
  }

  void toggleLike() {
    isLiked = !isLiked;
    notifyListeners();
  }

  void likeQuote(String? quote) {
    if (quote != null && !likedQuotes.contains(quote)) {
      likedQuotes.add(quote);
      final prefs = SharedPreferences.getInstance();
      prefs.then((preferences) {
        preferences.setStringList('liked_quotes', likedQuotes);
      });
      isLiked = true;
    }
    notifyListeners();
  }

  void unlikeQuote(String? quote) {
    if (quote != null && likedQuotes.contains(quote)) {
      likedQuotes.remove(quote);
      final prefs = SharedPreferences.getInstance();
      prefs.then((preferences) {
        preferences.setStringList('liked_quotes', likedQuotes);
      });
      isLiked = false;
    }
    notifyListeners();
  }
}
