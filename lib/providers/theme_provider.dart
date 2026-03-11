import 'package:flutter/material.dart';
import 'package:lolify/themes/light_theme.dart';
import 'package:lolify/themes/dark_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = lightMode;

  set setTheme(ThemeData themeData) {
    _currentTheme = themeData;
    _saveThemeToPrefs(themeData);
    notifyListeners();
  }

  ThemeData get getTheme => _currentTheme;

  // сменить тему
  void toggleTheme() {
    if (_currentTheme == lightMode) {
      setTheme = darkMode;
    } else {
      setTheme = lightMode;
    }
  }

  // сохранить тему
  Future<void> _saveThemeToPrefs(ThemeData themeData) async {
    final prefs = await SharedPreferences.getInstance();
    int themeIndex = themeData == lightMode ? 0 : 1;
    await prefs.setInt('themeIndex', themeIndex);
  }

  // загрузить тему
  Future<void> loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeIndex') ?? 0;

    if (themeIndex == 0) {
      _currentTheme = lightMode;
    } else {
      _currentTheme = darkMode;
    }
    notifyListeners();
  }
}
