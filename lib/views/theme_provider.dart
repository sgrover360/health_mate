import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeData defaultTheme = ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple));
  final darkTheme = ThemeData.dark();
  late ThemeData _themeData;

  ThemeProvider() {
    _themeData = defaultTheme;
    _loadThemePreference();
  }

  ThemeData get themeData => _themeData;

  Future<void> toggleTheme() async {
    if (_themeData == defaultTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = defaultTheme;
    }

    notifyListeners();
    _saveThemePreference();
  }

  void _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData == ThemeData.dark());
  }

  void _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

    _themeData = isDarkMode ? darkTheme : defaultTheme;
  }
}