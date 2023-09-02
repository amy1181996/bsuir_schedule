enum AppColorScheme {
  light,
  dark,
  system,
}

enum AppIcon {
  light,
  dark,
  pride,
}

enum LessonColor {
  red,
  amber,
  yellowAccent,
  green,
  blue,
  purple,
  violet,
  grey,
}

class AppSettings {
  AppColorScheme appColorScheme;
  static const AppColorScheme defaultAppColorScheme = AppColorScheme.dark;

  AppIcon appIcon;
  static const AppIcon defaultAppIcon = AppIcon.dark;

  LessonColor lectureColor;
  static const LessonColor defaultLectureColor = LessonColor.green;
  LessonColor practiceColor;
  static const LessonColor defaultPraciceColor = LessonColor.yellowAccent;
  LessonColor laboratoryColor;
  static const LessonColor defaultLaboratoryColor = LessonColor.red;
  LessonColor consultColor;
  static const LessonColor defaultConsultColor = LessonColor.green;
  LessonColor examColor;
  static const LessonColor defaultExamColor = LessonColor.violet;
  LessonColor announcementColor;
  static const LessonColor defaultAnnouncementColor = LessonColor.blue;
  LessonColor unknownColor;
  static const LessonColor defaultUnknownColor = LessonColor.grey;

  AppSettings({
    this.appColorScheme = defaultAppColorScheme,
    this.appIcon = defaultAppIcon,
    this.lectureColor = defaultLectureColor,
    this.practiceColor = defaultPraciceColor,
    this.laboratoryColor = defaultLaboratoryColor,
    this.consultColor = defaultConsultColor,
    this.examColor = defaultExamColor,
    this.announcementColor = defaultAnnouncementColor,
    this.unknownColor = defaultUnknownColor,
  });

  void reset() {
    appColorScheme = defaultAppColorScheme;
    appIcon = defaultAppIcon;
    lectureColor = defaultLectureColor;
    practiceColor = defaultPraciceColor;
    laboratoryColor = defaultLaboratoryColor;
    consultColor = defaultConsultColor;
    examColor = defaultExamColor;
    announcementColor = defaultAnnouncementColor;
    unknownColor = defaultUnknownColor;
  }
}
