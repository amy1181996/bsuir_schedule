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
  final Map<int, List<Lesson>> schedules;
  final List<Lesson> exams;
  final List<Lesson> announcements;

  @override
  int get hashCode =>
      id.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      startExamsDate.hashCode ^
      endExamsDate.hashCode ^
      lecturer.hashCode ^
      group.hashCode ^
      schedules.hashCode ^
      announcements.hashCode ^
      exams.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Schedule &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          startExamsDate == other.startExamsDate &&
          endExamsDate == other.endExamsDate &&
          lecturer == other.lecturer &&
          group == other.group &&
          schedules == other.schedules &&
          exams == other.exams &&
          announcements == other.announcements;

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
    required this.announcements,
  });

  Schedule copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startExamsDate,
    Lecturer? lecturer,
    Group? group,
    Map<int, List<Lesson>>? schedules,
    List<Lesson>? exams,
    List<Lesson>? announcements,
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
        announcements: announcements ?? this.announcements,
      );
}
