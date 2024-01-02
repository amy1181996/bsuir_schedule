import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/shared_prefs/app_color_scheme_shared_prefs.dart';
import 'package:bsuir_schedule/application/settings/shared_prefs/app_icon_shared_prefs.dart';
import 'package:bsuir_schedule/application/settings/shared_prefs/lesson_color_shared_prefs.dart';

class SettingsService {
  static final AppColorSchemeSharedPrefs _appColorSchemeSharedPrefs =
      AppColorSchemeSharedPrefs();
  static final AppIconSharedPrefs _appIconSharedPrefs = AppIconSharedPrefs();
  static final LessonColorSharedPrefs _lessonColorSharedPrefs =
      LessonColorSharedPrefs();

  Future<AppSettings?> getSettings() async {
    final appColorScheme = await _appColorSchemeSharedPrefs.getAppColorScheme();
    final appIcon = await _appIconSharedPrefs.getAppIcon();
    final lectureColor = await _lessonColorSharedPrefs.getLectureColor();
    final practiceColor = await _lessonColorSharedPrefs.getPracticeColor();
    final laboratoryColor = await _lessonColorSharedPrefs.getLabColor();
    final consultColor = await _lessonColorSharedPrefs.getConsultationColor();
    final examColor = await _lessonColorSharedPrefs.getExamColor();
    final unknownColor = await _lessonColorSharedPrefs.getUnknownColor();
    final useMaterial3 = await _appColorSchemeSharedPrefs.getUseMaterial3();

    if (appColorScheme == null ||
        appIcon == null ||
        lectureColor == null ||
        practiceColor == null ||
        laboratoryColor == null ||
        consultColor == null ||
        examColor == null ||
        unknownColor == null ||
        useMaterial3 == null) {
      return null;
    }

    return AppSettings(
      appColorScheme: appColorScheme,
      appIcon: appIcon,
      lectureColor: lectureColor,
      practiceColor: practiceColor,
      laboratoryColor: laboratoryColor,
      consultColor: consultColor,
      examColor: examColor,
      unknownColor: unknownColor,
      useMaterial3: useMaterial3,
    );
  }

  Future<void> setSettings(AppSettings appSettings) async {
    await _appColorSchemeSharedPrefs
        .setAppColorScheme(appSettings.appColorScheme);
    await _appIconSharedPrefs.setAppIcon(appSettings.appIcon);
    await _lessonColorSharedPrefs.setLectureColor(appSettings.lectureColor);
    await _lessonColorSharedPrefs.setPracticeColor(appSettings.practiceColor);
    await _lessonColorSharedPrefs.setLabColor(appSettings.laboratoryColor);
    await _lessonColorSharedPrefs
        .setConsultationColor(appSettings.consultColor);
    await _lessonColorSharedPrefs.setExamColor(appSettings.examColor);
    await _lessonColorSharedPrefs.setUnknownColor(appSettings.unknownColor);
    await _appColorSchemeSharedPrefs.setUseMaterial3(appSettings.useMaterial3);
  }

  Future<void> setAppColorScheme(AppColorScheme appColorScheme) async {
    await _appColorSchemeSharedPrefs.setAppColorScheme(appColorScheme);
  }

  Future<void> setAppIcon(AppIcon appIcon) async {
    await _appIconSharedPrefs.setAppIcon(appIcon);
  }

  Future<void> setLectureColor(LessonColor lectureColor) async {
    await _lessonColorSharedPrefs.setLectureColor(lectureColor);
  }

  Future<void> setPracticeColor(LessonColor practiceColor) async {
    await _lessonColorSharedPrefs.setPracticeColor(practiceColor);
  }

  Future<void> setLaboratoryColor(LessonColor laboratoryColor) async {
    await _lessonColorSharedPrefs.setLabColor(laboratoryColor);
  }

  Future<void> setConsultColor(LessonColor consultColor) async {
    await _lessonColorSharedPrefs.setConsultationColor(consultColor);
  }

  Future<void> setExamColor(LessonColor examColor) async {
    await _lessonColorSharedPrefs.setExamColor(examColor);
  }

  Future<void> setAnnouncementColor(LessonColor announcementColor) async {
    await _lessonColorSharedPrefs.setAnnouncementColor(announcementColor);
  }

  Future<void> setUnknownColor(LessonColor unknownColor) async {
    await _lessonColorSharedPrefs.setUnknownColor(unknownColor);
  }

  Future<void> setUseMaterial3(bool useMaterial3) async {
    await _appColorSchemeSharedPrefs.setUseMaterial3(useMaterial3);
  }
}
