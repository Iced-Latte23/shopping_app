import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemePreference(isDarkMode.value);
  }

  ThemeData getTheme() {
    return isDarkMode.value
        ? ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[900],
    )
        : ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    print('Loaded theme preference: ${isDarkMode.value ? 'Dark' : 'Light'}');
  }

  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    print('Saved theme preference: $isDark');
  }
}