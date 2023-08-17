import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/base_model.dart';
import 'package:bsuir_schedule/data/db/model/lecturer.dart';
import 'package:bsuir_schedule/domain/model/lecturer.dart';
import 'package:sqflite/sqflite.dart';

class AddStarredLecturer extends BaseModel {
  final int lecturerId;

  AddStarredLecturer(this.lecturerId);

  Map<String, dynamic> toMap() {
    return {
      'lecturer_id': lecturerId,
    };
  }
}

class StarredLecturerDb {
  Future<List<Lecturer>> getAllStarredLecturers(DatabaseHelper db) async {
    final List<Map<String, dynamic>> maps =
        await db.query(DbTableName.starredLecturer);
    final List<int> ids = maps.map((map) => map['lecturer_id'] as int).toList();

    final List<Lecturer> lecturers = [];

    for (var id in ids) {
      final lecturerData =
          (await db.queryWhere(DbTableName.lecturer, 'id = ?', [id]))
              .firstOrNull;

      if (lecturerData != null) {
        final lecturer = GetLecturer.fromMap(lecturerData).toLecturer();
        lecturers.add(lecturer);
      }
    }

    return lecturers;
  }

  Future<int> insertStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    try {
      return await db.insert(
          DbTableName.starredLecturer, AddStarredLecturer(lecturer.id));
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        return 0;
      } else {
        rethrow;
      }
    }
  }

  Future<int> deleteStarredLecturer(
      DatabaseHelper db, Lecturer lecturer) async {
    return await db.deleteWhere(
        DbTableName.starredLecturer, 'lecturer_id = ?', [lecturer.id]);
  }
}
