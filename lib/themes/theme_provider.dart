import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String themeKey = 'theme';
final themeProvider = ChangeNotifierProvider((ref) => ThemeProviderState());

class ThemeProviderState extends ChangeNotifier {
  bool isDarkMode = true; // По умолчанию темная тема

  ThemeProviderState() {
    getCurrentTheme();
  }

  getCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode =
        prefs.getBool(themeKey) ?? true; // По умолчанию true для темной темы
    notifyListeners();
  }

  changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, value);
    isDarkMode = value;
    notifyListeners();
  }
}
