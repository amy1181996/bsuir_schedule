import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';

class Schedule {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? startExamsDate;
  final DateTime? endExamsDate;
  final Lecturer? lecturer;
  final Group? group;
  final List<Lesson> schedules;
  final List<Lesson> exams;

  Schedule({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startExamsDate,
    required this.endExamsDate,
    required this.lecturer,
    required this.group,
    required this.schedules,
    required this.exams,
  });

  Schedule copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startExamsDate,
    Lecturer? lecturer,
    Group? group,
    List<Lesson>? schedules,
    List<Lesson>? exams,
  }) =>
      Schedule(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        startExamsDate: startExamsDate ?? this.startDate,
        endExamsDate: endExamsDate ?? this.endDate,
        lecturer: lecturer ?? this.lecturer,
        group: group ?? this.group,
        schedules: schedules ?? this.schedules,
        exams: exams ?? this.exams,
      );
}
