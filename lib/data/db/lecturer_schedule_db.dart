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

import 'model/lesson.dart';

class LecturerScheduleDb {
  static final GroupService _groupService = GroupService();
  static final LessonService _lessonService = LessonService();

  Future<Schedule?> getLecturerSchedule(
    DatabaseHelper db,
    Lecturer lecturer,
  ) async {
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

    final List<GetLesson> lessons = (await Future.wait(lessonLecturerRelations.map(
            (relation) => _lessonService.getRawLesson(db, relation.lessonId))))
        .whereType<GetLesson>()
        .toList();

    final Map<int, List<Lesson>> schedules = {};
    final List<Lesson> exams = [];
    final List<Lesson> announcements = [];
    for (var element in lessons) {
      switch (element.lessonType) {
        case LessonType.announcement:
          announcements.add(element.toLesson(
            studentGroups: element.studentGroups!,
            lecturers: element.lecturers!,
          ));
          break;
        case LessonType.lesson:
          schedules[element.weekday!] ??= [];
          schedules[element.weekday]!.add(element.toLesson(
            studentGroups: element.studentGroups!,
            lecturers: element.lecturers!,
          ));
          break;
        case LessonType.exam:
          exams.add(element.toLesson(
            studentGroups: element.studentGroups!,
            lecturers: element.lecturers!,
          ));
          break;
        default:
          break;
      }
    }

    return getSchedule.toSchedule(
      group: group,
      lecturer: lecturer,
      schedules: schedules,
      exams: exams,
      announcements: announcements,
    );
  }

  Future<int> insertLecturerSchedule(
    DatabaseHelper db,
    Schedule lecturerSchedule,
  ) async {
    final int scheduleId = await db.insert(DbTableName.lecturerSchedule,
        AddSchedule.fromSchedule(lecturerSchedule));

    await Future.wait(lecturerSchedule.schedules.entries.map((entry) async {
      final weekday = entry.key;
      final lessons = entry.value;

      await Future.wait(lessons.map((lesson) async {
        await _lessonService.addLesson(
          db: db,
          lesson: lesson,
          lessonType: LessonType.lesson,
          weekday: weekday,
        );
      }));
    }));

    await Future.wait(lecturerSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.exam,
        weekday: null,
      );
    }));

    await Future.wait(lecturerSchedule.announcements.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.announcement,
        weekday: null,
      );
    }));

    return scheduleId;
  }

  Future<int> updateLecturerSchedule(
    DatabaseHelper db,
    Schedule lecturerSchedule,
  ) async {
    final oldLecturerSchedule =
        await getLecturerSchedule(db, lecturerSchedule.lecturer!);

    if (oldLecturerSchedule != null) {
      await Future.wait(oldLecturerSchedule.schedules.entries.map((entry) async {
        entry.value.map((lesson) async {
          await _lessonService.removeLesson(db, lesson);
        });
      }));

      await Future.wait(oldLecturerSchedule.exams.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));

      await Future.wait(oldLecturerSchedule.announcements.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));
    }

    final int scheduleId = await db.update(DbTableName.lecturerSchedule,
        AddSchedule.fromSchedule(lecturerSchedule));

    await Future.wait(lecturerSchedule.schedules.entries.map((entry) async {
      final weekday = entry.key;
      final lessons = entry.value;

      await Future.wait(lessons.map((lesson) async {
        await _lessonService.addLesson(
          db: db,
          lesson: lesson,
          lessonType: LessonType.lesson,
          weekday: weekday,
        );
      }));
    }));

    await Future.wait(lecturerSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.exam,
        weekday: null,
      );
    }));

    await Future.wait(lecturerSchedule.announcements.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.announcement,
        weekday: null,
      );
    }));

    return scheduleId;
  }

  Future<int> deleteLecturerSchedule(
    DatabaseHelper db,
    Schedule lecturerSchedule,
  ) async {
    await db.deleteWhere(
      DbTableName.lessonLecturerRelation,
      'lecturer_id = ?',
      [lecturerSchedule.group!.id],
    );

    return await db.deleteWhere(
        DbTableName.groupSchedule, 'id = ?', [lecturerSchedule.id]);
  }
}
