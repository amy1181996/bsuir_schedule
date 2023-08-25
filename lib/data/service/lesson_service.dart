import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/lesson_db.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';

class LessonService {
  static final LessonDb _lessonDb = LessonDb();

  Future<Lesson?> getLesson(DatabaseHelper db, int id) async {
    return _lessonDb.getLesson(db, id);
  }

  Future<int> addLesson(DatabaseHelper db, Lesson lesson) async {
    return _lessonDb.insertLesson(db, lesson);
  }

  Future<int> updateLesson(DatabaseHelper db, Lesson lesson) {
    return _lessonDb.updateLesson(db, lesson);
  }

  Future<int> removeLesson(DatabaseHelper db, Lesson lesson) {
    return _lessonDb.deleteLesson(db, lesson);
  }
}
