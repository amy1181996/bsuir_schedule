import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:intl/intl.dart';

class ApiLesson {
  final List<String> auditories;
  final String startLessonTime;
  final String endLessonTime;
  final String lessonTypeAbbrev;
  final String? note;
  final int numSubgroup;
  final List<Map<String, dynamic>> mappedGroups;
  final List<Map<String, dynamic>>? mappedLecturers;
  final String subject;
  final String subjectFullName;
  final List<int> weekNumber;
  final String? dateLesson;
  final String startLessonDate;
  final String endLessonDate;
  final bool isAnnouncement;

  ApiLesson({
    required this.auditories,
    required this.startLessonTime,
    required this.endLessonTime,
    required this.lessonTypeAbbrev,
    required this.note,
    required this.numSubgroup,
    required this.mappedGroups,
    required this.mappedLecturers,
    required this.subject,
    required this.subjectFullName,
    required this.weekNumber,
    required this.dateLesson,
    required this.startLessonDate,
    required this.endLessonDate,
    required this.isAnnouncement,
  });

  factory ApiLesson.fromJson(Map<String, dynamic> json) => ApiLesson(
        auditories: List<String>.from(json['auditories'] ?? []),
        startLessonTime: json['startLessonTime'],
        endLessonTime: json['endLessonTime'],
        lessonTypeAbbrev: json['lessonTypeAbbrev'] ??
            (json['announcement'] ? 'ОБ' : 'unknown'),
        note: json['note'],
        numSubgroup: json['numSubgroup'],
        mappedGroups: List<Map<String, dynamic>>.from(
            json['studentGroups']), //json['studentGroups'],
        mappedLecturers: json['employees'] != null
            ? List<Map<String, dynamic>>.from(json['employees'])
            : null,
        subject: json['subject'] ?? 'unknown',
        subjectFullName: json['subjectFullName'] ?? 'unknown',
        weekNumber: List<int>.from(json['weekNumber'] ?? []),
        dateLesson: json['dateLesson'],
        startLessonDate: json['startLessonDate'],
        endLessonDate: json['endLessonDate'],
        isAnnouncement: json['announcement'],
      );

  Lesson toLesson({
    required String? weekDay,
    required List<Group> studentGroups,
    required List<Lecturer> lecturers,
  }) =>
      Lesson(
        id: 0,
        auditories: auditories,
        startLessonTime: startLessonTime,
        endLessonTime: endLessonTime,
        lessonTypeAbbrev: lessonTypeAbbrev,
        note: note,
        numSubgroup: numSubgroup,
        studentGroups: studentGroups,
        lecturers: lecturers,
        subject: subject,
        subjectFullName: subjectFullName,
        weeks: weekNumber,
        dateLesson: dateLesson != null
            ? DateFormat('dd.MM.yyyy').parse(dateLesson!)
            : null,
        startLessonDate: DateFormat('dd.MM.yyyy').parse(startLessonDate),
        endLessonDate: DateFormat('dd.MM.yyyy').parse(endLessonDate),
        weekDay: weekDay,
        isAnnouncement: isAnnouncement,
      );
}
