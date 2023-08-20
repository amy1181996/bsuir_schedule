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
}
