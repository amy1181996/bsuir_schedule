import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/view/view_constants.dart';
import 'package:bsuir_schedule/view/widget/schedule_card_widget.dart';
import 'package:bsuir_schedule/view/widget/schedule_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    final lecturerScheduleId = context.select(
        (RootScreenViewModel viewModel) => viewModel.selectedLecturerId);
    final groupScheduleId = context
        .select((RootScreenViewModel viewModel) => viewModel.selectedGroupId);

    return FutureBuilder(
        future: _fetchData(lecturerScheduleId, groupScheduleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<DaySchedule> fullScheduleAllGroup = context.select(
                (ScheduleScreenViewModel viewModel) =>
                    viewModel.fullScheduleAllGroup);
            final List<DaySchedule> fullScheduleFirstSubgroup = context.select(
                (ScheduleScreenViewModel viewModel) =>
                    viewModel.fullScheduleFirstSubgroup);
            final List<DaySchedule> fullScheduleSecondSubgroup = context.select(
                (ScheduleScreenViewModel viewModel) =>
                    viewModel.fullScheduleSecondSubgroup);
            final List<DaySchedule> daylyScheduleAllGroup = context.select(
                (ScheduleScreenViewModel viewModel) =>
                    viewModel.daylyScheduleAllGroup);
            final List<DaySchedule> daylyScheduleFirstSubgroup = context.select(
                (ScheduleScreenViewModel viewModel) =>
                    viewModel.daylyScheduleFirstSubgroup);
            final List<DaySchedule> daylyScheduleSecondSubgroup =
                context.select((ScheduleScreenViewModel viewModel) =>
                    viewModel.daylyScheduleSecondSubgroup);
            final List<DaySchedule> exams = [
              DaySchedule(
                  DateTime.now(),
                  context.select(
                      (ScheduleScreenViewModel viewModel) => viewModel.exams))
            ];

            return _ScheduleScreenBodyWidget(
              fullScheduleAllGroup: fullScheduleAllGroup,
              fullScheduleFirstSubgroup: fullScheduleFirstSubgroup,
              fullScheduleSecondSubgroup: fullScheduleSecondSubgroup,
              daylyScheduleAllGroup: daylyScheduleAllGroup,
              daylyScheduleFirstSubgroup: daylyScheduleFirstSubgroup,
              daylyScheduleSecondSubgroup: daylyScheduleSecondSubgroup,
              exams: exams,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> _fetchData(int? lecturerScheduleId, int? groupScheduleId) async {
    final db = context.select((RootScreenViewModel vm) => vm.db);
    final viewModel = context.read<ScheduleScreenViewModel>();

    await viewModel.fetchCurrentWeek(db);

    if (lecturerScheduleId != null) {
      await viewModel.fetchLecturerSchedule(db, lecturerScheduleId);
    } else if (groupScheduleId != null) {
      await viewModel.fetchGroupSchedule(db, groupScheduleId);
    }
  }
}

class _ScheduleScreenBodyWidget extends StatefulWidget {
  final List<DaySchedule> fullScheduleAllGroup;
  final List<DaySchedule> fullScheduleFirstSubgroup;
  final List<DaySchedule> fullScheduleSecondSubgroup;
  final List<DaySchedule> daylyScheduleAllGroup;
  final List<DaySchedule> daylyScheduleFirstSubgroup;
  final List<DaySchedule> daylyScheduleSecondSubgroup;
  final List<DaySchedule> exams;

  const _ScheduleScreenBodyWidget({
    Key? key,
    required this.fullScheduleAllGroup,
    required this.fullScheduleFirstSubgroup,
    required this.fullScheduleSecondSubgroup,
    required this.daylyScheduleAllGroup,
    required this.daylyScheduleFirstSubgroup,
    required this.daylyScheduleSecondSubgroup,
    required this.exams,
  }) : super(key: key);

  @override
  State<_ScheduleScreenBodyWidget> createState() =>
      _ScheduleScreenBodyWidgetState();
}

class _ScheduleScreenBodyWidgetState extends State<_ScheduleScreenBodyWidget> {
  List<DaySchedule> _schedule = [];
  ScheduleViewType _currentScheduleType = ScheduleViewType.fullAllGroup;

  @override
  Widget build(BuildContext context) {
    final currentWeek = context
        .select((ScheduleScreenViewModel viewModel) => viewModel.currentWeek);

    switch (_currentScheduleType) {
      case ScheduleViewType.daylyAllGroup:
        _schedule = widget.daylyScheduleAllGroup;
        break;
      case ScheduleViewType.daylyFirstSubgroup:
        _schedule = widget.daylyScheduleFirstSubgroup;
        break;
      case ScheduleViewType.daylySecondSubgroup:
        _schedule = widget.daylyScheduleSecondSubgroup;
        break;
      case ScheduleViewType.fullAllGroup:
        _schedule = widget.fullScheduleAllGroup;
        break;
      case ScheduleViewType.fullFirstSubgroup:
        _schedule = widget.fullScheduleFirstSubgroup;
        break;
      case ScheduleViewType.fullSecondSubgroup:
        _schedule = widget.fullScheduleSecondSubgroup;
        break;
      case ScheduleViewType.exams:
        _schedule = widget.exams;
        break;
    }

    return DefaultTabController(
      length: _schedule.length,
      child: Scaffold(
        appBar: getAppBar(_schedule, currentWeek),
        body: getBody(_schedule),
      ),
    );
  }

  AppBar getAppBar(List<DaySchedule> schedule, int currentWeek) => AppBar(
        title: getTitle(DateTime.now(), currentWeek),
        bottom: getTabBar(schedule),
        actions: getActions(),
      );

  Column getTitle(DateTime now, int currentWeek) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              '${now.day}-е ${ScheduleWidgetConstants.monthesList[now.month]}'),
          Text(
            '$currentWeek-я учебная неделя',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      );

  TabBar getTabBar(List<DaySchedule> schedule) {
    return TabBar(
      physics: const BouncingScrollPhysics(),
      isScrollable: true,
      tabs: schedule
          .map((e) => ScheduleTabWidget(
                scheduleType: _currentScheduleType,
                date: e.date,
              ))
          .toList(),
    );
  }

  void _toggleScheduleTypeAction() {
    if (_currentScheduleType == ScheduleViewType.fullAllGroup ||
        _currentScheduleType == ScheduleViewType.fullFirstSubgroup ||
        _currentScheduleType == ScheduleViewType.fullSecondSubgroup) {
      _currentScheduleType = ScheduleViewType.daylyAllGroup;
    } else {
      _currentScheduleType = ScheduleViewType.fullAllGroup;
    }

    setState(() {});
  }

  List<Widget> getActions() => [
        IconButton(
          onPressed: _toggleScheduleTypeAction,
          icon: const Icon(Icons.developer_board_outlined),
        ),
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.group_outlined),
        ),
      ];

  TabBarView getBody(List<DaySchedule> schedule) {
    return TabBarView(
      physics: const BouncingScrollPhysics(),
      children: schedule
          .map((e) => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: e.lessons.length,
                itemBuilder: (context, index) {
                  final lesson = e.lessons[index];
                  return ScheduleCardWidget(
                    lesson: lesson,
                    scheduleEntityType: ScheduleEntityType.group,
                  );
                },
              ))
          .toList(),
    );
  }
}
