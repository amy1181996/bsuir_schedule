import 'package:bsuir_schedule/application/settings/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonColorSharedPrefs {
  static const String _lectureColorKey = 'lecture_color';
  static const String _practiceColorKey = 'practice_color';
  static const String _labColorKey = 'lab_color';
  static const String _consultationColorKey = 'consultation_color';
  static const String _examColorKey = 'exam_color';
  static const String _unknownColorKey = 'unknown_color';

  Future<void> setLectureColor(LessonColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lectureColorKey, color.index);
  }

  Future<LessonColor?> getLectureColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_lectureColorKey);
    if (colorIndex == null) {
      return null;
    }
    return LessonColor.values[colorIndex];
  }

  Future<void> setPracticeColor(LessonColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_practiceColorKey, color.index);
  }

  Future<LessonColor?> getPracticeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_practiceColorKey);
    if (colorIndex == null) {
      return null;
    }
    return LessonColor.values[colorIndex];
  }

  Future<void> setLabColor(LessonColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_labColorKey, color.index);
  }

  Future<LessonColor?> getLabColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_labColorKey);
    if (colorIndex == null) {
      return null;
    }
    return LessonColor.values[colorIndex];
  }

  Future<void> setConsultationColor(LessonColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_consultationColorKey, color.index);
  }

  Future<LessonColor?> getConsultationColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_consultationColorKey);
    if (colorIndex == null) {
      return null;
    }
    return LessonColor.values[colorIndex];
  }

  Future<void> setExamColor(LessonColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_examColorKey, color.index);
  }

  Future<LessonColor?> getExamColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_examColorKey);
    if (colorIndex == null) {
      return null;
    }
    return LessonColor.values[colorIndex];
  }

  Future<void> setUnknownColor(LessonColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unknownColorKey, color.index);
  }

  Future<LessonColor?> getUnknownColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_unknownColorKey);
    if (colorIndex == null) {
      return null;
    }
    return LessonColor.values[colorIndex];
  }
}
