import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData defaultTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 2,
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    checkboxTheme: const CheckboxThemeData(
        side: BorderSide(color: Colors.deepPurple, width: 2)),
    hintColor: Colors.grey,
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white12,
      // Set the app bar color
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(iconColor: MaterialStatePropertyAll(Colors.white))),
  );
  late ThemeData _themeData;

  ThemeProvider() {
    _themeData = defaultTheme;
    _loadThemePreference();
  }

  ThemeData get themeData => _themeData;

  void setDarkMode() async {
    _themeData = darkTheme;
    notifyListeners();
    await _saveThemePreference(isDarkMode: true);
  }

  void setLightMode() async {
    _themeData = defaultTheme;
    notifyListeners();
    await _saveThemePreference(isDarkMode: false);
  }

  void toggleTheme() async {
    if (_themeData == defaultTheme) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }

  Future<void> _saveThemePreference({required bool isDarkMode}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    if (isDarkMode) {
      _themeData = darkTheme;
    } else {
      _themeData = defaultTheme;
    }
    notifyListeners();
  }
}
