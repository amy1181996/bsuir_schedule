import 'package:bsuir_schedule/data/api/model/lesson.dart';
import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';

enum LessonType {
  lesson,
  exam,
  announcement,
}

class AddLesson extends BaseModel {
  final String auditories;
  final String startLessonTime;
  final String endLessonTime;
  final String lessonTypeAbbrev;
  final String? note;
  final int numSubgroup;
  final String subject;
  final String subjectFullName;
  final String weeks;
  final String? dateLesson;
  final String? startLessonDate;
  final String? endLessonDate;
  final LessonType lessonType;
  final int? weekday;

  @override
  int get hashCode =>
      auditories.hashCode ^
      startLessonTime.hashCode ^
      endLessonTime.hashCode ^
      lessonTypeAbbrev.hashCode ^
      note.hashCode ^
      numSubgroup.hashCode ^
      subject.hashCode ^
      subjectFullName.hashCode ^
      weeks.hashCode ^
      dateLesson.hashCode ^
      startLessonDate.hashCode ^
      endLessonDate.hashCode ^
      lessonType.hashCode ^
      weekday.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddLesson &&
          runtimeType == other.runtimeType &&
          auditories == other.auditories &&
          startLessonTime == other.startLessonTime &&
          endLessonTime == other.endLessonTime &&
          lessonTypeAbbrev == other.lessonTypeAbbrev &&
          note == other.note &&
          numSubgroup == other.numSubgroup &&
          subject == other.subject &&
          subjectFullName == other.subjectFullName &&
          weeks == other.weeks &&
          dateLesson == other.dateLesson &&
          startLessonDate == other.startLessonDate &&
          endLessonDate == other.endLessonDate &&
          lessonType == other.lessonType &&
          weekday == other.weekday;

  AddLesson({
    required this.auditories,
    required this.startLessonTime,
    required this.endLessonTime,
    required this.lessonTypeAbbrev,
    required this.note,
    required this.numSubgroup,
    required this.subject,
    required this.subjectFullName,
    required this.weeks,
    required this.dateLesson,
    required this.startLessonDate,
    required this.endLessonDate,
    required this.lessonType,
    this.weekday,
  });

  factory AddLesson.fromLesson({
    required Lesson lesson,
    required LessonType lessonType,
    int? weekday,
  }) =>
      AddLesson(
        auditories: lesson.auditories.join(','),
        startLessonTime: lesson.startLessonTime,
        endLessonTime: lesson.endLessonTime,
        lessonTypeAbbrev: lesson.lessonTypeAbbrev,
        note: lesson.note ?? '',
        numSubgroup: lesson.numSubgroup,
        subject: lesson.subject,
        subjectFullName: lesson.subjectFullName,
        weeks: lesson.weeks.join(','),
        dateLesson: lesson.dateLesson?.toIso8601String(),
        startLessonDate: lesson.startLessonDate?.toIso8601String(),
        endLessonDate: lesson.endLessonDate?.toIso8601String(),
        lessonType: lessonType,
        weekday: weekday,
      );

  @override
  Map<String, dynamic> toMap() => {
        'auditories': auditories,
        'start_lesson_time': startLessonTime,
        'end_lesson_time': endLessonTime,
        'lesson_type_abbrev': lessonTypeAbbrev,
        'note': note,
        'num_subgroup': numSubgroup,
        'subject': subject,
        'subject_full_name': subjectFullName,
        'weeks': weeks,
        'date_lesson': dateLesson,
        'start_lesson_date': startLessonDate,
        'end_lesson_date': endLessonDate,
        'lesson_type': lessonType.index,
        'weekday': weekday,
        'hash': hashCode,
      };
}

class GetLesson extends BaseModel {
  @override
  // ignore: overridden_fields
  final int id;
  final String auditories;
  final String startLessonTime;
  final String endLessonTime;
  final String lessonTypeAbbrev;
  final String? note;
  final int numSubgroup;
  final String subject;
  final String subjectFullName;
  final String weeks;
  final String? dateLesson;
  final String? startLessonDate;
  final String? endLessonDate;
  final LessonType lessonType;
  final int? weekday;
  List<Group>? studentGroups;
  List<Lecturer>? lecturers;

  GetLesson({
    required this.id,
    required this.auditories,
    required this.startLessonTime,
    required this.endLessonTime,
    required this.lessonTypeAbbrev,
    required this.note,
    required this.numSubgroup,
    required this.subject,
    required this.subjectFullName,
    required this.weeks,
    required this.dateLesson,
    required this.startLessonDate,
    required this.endLessonDate,
    required this.lessonType,
    this.weekday,
    this.studentGroups,
    this.lecturers,
  });

  factory GetLesson.fromMap(Map<String, dynamic> map) => GetLesson(
        id: map['id'],
        auditories: map['auditories'],
        startLessonTime: map['start_lesson_time'],
        endLessonTime: map['end_lesson_time'],
        lessonTypeAbbrev: map['lesson_type_abbrev'],
        note: map['note'],
        numSubgroup: map['num_subgroup'],
        subject: map['subject'],
        subjectFullName: map['subject_full_name'],
        weeks: map['weeks'],
        dateLesson: map['date_lesson'],
        startLessonDate: map['start_lesson_date'],
        endLessonDate: map['end_lesson_date'],
        lessonType: LessonType.values[map['lesson_type']],
        weekday: map['weekday'],
      );

  Lesson toLesson({
    required List<Group> studentGroups,
    required List<Lecturer> lecturers,
  }) =>
      Lesson(
        id: id,
        auditories: auditories.split(','),
        startLessonTime: startLessonTime,
        endLessonTime: endLessonTime,
        lessonTypeAbbrev: lessonTypeAbbrev,
        note: note,
        studentGroups: studentGroups,
        lecturers: lecturers,
        numSubgroup: numSubgroup,
        subject: subject,
        subjectFullName: subjectFullName,
        weeks: weeks.isNotEmpty
            ? weeks.split(',').map((e) => int.parse(e)).toList()
            : [],
        dateLesson: dateLesson != null ? DateTime.parse(dateLesson!) : null,
        startLessonDate: startLessonDate != null ? DateTime.parse(startLessonDate!) : null,
        endLessonDate: endLessonDate != null ? DateTime.parse(endLessonDate!) : null,
      );
}
