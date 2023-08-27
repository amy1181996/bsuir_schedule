import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppIconSharedPrefs {
  static const String _appIconKey = 'app_icon';

  Future<void> setAppIcon(AppIcon appIcon) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_appIconKey, appIcon.index);
  }

  Future<AppIcon?> getAppIcon() async {
    final prefs = await SharedPreferences.getInstance();
    final appIconIndex = prefs.getInt(_appIconKey);
    if (appIconIndex == null) {
      return null;
    }
    return AppIcon.values[appIconIndex];
  }
}
