import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/current_week_service.dart';
import 'package:bsuir_schedule/data/service/group_schedule_service.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_schedule_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:flutter/foundation.dart';

class ScheduleScreenViewModel extends ChangeNotifier {
  static const Map<String, int> _weekDayNumber = {
    'Понедельник': 0,
    'Вторник': 1,
    'Среда': 2,
    'Четверг': 3,
    'Пятница': 4,
    'Суббота': 5,
    'Воскресенье': 6,
  };

  late int _currentWeek;

  Map<String, List<Lesson>> _mappedSchedule = {};

  List<Lesson> _lessons = [];
  List<Lesson> _exams = [];

  List<DaySchedule> _fullScheduleAllGroup = [];
  List<DaySchedule> _fullScheduleFirstSubgroup = [];
  List<DaySchedule> _fullScheduleSecondSubgroup = [];
  List<DaySchedule> _daylyScheduleAllGroup = [];
  List<DaySchedule> _daylyScheduleFirstSubgroup = [];
  List<DaySchedule> _daylyScheduleSecondSubgroup = [];

  List<DaySchedule> get fullScheduleAllGroup => _fullScheduleAllGroup;
  List<DaySchedule> get fullScheduleFirstSubgroup => _fullScheduleFirstSubgroup;
  List<DaySchedule> get fullScheduleSecondSubgroup =>
      _fullScheduleSecondSubgroup;

  List<DaySchedule> get daylyScheduleAllGroup => _daylyScheduleAllGroup;
  List<DaySchedule> get daylyScheduleFirstSubgroup =>
      _daylyScheduleFirstSubgroup;
  List<DaySchedule> get daylyScheduleSecondSubgroup =>
      _daylyScheduleSecondSubgroup;

  List<Lesson> get exams => _exams;

  int get currentWeek => _currentWeek;

  static final GroupScheduleService _groupScheduleService =
      GroupScheduleService();
  static final LecturerScheduleService _lecturerScheduleService =
      LecturerScheduleService();
  static final GroupService _groupService = GroupService();
  static final LecturerService _lecturerService = LecturerService();
  static final CurrentWeekService _currentWeekService = CurrentWeekService();

  ScheduleScreenViewModel() {
    _currentWeek = 1;

    _resetSchedule();
  }

  void _resetSchedule() {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      _fullScheduleAllGroup.add(DaySchedule(
        now.add(Duration(days: i)),
        [],
      ));
      _fullScheduleFirstSubgroup.add(DaySchedule(
        now.add(Duration(days: i)),
        [],
      ));
      _fullScheduleSecondSubgroup.add(DaySchedule(
        now.add(Duration(days: i)),
        [],
      ));
    }

