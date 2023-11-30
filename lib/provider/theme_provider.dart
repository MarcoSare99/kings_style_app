import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeMode themeMode;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  ThemeMode getThemeMode(bool theme) {
    if (theme) {
      return themeMode = ThemeMode.dark;
    } else {
      return themeMode = ThemeMode.light;
    }
  }

  init(bool? theme) {
    if (theme != null) {
      themeMode = theme ? ThemeMode.dark : ThemeMode.light;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
