import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/starred_group_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:flutter/foundation.dart';

class GroupScreenViewModel extends ChangeNotifier {
  List<Group> _groups = [];
  List<Group> _starredGroups = [];
  static final GroupService _groupService = GroupService();
  static final StarredGroupService _starredGroupService = StarredGroupService();

  List<Group> get groups => _groups;
  List<Group> get starredGroups => _starredGroups;

  Future<void> fetchData(DatabaseHelper db) async {
    _groups = await _groupService.getAllGroups(db);
    _starredGroups = await _starredGroupService.getAllStarredGroups(db);
  }

  Future<void> addStarredGroup(DatabaseHelper db, Group group) async {
    await _starredGroupService.insertStarredGroup(db, group);
    _groups.add(group);
    notifyListeners();
  }

  Future<void> removeStarredGroup(DatabaseHelper db, Group group) async {
    await _starredGroupService.deleteStarredGroup(db, group);
    _groups.remove(group);
    notifyListeners();
  }
}
