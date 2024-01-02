import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/lesson.dart';
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

    final List<GetLesson> lessons = (await Future.wait(lessonGroupRelations.map(
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

  Future<int> insertGroupSchedule(
      DatabaseHelper db, Schedule groupSchedule) async {
    final int scheduleId = await db.insert(
        DbTableName.groupSchedule, AddSchedule.fromSchedule(groupSchedule));

    await Future.wait(groupSchedule.schedules.entries.map((entry) async {
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

    await Future.wait(groupSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.exam,
        weekday: null,
      );
    }));

    await Future.wait(groupSchedule.announcements.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.announcement,
        weekday: null,
      );
    }));

    return scheduleId;
  }

  Future<int> updateGroupSchedule(
      DatabaseHelper db, Schedule groupSchedule) async {
    final oldGroupSchedule = await getGroupSchedule(db, groupSchedule.group!);

    if (oldGroupSchedule != null) {
      await Future.wait(oldGroupSchedule.schedules.entries.map((entry) async {
        entry.value.map((lesson) async {
          await _lessonService.removeLesson(db, lesson);
        });
      }));

      await Future.wait(oldGroupSchedule.exams.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));

      await Future.wait(oldGroupSchedule.announcements.map((lesson) async {
        await _lessonService.removeLesson(db, lesson);
      }));
    }

    final int scheduleId = await db.update(
        DbTableName.groupSchedule, AddSchedule.fromSchedule(groupSchedule));

    await Future.wait(groupSchedule.schedules.entries.map((entry) async {
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

    await Future.wait(groupSchedule.exams.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.exam,
        weekday: null,
      );
    }));

    await Future.wait(groupSchedule.announcements.map((lesson) async {
      await _lessonService.addLesson(
        db: db,
        lesson: lesson,
        lessonType: LessonType.announcement,
        weekday: null,
      );
    }));

    return scheduleId;
  }

  Future<int> removeGroupSchedule(
    DatabaseHelper db,
    Schedule groupSchedule,
  ) async {
    await db.deleteWhere(
      DbTableName.lessonGroupRelation,
      'group_id = ?',
      [groupSchedule.group!.id],
    );

    return await db.deleteWhere(
      DbTableName.groupSchedule,
      'id = ?',
      [groupSchedule.id],
    );
  }
}
