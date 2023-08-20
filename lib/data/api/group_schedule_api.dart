import 'dart:convert';

import 'package:bsuir_schedule/data/api/model/schedule.dart';
import 'package:bsuir_schedule/data/api/shared_api.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class GroupScheduleApi with SharedApi {
  static final GroupService _groupService = GroupService();
  static final LecturerService _lecturerService = LecturerService();

  Future<Schedule?> getGroupSchedule(DatabaseHelper db, Group group) async {
    final String localPath = 'schedule?studentGroup=${group.name}';

    final response = await getResponse(localPath);

    if (response.statusCode != 200) {
      return null;
    }

    final ApiSchedule apiSchedule = ApiSchedule.fromJson(
      jsonDecode(await response.transform(utf8.decoder).join()),
    );

    final List<Lesson> schedules = [];
    final List<Lesson> exams = [];

    for (final entry in apiSchedule.schedules.entries) {
      for (final apiLesson in entry.value) {
        final groupsNames =
            apiLesson.mappedGroups.map((e) => e['name']).toList();
        final lecturersNames =
            apiLesson.mappedLecturers?.map((e) => e['urlId']).toList();

        final groups = (await Future.wait(
          groupsNames.map((e) => _groupService.getGroupByName(db, e)),
        ))
            .whereType<Group>()
            .toList();
        final List<Lecturer> lecturers = lecturersNames != null
            ? (await Future.wait(
                lecturersNames
                    .map((e) => _lecturerService.getLecturerByUrlId(db, e)),
              ))
                .whereType<Lecturer>()
                .toList()
            : [];

        final Lesson lesson = apiLesson.toLesson(
            weekDay: entry.key, studentGroups: groups, lecturers: lecturers);

        schedules.add(lesson);
      }
    }

    for (final apiLesson in apiSchedule.exams) {
      final groupsNames = apiLesson.mappedGroups.map((e) => e['name']).toList();
      final lecturersNames =
          apiLesson.mappedLecturers?.map((e) => e['urlId']).toList();

      final groups = (await Future.wait(
        groupsNames.map((e) => _groupService.getGroupByName(db, e)),
      ))
          .whereType<Group>()
          .toList();
      final List<Lecturer> lecturers = lecturersNames != null
          ? (await Future.wait(
              lecturersNames
                  .map((e) => _lecturerService.getLecturerByUrlId(db, e)),
            ))
              .whereType<Lecturer>()
              .toList()
          : [];

      final Lesson lesson = apiLesson.toLesson(
          weekDay: null, studentGroups: groups, lecturers: lecturers);

      exams.add(lesson);
    }

    return apiSchedule.toSchedule(
      lecturer: null,
      group: group,
      schedules: schedules,
      exams: exams,
    );
  }
}
