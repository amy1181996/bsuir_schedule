import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/lesson_lecturer_relation_model.dart';
import 'package:bsuir_schedule/data/db/model/schedule.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lesson_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/schedule.dart';

class LecturerScheduleDb {
  static final GroupService _groupService = GroupService();
  static final LessonService _lessonService = LessonService();

  Future<Schedule?> getLecturerSchedule(
      DatabaseHelper db, Lecturer lecturer) async {
    final maps = (await db.queryWhere(
            DbTableName.lecturerSchedule, 'lecturer_id = ?', [lecturer.id]))
        .firstOrNull;

    if (maps == null) {
      return null;
    }

    final GetSchedule getSchedule = GetSchedule.fromMap(maps);

    final Group? group = getSchedule.groupId != null
        ? await _groupService.getGroupById(db, getSchedule.groupId!)
        : null;

    final List<GetLessonLecturerRelation> lessonLecturerRelations = (await db
            .queryWhere(DbTableName.lessonLecturerRelation, 'lecturer_id = ?',
                [lecturer.id]))
        .map((e) => GetLessonLecturerRelation.fromMap(e))
        .toList();

    final List<Lesson> lessons = (await Future.wait(lessonLecturerRelations.map(
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

  Future<int> insertLecturerSchedule(
      DatabaseHelper db, Schedule lecturerSchedule) async {
    final int scheduleId = await db.insert(DbTableName.lecturerSchedule,
        AddSchedule.fromSchedule(lecturerSchedule));

    await Future.wait(lecturerSchedule.schedules.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    await Future.wait(lecturerSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    return scheduleId;
  }

  Future<int> updateLecturerSchedule(
      DatabaseHelper db, Schedule lecturerSchedule) async {
    final oldLecturerSchedule =
        await getLecturerSchedule(db, lecturerSchedule.lecturer!);

    if (oldLecturerSchedule != null) {
      await Future.wait(oldLecturerSchedule.schedules.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));

      await Future.wait(oldLecturerSchedule.exams.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));
    }

    final int scheduleId = await db.update(DbTableName.lecturerSchedule,
        AddSchedule.fromSchedule(lecturerSchedule));

    await Future.wait(lecturerSchedule.schedules.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    await Future.wait(lecturerSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(db, lesson);
    }));

    return scheduleId;
  }

  Future<int> deleteLecturerSchedule(
      DatabaseHelper db, Schedule lecturerSchedule) async {
    await Future.wait(lecturerSchedule.schedules.map((lesson) async {
      await _lessonService.removeLesson(db, lesson);
    }));

    await Future.wait(lecturerSchedule.exams.map((lesson) async {
      await _lessonService.removeLesson(db, lesson);
    }));

    return await db.deleteWhere(
        DbTableName.groupSchedule, 'id = ?', [lecturerSchedule.id]);
  }
}
