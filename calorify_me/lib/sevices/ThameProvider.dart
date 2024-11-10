import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color _accentColor = Colors.green;

  bool get isDarkMode => _isDarkMode;
  Color get accentColor => _accentColor;

  ThemeData getTheme() {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      primarySwatch: Colors.green,
      hintColor: _accentColor,
      scaffoldBackgroundColor: _isDarkMode ? Colors.black : Colors.white,
    );
  }

  void toggleTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }
}
