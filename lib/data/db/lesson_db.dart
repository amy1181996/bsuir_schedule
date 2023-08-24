import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/lesson.dart';
import 'package:bsuir_schedule/data/db/model/lesson_group_relation_mode.dart';
import 'package:bsuir_schedule/data/db/model/lesson_lecturer_relation_model.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:sqflite/sqflite.dart';

class LessonDb {
  static final GroupService _groupService = GroupService();
  static final LecturerService _lecturerService = LecturerService();

  Future<Lesson?> getLesson(DatabaseHelper db, int id) async {
    final maps =
        (await db.queryWhere(DbTableName.lesson, 'id = ?', [id])).firstOrNull;

    if (maps == null) {
      return null;
    }

    final getLesson = GetLesson.fromMap(maps);

    final lessonGroupRelations = await db.queryWhere(
        DbTableName.lessonGroupRelation, 'lesson_id = ?', [getLesson.id]);

    final lessonLecturerRelations = await db.queryWhere(
        DbTableName.lessonLecturerRelation, 'lesson_id = ?', [getLesson.id]);

    final groups = await Future.wait(lessonGroupRelations.map((relation) =>
        _groupService.getGroupById(db, relation['group_id'] as int)));

    final lecturers = await Future.wait(lessonLecturerRelations.map(
        (relation) => _lecturerService.getLecturerById(
            db, relation['lecturer_id'] as int)));

    return getLesson.toLesson(
        studentGroups: groups.whereType<Group>().toList(),
        lecturers: lecturers.whereType<Lecturer>().toList());
  }

  Future<int> insertLesson(DatabaseHelper db, Lesson lesson) async {
    int lessonId;
    try {
      lessonId =
          await db.insert(DbTableName.lesson, AddLesson.fromLesson(lesson));
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        lessonId = (await db.queryWhere(
          DbTableName.lesson,
          'hash = ?',
          [AddLesson.fromLesson(lesson).hashCode],
        ))
            .first['id'] as int;
      } else {
        rethrow;
      }
    }

    await Future.wait(lesson.studentGroups.map((group) async {
      try {
        await db.insert(
          DbTableName.lessonGroupRelation,
          AddLessonGroupRelation(
            lessonId: lessonId,
            groupId: group.id,
          ),
        );
      } on Exception catch (e) {
        print('$e');
      }
    }));

    await Future.wait(lesson.lecturers.map((lecturer) async {
      try {
        await db.insert(
          DbTableName.lessonLecturerRelation,
          AddLessonLecturerRelation(
            lessonId: lessonId,
            lecturerId: lecturer.id,
          ),
        );
      } on Exception catch (e) {
        print('$e');
      }
    }));

    return lessonId;
  }

  Future<int> updateLesson(DatabaseHelper db, Lesson lesson) async {
    final lessonId = lesson.id;

    await db.deleteWhere(
      DbTableName.lessonGroupRelation,
      'lesson_id = ?',
      [lessonId],
    );

    await db.deleteWhere(
      DbTableName.lessonLecturerRelation,
      'lesson_id = ?',
      [lessonId],
    );

    await Future.wait(lesson.studentGroups.map((group) async {
      await db.insert(
        DbTableName.lessonGroupRelation,
        AddLessonGroupRelation(
          lessonId: lessonId,
          groupId: group.id,
        ),
      );
    }));

    await Future.wait(lesson.lecturers.map((lecturer) async {
      await db.insert(
        DbTableName.lessonLecturerRelation,
        AddLessonLecturerRelation(
          lessonId: lessonId,
          lecturerId: lecturer.id,
        ),
      );
    }));

    return await db.update(DbTableName.lesson, AddLesson.fromLesson(lesson));
  }

  Future<int> deleteLesson(DatabaseHelper db, Lesson lesson) async {
    final lessonId = lesson.id;

    await db.deleteWhere(
      DbTableName.lessonGroupRelation,
      'lesson_id = ?',
      [lessonId],
    );

    await db.deleteWhere(
      DbTableName.lessonLecturerRelation,
      'lesson_id = ?',
      [lessonId],
    );

    return await db.delete(DbTableName.lesson, AddLesson.fromLesson(lesson));
  }
}
