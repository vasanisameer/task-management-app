import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sameer_assigment/services/hive_service.dart';

final themeManagerProvider = StateProvider<ThemeMode>((ref) {
  return HiveService.isDarkMode ? ThemeMode.dark : ThemeMode.light;
});

class ThemeManager {
  static ThemeMode get currentTheme => HiveService.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  static void toggleTheme(BuildContext context, WidgetRef ref) {
    final isDarkMode = HiveService.isDarkMode;
    final newTheme = !isDarkMode;

    HiveService.setThemeMode(newTheme);

    ref.read(themeManagerProvider.notifier).state = newTheme ? ThemeMode.dark : ThemeMode.light;
  }
}
