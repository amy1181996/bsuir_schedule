import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';

class Lesson {
  final int id;
  final List<String> auditories;
  final String startLessonTime;
  final String endLessonTime;
  final String lessonTypeAbbrev;
  final String? note;
  final int numSubgroup;
  final List<Group> studentGroups;
  final List<Lecturer> lecturers;
  final String subject;
  final String subjectFullName;
  final List<int> weeks;
  final DateTime? dateLesson;
  final DateTime startLessonDate;
  final DateTime endLessonDate;
  final String? weekDay;

  Lesson({
    required this.id,
    required this.auditories,
    required this.startLessonTime,
    required this.endLessonTime,
    required this.lessonTypeAbbrev,
    required this.note,
    required this.numSubgroup,
    required this.studentGroups,
    required this.lecturers,
    required this.subject,
    required this.subjectFullName,
    required this.weeks,
    required this.dateLesson,
    required this.startLessonDate,
    required this.endLessonDate,
    required this.weekDay,
  });

  Lesson copyWith({
    int? id,
    List<String>? auditories,
    String? startLessonTime,
    String? endLessonTime,
    String? lessonTypeAbbrev,
    String? note,
    int? numSubgroup,
    List<Group>? studentGroups,
    List<Lecturer>? lecturers,
    String? subject,
    String? subjectFullName,
    List<int>? weeks,
    DateTime? dateLesson,
    DateTime? startLessonDate,
    DateTime? endLessonDate,
    String? weekDay,
  }) =>
      Lesson(
        id: id ?? this.id,
        auditories: auditories ?? this.auditories,
        startLessonTime: startLessonTime ?? this.startLessonTime,
        endLessonTime: endLessonTime ?? this.endLessonTime,
        lessonTypeAbbrev: lessonTypeAbbrev ?? this.lessonTypeAbbrev,
        note: note ?? this.note,
        numSubgroup: numSubgroup ?? this.numSubgroup,
        studentGroups: studentGroups ?? this.studentGroups,
        lecturers: lecturers ?? this.lecturers,
        subject: subject ?? this.subject,
        subjectFullName: subjectFullName ?? this.subjectFullName,
        weeks: weeks ?? this.weeks,
        dateLesson: dateLesson ?? this.dateLesson,
        startLessonDate: startLessonDate ?? this.startLessonDate,
        endLessonDate: endLessonDate ?? this.endLessonDate,
        weekDay: weekDay ?? this.weekDay,
      );
}
