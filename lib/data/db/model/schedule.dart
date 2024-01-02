import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class AddSchedule extends BaseModel {
  final String startDate;
  final String endDate;
  final String? startExamsDate;
  final String? endExamsDate;
  final int? lecturerId;
  final int? groupId;

  AddSchedule({
    required this.startDate,
    required this.endDate,
    required this.startExamsDate,
    required this.endExamsDate,
    required this.lecturerId,
    required this.groupId,
  });

  factory AddSchedule.fromSchedule(Schedule schedule) => AddSchedule(
        startDate: schedule.startDate.toIso8601String(),
        endDate: schedule.endDate.toIso8601String(),
        startExamsDate: schedule.startExamsDate?.toIso8601String(),
        endExamsDate: schedule.endExamsDate?.toIso8601String(),
        lecturerId: schedule.lecturer?.id,
        groupId: schedule.group?.id,
      );

  @override
  Map<String, dynamic> toMap() => {
        'start_date': startDate,
        'end_date': endDate,
        'start_exams_date': startExamsDate,
        'end_exams_date': endExamsDate,
        'lecturer_id': lecturerId,
        'group_id': groupId,
      };
}

class GetSchedule extends BaseModel {
  @override
  // ignore: overridden_fields
  final int? id;
  final String? startDate;
  final String? endDate;
  final String? startExamsDate;
  final String? endExamsDate;
  final int? lecturerId;
  final int? groupId;

  GetSchedule({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startExamsDate,
    required this.endExamsDate,
    required this.lecturerId,
    required this.groupId,
  });

  factory GetSchedule.fromMap(Map<String, dynamic> map) => GetSchedule(
        id: map['id'],
        startDate: map['start_date'],
        endDate: map['end_date'],
        startExamsDate: map['start_exams_date'],
        endExamsDate: map['end_exams_date'],
        lecturerId: map['lecturer_id'],
        groupId: map['group_id'],
      );

  Schedule toSchedule({
    required Group? group,
    required Lecturer? lecturer,
    required Map<int, List<Lesson>> schedules,
    required List<Lesson> exams,
    required List<Lesson> announcements,
  }) =>
      Schedule(
        id: id!,
        startDate: DateTime.parse(startDate!),
        endDate: DateTime.parse(endDate!),
        startExamsDate:
            startExamsDate != null ? DateTime.parse(startExamsDate!) : null,
        endExamsDate:
            endExamsDate != null ? DateTime.parse(endExamsDate!) : null,
        lecturer: lecturer,
        group: group,
        schedules: schedules,
        exams: exams,
        announcements: announcements,
      );
}