    for (int i = 0; i < 14; i++) {
      _daylyScheduleAllGroup.add(DaySchedule(
        now.add(Duration(days: i)),
        [],
      ));
      _daylyScheduleFirstSubgroup.add(DaySchedule(
        now.add(Duration(days: i)),
        [],
      ));
      _daylyScheduleSecondSubgroup.add(DaySchedule(
        now.add(Duration(days: i)),
        [],
      ));
    }
  }

  Future<void> fetchCurrentWeek(DatabaseHelper db) async {
    _currentWeek = await _currentWeekService.getCurrentWeek() ?? 1;
  }

  Future<void> fetchGroupSchedule(DatabaseHelper db, int groupId) async {
    final group = await _groupService.getGroupById(db, groupId);

    if (group == null) {
      _resetSchedule();
      notifyListeners();
      return;
    }

    final schedule = await _groupScheduleService.getGroupSchedule(db, group);

    if (schedule == null) {
      _resetSchedule();
      notifyListeners();
      return;
    }

    _lessons = schedule.schedules;
    _exams = schedule.exams;

    _fetchSchedule();
  }

  Future<void> fetchLecturerSchedule(DatabaseHelper db, int lecturerId) async {
    final lecturer = await _lecturerService.getLecturerById(db, lecturerId);

    if (lecturer == null) {
      _resetSchedule();
      notifyListeners();
      return;
    }

    final schedule =
        await _lecturerScheduleService.getLecturerSchedule(db, lecturer);

    if (schedule == null) {
      _resetSchedule();
      notifyListeners();
      return;
    }

    _lessons = schedule.schedules;
    _exams = schedule.exams;

    _fetchSchedule();
  }

  void _fetchSchedule() {
    _fetchFullSchedule();
    _fetchDaylySchedule();
    notifyListeners();
  }

  void _fetchFullSchedule() {
    _mappedSchedule = _weekDayNumber.map((key, value) => MapEntry(key, []));

    _lessons
        .map((e) => _mappedSchedule[e.weekDay!] = [
              ..._mappedSchedule[e.weekDay!] ?? [],
              e
            ])
        .toList();

    final currentDate = DateTime.now();
    int daysUntilMonday = (8 - currentDate.weekday) % 7;
    final now = currentDate.add(Duration(days: daysUntilMonday));

    _fullScheduleAllGroup = [];
    for (var entry in _mappedSchedule.entries) {
      _fullScheduleAllGroup.add(DaySchedule(
        now.add(Duration(days: _weekDayNumber[entry.key]!)),
        entry.value,
      ));
    }

    _fullScheduleFirstSubgroup = [];
    for (var entry in _mappedSchedule.entries) {
      _fullScheduleFirstSubgroup.add(DaySchedule(
        now.add(Duration(days: _weekDayNumber[entry.key]!)),
        entry.value
            .where((e) => e.numSubgroup == 1 || e.numSubgroup == 0)
            .toList(),
      ));
    }

    _fullScheduleSecondSubgroup = [];
    for (var entry in _mappedSchedule.entries) {
      _fullScheduleSecondSubgroup.add(DaySchedule(
        now.add(Duration(days: _weekDayNumber[entry.key]!)),
        entry.value
            .where((e) => e.numSubgroup == 2 || e.numSubgroup == 0)
            .toList(),
      ));
    }
  }

  void _fetchDaylySchedule() {
    final now = DateTime.now();
    int currentWeekDay = now.weekday - 1;

    _daylyScheduleAllGroup = [];
    for (int i = 0; i < 14; i++) {
      _daylyScheduleAllGroup.add(DaySchedule(
        now.add(Duration(days: i)),
        _mappedSchedule[_weekDayNumber.keys.elementAt(currentWeekDay)]
                ?.where(
                  (e) => e.weeks.contains(_currentWeek),
                )
                .toList() ??
            [],
      ));

      currentWeekDay = (currentWeekDay + 1) % 7;
    }

    _daylyScheduleFirstSubgroup = [];
    for (int i = 0; i < 14; i++) {
      _daylyScheduleFirstSubgroup.add(DaySchedule(
        now.add(Duration(days: i)),
        _mappedSchedule[_weekDayNumber.keys.elementAt(currentWeekDay)]
                ?.where(
                  (e) =>
                      e.weeks.contains(_currentWeek) && e.numSubgroup == 1 ||
                      e.numSubgroup == 0,
                )
                .toList() ??
            [],
      ));

      currentWeekDay = (currentWeekDay + 1) % 7;
    }

    _daylyScheduleSecondSubgroup = [];
    for (int i = 0; i < 14; i++) {
      _daylyScheduleSecondSubgroup.add(DaySchedule(
        now.add(Duration(days: i)),
        _mappedSchedule[_weekDayNumber.keys.elementAt(currentWeekDay)]
                ?.where(
                  (e) =>
                      e.weeks.contains(_currentWeek) && e.numSubgroup == 2 ||
                      e.numSubgroup == 0,
                )
                .toList() ??
            [],
      ));

      currentWeekDay = (currentWeekDay + 1) % 7;
    }

    _daylyScheduleAllGroup.sort((a, b) => a.date.compareTo(b.date));
    _daylyScheduleFirstSubgroup.sort((a, b) => a.date.compareTo(b.date));
    _daylyScheduleSecondSubgroup.sort((a, b) => a.date.compareTo(b.date));
  }
}

class DaySchedule {
  final DateTime date;
  final List<Lesson> lessons;

  DaySchedule(this.date, this.lessons);
}
