import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/lesson_db.dart';
import 'package:bsuir_schedule/data/db/model/lesson.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/ui/widget/lesson_tab.dart';

class LessonService {
  static final LessonDb _lessonDb = LessonDb();

  Future<Lesson?> getLesson(DatabaseHelper db, int id) async {
    return _lessonDb.getLesson(db, id);
  }

  Future<GetLesson?> getRawLesson(DatabaseHelper db, int id) async {
    return _lessonDb.getRawLesson(db, id);
  }

  Future<int> addLesson(
      {required DatabaseHelper db,
      required Lesson lesson,
      required LessonType lessonType,
      required int? weekday}) async {
    return _lessonDb.insertLesson(
      db: db,
      lesson: lesson,
      lessonType: lessonType,
      weekday: weekday,
    );
  }

  Future<int> updateLesson(DatabaseHelper db, Lesson lesson) {
    return _lessonDb.updateLesson(db, lesson);
  }

  Future<int> removeLesson(DatabaseHelper db, Lesson lesson) {
    return _lessonDb.deleteLesson(db, lesson);
  }
}
