import 'package:bsuir_schedule/data/db/db_helper/db_constants.dart';
import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/db/model/group.dart';
import 'package:bsuir_schedule/domain/model/group.dart';

class GroupDb {
  Future<List<Group>> getAllGroups(DatabaseHelper db) async {
    List<Map<String, dynamic>> maps = await db.query(DbTableName.group);
    return maps.map((map) => GetGroup.fromMap(map).toGroup()).toList();
  }

  Future<int> insertGroup(DatabaseHelper db, Group group) async {
    return await db.insert(DbTableName.group, AddGroup.fromGroup(group));
  }

  Future<int> updateGroup(DatabaseHelper db, Group group) async {
    return await db.update(DbTableName.group, AddGroup.fromGroup(group));
  }

  Future<int> deleteGroup(DatabaseHelper db, Group group) async {
    return await db.delete(DbTableName.group, AddGroup.fromGroup(group));
  }
}