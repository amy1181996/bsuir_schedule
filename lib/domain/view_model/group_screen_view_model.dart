import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/group_schedule_service.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/starred_group_service.dart';
import 'package:bsuir_schedule/domain/model/group.dart';
import 'package:flutter/material.dart';

class GroupScreenViewModel extends ChangeNotifier {
  List<Group> _groups = [];
  List<Group> _starredGroups = [];
  List<Group> _shownGroups = [];
  List<Group> _shownStarredGroups = [];
  static final GroupService _groupService = GroupService();
  static final StarredGroupService _starredGroupService = StarredGroupService();
  static final GroupScheduleService _groupScheduleService =
      GroupScheduleService();

  List<Group> get groups => _shownGroups;
  List<Group> get starredGroups => _shownStarredGroups;

  Future<bool> fetchData(DatabaseHelper db) async {
    _groups = await _groupService.getAllGroups(db);
    _starredGroups = await _starredGroupService.getAllStarredGroups(db);
    _shownGroups = _groups;
    _shownStarredGroups = _starredGroups;
    return true;
  }

  Future<void> addStarredGroup(DatabaseHelper db, Group group) async {
    final int inserted =
        await _starredGroupService.insertStarredGroup(db, group);

    if (inserted != -1) {
      _starredGroups.add(group);
      await _groupScheduleService.getGroupSchedule(db, group);
      notifyListeners();
    }
  }

  Future<void> removeStarredGroup(DatabaseHelper db, Group group) async {
    final int deleted =
        await _starredGroupService.deleteStarredGroup(db, group);

    if (deleted != 0) {
      _starredGroups.remove(group);
      await _groupScheduleService.removeGroupSchedule(db, group);
      notifyListeners();
    }
  }

  Future<void> updateStarredGroup(DatabaseHelper db, Group group) async {
    await _groupScheduleService.updateGroupSchedule(db, group);
  }
}
