import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColorSchemeSharedPrefs {
  static const String _appColorSchemeKey = 'app_color_scheme';

  Future<void> setAppColorScheme(AppColorScheme appColorScheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_appColorSchemeKey, appColorScheme.index);
  }

  Future<AppColorScheme?> getAppColorScheme() async {
    final prefs = await SharedPreferences.getInstance();

    final appColorSchemeIndex = prefs.getInt(_appColorSchemeKey);

    if (appColorSchemeIndex == null) {
      return null;
    }

    return AppColorScheme.values[appColorSchemeIndex];
  }

  Future<void> setUseMaterial3(bool useMaterial3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_material_3', useMaterial3);
  }

  Future<bool?> getUseMaterial3() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('use_material_3');
  }
}
