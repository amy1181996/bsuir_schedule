import 'package:bsuir_schedule/data/db/db_helper/db_helper.dart';
import 'package:bsuir_schedule/data/service/current_week_service.dart';
import 'package:bsuir_schedule/data/service/group_schedule_service.dart';
import 'package:bsuir_schedule/data/service/group_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_schedule_service.dart';
import 'package:bsuir_schedule/data/service/lecturer_service.dart';
import 'package:bsuir_schedule/data/service/schedule_presentation_service.dart';
import 'package:bsuir_schedule/domain/model/lesson.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
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

  int? _currentWeek;

  DateTime? _startDate;
  DateTime? _endDate;

  Map<String, List<Lesson>> _mappedSchedule = {};

  List<Lesson> _lessons = [];
  List<Lesson> _exams = [];
  List<Lesson> _announcements = [];

  List<DaySchedule> _fullScheduleAllGroup = [];
  List<DaySchedule> _fullScheduleFirstSubgroup = [];
  List<DaySchedule> _fullScheduleSecondSubgroup = [];
  List<DaySchedule> _daylyScheduleAllGroup = [];
  List<DaySchedule> _daylyScheduleFirstSubgroup = [];
  List<DaySchedule> _daylyScheduleSecondSubgroup = [];

  ScheduleGroupType? _scheduleGroupType;
  ScheduleViewType? _scheduleViewType;

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
  List<Lesson> get announcements => _announcements;

  int get currentWeek => _currentWeek ?? 1;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  ScheduleGroupType get scheduleGroupType =>
      _scheduleGroupType ?? ScheduleGroupType.allGroup;
  ScheduleViewType get scheduleViewType =>
      _scheduleViewType ?? ScheduleViewType.dayly;

  static final GroupScheduleService _groupScheduleService =
      GroupScheduleService();
  static final LecturerScheduleService _lecturerScheduleService =
      LecturerScheduleService();
  static final GroupService _groupService = GroupService();
  static final LecturerService _lecturerService = LecturerService();
  static final CurrentWeekService _currentWeekService = CurrentWeekService();
  static final SchedulePresentationService _schedulePresentationService =
      SchedulePresentationService();

  ScheduleScreenViewModel() {
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

    _lessons = [];
    _exams = [];
    _announcements = [];

    _startDate = null;
    _endDate = null;
  }

  Future<void> fetchData(DatabaseHelper db) async {
    _currentWeek ??= await _currentWeekService.getCurrentWeek();
    _scheduleGroupType ??=
        await _schedulePresentationService.getScheduleGroupType();
    _scheduleViewType ??=
        await _schedulePresentationService.getScheduleViewType();
  }

  Future<void> setScheduleGroupType(ScheduleGroupType scheduleGroupType) async {
    _scheduleGroupType = scheduleGroupType;
    await _schedulePresentationService.setScheduleGroupType(scheduleGroupType);
    notifyListeners();
  }

  Future<void> setScheduleViewType(ScheduleViewType scheduleViewType) async {
    _scheduleViewType = scheduleViewType;
    await _schedulePresentationService.setScheduleViewType(scheduleViewType);
    notifyListeners();
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
    _announcements = schedule.schedules
        .where((element) => element.isAnnouncement == true)
        .toList();
    _exams = schedule.exams;
    _startDate = schedule.startDate;
    _endDate = schedule.endDate;

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
    _startDate = schedule.startDate;
    _endDate = schedule.endDate;

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

    _mappedSchedule.map((key, value) => MapEntry(key, value.sort((a, b) {
          DateTime timeA = DateTime.parse('2000-01-01 ${a.startLessonTime}');
          DateTime timeB = DateTime.parse('2000-01-01 ${b.startLessonTime}');

          return timeA.compareTo(timeB);
        })));

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

    _fullScheduleFirstSubgroup = _fullScheduleAllGroup
        .map((daySchedule) => DaySchedule(
            daySchedule.date,
            daySchedule.lessons
                .where((schedule) =>
                    schedule.numSubgroup == 0 || schedule.numSubgroup == 1)
                .toList()))
        .toList();

    _fullScheduleSecondSubgroup = _fullScheduleAllGroup
        .map((daySchedule) => DaySchedule(
            daySchedule.date,
            daySchedule.lessons
                .where((schedule) =>
                    schedule.numSubgroup == 0 || schedule.numSubgroup == 2)
                .toList()))
        .toList();
  }

  void _fetchDaylySchedule() {
    final now = DateTime.now();
    int currentWeekDay = now.weekday - 1;

    _daylyScheduleAllGroup = [];
    for (int i = 0; i < 14; i++) {
      final currentDate = now.add(Duration(days: i));

      if (currentDate.compareTo(_startDate!) >= 0 &&
          currentDate.compareTo(_endDate!) <= 0) {
        _daylyScheduleAllGroup.add(DaySchedule(
          currentDate,
          _mappedSchedule[_weekDayNumber.keys.elementAt(currentWeekDay)]
                  ?.where(
                    (e) => e.weeks.contains(_currentWeek),
                  )
                  .toList() ??
              [],
        ));
      } else {
        _daylyScheduleAllGroup.add(DaySchedule(currentDate, []));
      }

      currentWeekDay = (currentWeekDay + 1) % 7;
    }

    _daylyScheduleAllGroup.sort((a, b) => a.date.compareTo(b.date));

    _daylyScheduleFirstSubgroup = _daylyScheduleAllGroup
        .map((daySchedule) => DaySchedule(
              daySchedule.date,
              daySchedule.lessons
                  .where((schedule) =>
                      schedule.numSubgroup == 0 || schedule.numSubgroup == 1)
                  .toList(),
            ))
        .toList();

    _daylyScheduleSecondSubgroup = _daylyScheduleAllGroup
        .map((daySchedule) => DaySchedule(
              daySchedule.date,
              daySchedule.lessons
                  .where((schedule) =>
                      schedule.numSubgroup == 0 || schedule.numSubgroup == 2)
                  .toList(),
            ))
        .toList();
  }

  Future<bool> isLecturerScheduleActual(
      DatabaseHelper db, int lecturerId) async {
    final lecturer = await _lecturerService.getLecturerById(db, lecturerId);

    if (lecturer == null) {
      return false;
    }

    return await _lecturerScheduleService.isLecturerScheduleActual(
        db, lecturer);
  }

  Future<bool> isGroupScheduleActual(DatabaseHelper db, int groupId) async {
    final group = await _groupService.getGroupById(db, groupId);

    if (group == null) {
      return false;
    }

    return await _groupScheduleService.isGroupScheduleActual(db, group);
  }
}

class DaySchedule {
  final DateTime date;
  final List<Lesson> lessons;

  DaySchedule(this.date, this.lessons);
}
