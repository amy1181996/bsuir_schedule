import 'package:bsuir_schedule/data/api/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';
import 'package:intl/intl.dart';

class ApiSchedule {
  final String startDate;
  final String endDate;
  final String? startExamsDate;
  final String? endExamsDate;
  // final ApiLecturer? employeeDto;
  // final ApiGroup? studentGroupDto;
  final Map<String, dynamic>? employeeDto;
  final Map<String, dynamic>? studentGroupDto;
  final Map<String, List<ApiLesson>> schedules;
  final List<ApiLesson> exams;

  ApiSchedule({
    required this.startDate,
    required this.endDate,
    required this.startExamsDate,
    required this.endExamsDate,
    required this.employeeDto,
    required this.studentGroupDto,
    required this.schedules,
    required this.exams,
  });

  factory ApiSchedule.fromJson(Map<String, dynamic> json) => ApiSchedule(
        startDate: json['startDate'],
        endDate: json['endDate'],
        startExamsDate: json['startExamsDate'],
        endExamsDate: json['endExamsDate'],
        employeeDto: json['employeeDto'],
        studentGroupDto: json['studentGroupDto'],
        schedules: Map<String, List<ApiLesson>>.from(
          json['schedules']?.map(
                (k, v) => MapEntry(
                  k,
                  List<ApiLesson>.from(
                    v.map((x) => ApiLesson.fromJson(x)),
                  ),
                ),
              ) ??
              {},
        ),
        exams: List<ApiLesson>.from(
          json['exams']?.map((x) => ApiLesson.fromJson(x)) ?? [],
        ),
      );

  Schedule toSchedule({
    required Lecturer? lecturer,
    required Group? group,
    required Map<int, List<Lesson>> schedules,
    required List<Lesson> exams,
    required List<Lesson> announcements,
  }) =>
      Schedule(
        id: 0,
        startDate: DateFormat('dd.MM.yyyy').parse(startDate),
        endDate: DateFormat('dd.MM.yyyy').parse(endDate),
        startExamsDate: startExamsDate != null
            ? DateFormat('dd.MM.yyyy').parse(startExamsDate!)
            : null,
        endExamsDate: endExamsDate != null
            ? DateFormat('dd.MM.yyyy').parse(endExamsDate!)
            : null,
        lecturer: lecturer,
        group: group,
        schedules: schedules,
        exams: exams,
        announcements: announcements,
      );
}
