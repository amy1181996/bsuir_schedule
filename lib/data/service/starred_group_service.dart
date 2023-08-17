import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/starred_group_db.dart';
import 'package:bsuir_schedule/domain/model/group.dart';

class StarredGroupService {
  static final StarredGroupDb _starredGroupDb = StarredGroupDb();

  Future<List<Group>> getAllStarredGroups(DatabaseHelper db) async {
    return await _starredGroupDb.getAllStarredGroups(db);
  }

  Future<int> insertStarredGroup(DatabaseHelper db, Group group) async {
    return await _starredGroupDb.insertStarredGroup(db, group);
  }

  Future<int> deleteStarredGroup(DatabaseHelper db, Group group) async {
    return await _starredGroupDb.deleteStarredGroup(db, group);
  }
}
