import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:bsuir_schedule/application/settings/service/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  // make this a singleton class
  static final SettingsProvider _instance = SettingsProvider.internal();
  factory SettingsProvider() => _instance;
  SettingsProvider.internal();

  static final SettingsService _settingsService = SettingsService();

  AppSettings _appSettings = AppSettings();

  AppColorScheme get appColorScheme => _appSettings.appColorScheme;
  AppIcon get appIcon => _appSettings.appIcon;
  LessonColor get lectureColor => _appSettings.lectureColor;
  LessonColor get practiceColor => _appSettings.practiceColor;
  LessonColor get laboratoryColor => _appSettings.laboratoryColor;
  LessonColor get consultColor => _appSettings.consultColor;
  LessonColor get examColor => _appSettings.examColor;
  LessonColor get announcementColor => _appSettings.announcementColor;
  LessonColor get unknownColor => _appSettings.unknownColor;

  Future<bool> fetchData() async {
    final appSettings = await _settingsService.getSettings();

    if (appSettings == null) {
      await _settingsService.setSettings(_appSettings);
    }

    _appSettings = appSettings ?? AppSettings();
    return true;
  }

  Future<void> setTheme(AppColorScheme colorScheme) async {
    _appSettings.appColorScheme = colorScheme;
    notifyListeners();
    await _settingsService.setAppColorScheme(appColorScheme);
  }

  Future<void> setAppIcon(AppIcon appIcon) async {
    _appSettings.appIcon = appIcon;
    await _settingsService.setAppIcon(appIcon);

    // String appIconName = '/assets/images/app_icon_light.jpg';
    // await FlutterDynamicIcon.setAlternateIconName(appIconName);
  }

  Future<void> resetColorTheme() async {
    _appSettings.appColorScheme = AppSettings.defaultAppColorScheme;
    notifyListeners();
    await _settingsService.setAppColorScheme(appColorScheme);
  }

  Future<void> resetLessonColors() async {
    _appSettings.lectureColor = AppSettings.defaultLectureColor;
    _appSettings.practiceColor = AppSettings.defaultPraciceColor;
    _appSettings.laboratoryColor = AppSettings.defaultLaboratoryColor;
    _appSettings.consultColor = AppSettings.defaultConsultColor;
    _appSettings.examColor = AppSettings.defaultExamColor;
    _appSettings.announcementColor = AppSettings.defaultAnnouncementColor;
    _appSettings.unknownColor = AppSettings.defaultUnknownColor;
    notifyListeners();

    await _settingsService.setLectureColor(lectureColor);
    await _settingsService.setPracticeColor(practiceColor);
    await _settingsService.setLaboratoryColor(laboratoryColor);
    await _settingsService.setConsultColor(consultColor);
    await _settingsService.setExamColor(examColor);
    await _settingsService.setAnnouncementColor(announcementColor);
    await _settingsService.setUnknownColor(unknownColor);
  }

  Future<void> setLectureColor(LessonColor color) async {
    _appSettings.lectureColor = color;
    notifyListeners();
    await _settingsService.setLectureColor(lectureColor);
  }

  Future<void> setPracticeColor(LessonColor color) async {
    _appSettings.practiceColor = color;
    notifyListeners();
    await _settingsService.setPracticeColor(practiceColor);
  }

  Future<void> setLaboratoryColor(LessonColor color) async {
    _appSettings.laboratoryColor = color;
    notifyListeners();
    await _settingsService.setLaboratoryColor(laboratoryColor);
  }

  Future<void> setConsultColor(LessonColor color) async {
    _appSettings.consultColor = color;
    notifyListeners();
    await _settingsService.setConsultColor(consultColor);
  }

  Future<void> setExamColor(LessonColor color) async {
    _appSettings.examColor = color;
    notifyListeners();
    await _settingsService.setExamColor(examColor);
  }

  Future<void> setAnnouncementColor(LessonColor color) async {
    _appSettings.announcementColor = color;
    notifyListeners();
    await _settingsService.setAnnouncementColor(announcementColor);
  }

  Future<void> setUnknownColor(LessonColor color) async {
    _appSettings.unknownColor = color;
    notifyListeners();
    await _settingsService.setUnknownColor(unknownColor);
  }

  Future<void> setDefaultTheme() async {
    _appSettings.appColorScheme = AppSettings.defaultAppColorScheme;
    notifyListeners();
    await _settingsService.setAppColorScheme(appColorScheme);
  }

  Future<void> setDefaultAppIcon() async {
    _appSettings.appIcon = AppSettings.defaultAppIcon;
    notifyListeners();
    await _settingsService.setAppIcon(appIcon);
  }

  Future<void> setDefaultLectureColor() async {
    _appSettings.lectureColor = AppSettings.defaultLectureColor;
    notifyListeners();
    await _settingsService.setLectureColor(lectureColor);
  }

  Future<void> setDefaultPracticeColor() async {
    _appSettings.practiceColor = AppSettings.defaultPraciceColor;
    notifyListeners();
    await _settingsService.setPracticeColor(practiceColor);
  }

  Future<void> setDefaultLaboratoryColor() async {
    _appSettings.laboratoryColor = AppSettings.defaultLaboratoryColor;
    notifyListeners();
    await _settingsService.setLaboratoryColor(laboratoryColor);
  }

  Future<void> setDefaultConsultColor() async {
    _appSettings.consultColor = AppSettings.defaultConsultColor;
    notifyListeners();
    await _settingsService.setConsultColor(consultColor);
  }

  Future<void> setDefaultExamColor() async {
    _appSettings.examColor = AppSettings.defaultExamColor;
    notifyListeners();
    await _settingsService.setExamColor(examColor);
  }

  Future<void> setDefaultAnnouncementColor() async {
    _appSettings.announcementColor = AppSettings.defaultAnnouncementColor;
    notifyListeners();
    await _settingsService.setAnnouncementColor(announcementColor);
  }

  Future<void> setDefaultUnknownColor() async {
    _appSettings.unknownColor = AppSettings.defaultUnknownColor;
    notifyListeners();
    await _settingsService.setUnknownColor(unknownColor);
  }
}
