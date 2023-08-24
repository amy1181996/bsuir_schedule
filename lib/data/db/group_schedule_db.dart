import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/lesson_group_relation_mode.dart';
import 'package:bsuir_schedule/data/db/model/schedule.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/data/service/lesson_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class GroupScheduleDb {
  static final LecturerService _lecturerService = LecturerService();
  static final LessonService _lessonService = LessonService();

  Future<Schedule?> getGroupSchedule(DatabaseHelper db, Group group) async {
    final maps = (await db
            .queryWhere(DbTableName.groupSchedule, 'group_id = ?', [group.id]))
        .firstOrNull;

    if (maps == null) {
      return null;
    }

    final GetSchedule getSchedule = GetSchedule.fromMap(maps);

    final Lecturer? lecturer = getSchedule.lecturerId != null
        ? await _lecturerService.getLecturerById(
            db,
            getSchedule.lecturerId!,
          )
        : null;

    final List<GetLessonGroupRelation> lessonGroupRelations = (await db
            .queryWhere(
                DbTableName.lessonGroupRelation, 'group_id = ?', [group.id]))
        .map((e) => GetLessonGroupRelation.fromMap(e))
        .toList();

    final List<Lesson> lessons = (await Future.wait(lessonGroupRelations.map(
            (relation) => _lessonService.getLesson(db, relation.lessonId))))
        .whereType<Lesson>()
        .toList();

    final List<Lesson> schedules = [];
    final List<Lesson> exams = [];
    for (var element in lessons) {
      if (element.weekDay != null) {
        schedules.add(element);
      } else {
        exams.add(element);
      }
    }

    return getSchedule.toSchedule(
      group: group,
      lecturer: lecturer,
      schedules: schedules,
      exams: exams,
    );
  }

  Future<int> insertGroupSchedule(
      DatabaseHelper db, Schedule groupSchedule) async {
    final int scheduleId = await db.insert(
        DbTableName.groupSchedule, AddSchedule.fromSchedule(groupSchedule));

    await Future.wait(groupSchedule.schedules.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    await Future.wait(groupSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    return scheduleId;
  }

  Future<int> updateGroupSchedule(
      DatabaseHelper db, Schedule groupSchedule) async {
    final oldGroupSchedule = (await getGroupSchedule(db, groupSchedule.group!));

    if (oldGroupSchedule != null) {
      await Future.wait(groupSchedule.schedules.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));

      await Future.wait(groupSchedule.exams.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));
    }

    final int scheduleId = await db.update(
        DbTableName.groupSchedule, AddSchedule.fromSchedule(groupSchedule));

    // if (scheduleId == 0) {
    //   await db.insert(
    //       DbTableName.groupSchedule, AddSchedule.fromSchedule(groupSchedule));
    // }

    await Future.wait(groupSchedule.schedules.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    await Future.wait(groupSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    return scheduleId;
  }

  Future<int> removeGroupSchedule(
      DatabaseHelper db, Schedule groupSchedule) async {
    await Future.wait(groupSchedule.schedules.map((lesson) async {
      await _lessonService.removeLesson(db, lesson);
    }));

    await Future.wait(groupSchedule.exams.map((lesson) async {
      await _lessonService.removeLesson(db, lesson);
    }));

    return await db
        .deleteWhere(DbTableName.groupSchedule, 'id = ?', [groupSchedule.id]);
  }
}
