import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static late Box userPrefs;

  static Future<void> init() async {
    await Hive.initFlutter();
    userPrefs = await Hive.openBox('user_prefs');
  }

  static bool get isDarkMode => userPrefs.get('isDarkMode', defaultValue: false);

  static Future<void> setThemeMode(bool isDarkMode) async {
    await userPrefs.put('isDarkMode', isDarkMode);
  }

  static ValueListenable<Box> get isDarkModeListen => userPrefs.listenable();
}
