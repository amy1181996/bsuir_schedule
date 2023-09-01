import 'dart:async';

import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/widget/lecturer_image_factory.dart';
import 'package:bsuir_schedule/ui/widget/lesson_bottom_sheet.dart';
import 'package:bsuir_schedule/ui/widget/lesson_card.dart';
import 'package:bsuir_schedule/ui/widget/lesson_tab.dart';
import 'package:bsuir_schedule/ui/widget/lesson_time_bar.dart';
import 'package:bsuir_schedule/ui/widget/schedule_screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  ScheduleEntityType? _currentScheduleEntityType;

  @override
  Widget build(BuildContext context) {
    final lecturerScheduleId =
        Provider.of<RootScreenViewModel>(context).selectedLecturerId;
    final groupScheduleId =
        Provider.of<RootScreenViewModel>(context).selectedGroupId;

    if (lecturerScheduleId != null) {
      _currentScheduleEntityType = ScheduleEntityType.lecturer;
    } else if (groupScheduleId != null) {
      _currentScheduleEntityType = ScheduleEntityType.group;
    }

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
              scheduleEntityType: _currentScheduleEntityType,
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

    await viewModel.fetchData(db);

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
  final ScheduleEntityType? scheduleEntityType;

  const _ScheduleScreenBodyWidget({
    Key? key,
    required this.fullScheduleAllGroup,
    required this.fullScheduleFirstSubgroup,
    required this.fullScheduleSecondSubgroup,
    required this.daylyScheduleAllGroup,
    required this.daylyScheduleFirstSubgroup,
    required this.daylyScheduleSecondSubgroup,
    required this.exams,
    required this.scheduleEntityType,
  }) : super(key: key);

  @override
  State<_ScheduleScreenBodyWidget> createState() =>
      _ScheduleScreenBodyWidgetState();
}

class _ScheduleScreenBodyWidgetState extends State<_ScheduleScreenBodyWidget> {
  List<DaySchedule> _schedule = [];
  ScheduleViewType? currentScheduleType;
  ScheduleGroupType? currentGroupType;

  @override
  Widget build(BuildContext context) {
    currentScheduleType =
        Provider.of<ScheduleScreenViewModel>(context).scheduleViewType;
    currentGroupType =
        Provider.of<ScheduleScreenViewModel>(context).scheduleGroupType;

    switch (currentScheduleType!) {
      case ScheduleViewType.dayly:
        {
          switch (currentGroupType!) {
            case ScheduleGroupType.allGroup:
              _schedule = widget.daylyScheduleAllGroup;
              break;
            case ScheduleGroupType.firstSubgroup:
              _schedule = widget.daylyScheduleFirstSubgroup;
              break;
            case ScheduleGroupType.secondSubgroup:
              _schedule = widget.daylyScheduleSecondSubgroup;
              break;
          }
        }
        break;
      case ScheduleViewType.full:
        {
          switch (currentGroupType!) {
            case ScheduleGroupType.allGroup:
              _schedule = widget.fullScheduleAllGroup;
              break;
            case ScheduleGroupType.firstSubgroup:
              _schedule = widget.fullScheduleFirstSubgroup;
              break;
            case ScheduleGroupType.secondSubgroup:
              _schedule = widget.fullScheduleSecondSubgroup;
              break;
          }
        }
        break;
      case ScheduleViewType.exams:
        {
          _schedule = widget.exams;
        }
        break;
    }

    return DefaultTabController(
      length: _schedule.length,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) =>
                <Widget>[
              const ScheduleScreenAppBar(),
            ],
            body: getBody(_schedule),
          ),
        ),
      ),
    );
  }

  Widget getBody(List<DaySchedule> schedule) => Column(
        children: [
          getTabBar(schedule),
          const SizedBox(height: 15),
          LessonTimeBar(daySchedule: schedule.first),
          getTabBarView(schedule),
        ],
      );

  Widget getTabBar(List<DaySchedule> schedule) => Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: TabBar(
          indicatorColor: Theme.of(context).primaryColor,
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          tabs: schedule
              .map((e) => LessonTab(
                    scheduleType: currentScheduleType!,
                    date: e.date,
                  ))
              .toList(),
        ),
      );

  Widget getTabBarView(List<DaySchedule> schedule) => Expanded(
        child: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: schedule
              .map(
                (e) => LessonListWidget(
                  daySchedule: e,
                  scheduleViewType: currentScheduleType!,
                  scheduleEntityType: widget.scheduleEntityType,
                  startDate:
                      Provider.of<ScheduleScreenViewModel>(context).startDate ??
                          DateTime.now(),
                  endDate:
                      Provider.of<ScheduleScreenViewModel>(context).endDate ??
                          DateTime.now(),
                ),
              )
              .toList(),
        ),
      );
}

class LessonListWidget extends StatefulWidget {
  final ScheduleViewType scheduleViewType;
  final ScheduleEntityType? scheduleEntityType;
  final DaySchedule daySchedule;
  final DateTime startDate;
  final DateTime endDate;

  const LessonListWidget({
    Key? key,
    required this.scheduleViewType,
    required this.scheduleEntityType,
    required this.daySchedule,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<LessonListWidget> createState() => _LessonListWidgetState();
}

class _LessonListWidgetState extends State<LessonListWidget>
    with AutomaticKeepAliveClientMixin {
  static final imageFactory = LecturerImageFactory();

  String _convertDate(DateTime date) {
    return '${date.day} ${ScheduleWidgetConstants.monthesList[date.month - 1]}';
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final List<Widget> lessonCards =
        List.generate(widget.daySchedule.lessons.length, (index) {
      final lesson = widget.daySchedule.lessons[index];
      final shouldShowTimeGradient =
          widget.scheduleViewType == ScheduleViewType.dayly ? true : false;

      return LessonCard(
        lesson: lesson,
        currentTime: widget.daySchedule.date,
        shouldShowTimeGradient: shouldShowTimeGradient,
        scheduleEntityType: widget.scheduleEntityType,
        image: imageFactory.fetchImage(
          radius: 20,
          borderSize: 0,
          lecturer: lesson.lecturers.firstOrNull,
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (context) => LessonBottomSheet(
            lesson: lesson,
            scheduleEntityType: widget.scheduleEntityType,
            image: imageFactory.fetchImage(
              radius: 25,
              borderSize: 0,
              lecturer: lesson.lecturers.firstOrNull,
            ),
          ),
        ),
      );
    });

    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final textStyle = textTheme.bodyStyle;

    if (lessonCards.isEmpty) {
      if (widget.scheduleEntityType == null) {
        return Center(
          child: Text(
            'Выберите расписание',
            style: textStyle,
          ),
        );
      }

      if (widget.scheduleViewType == ScheduleViewType.dayly) {
        final now = widget.daySchedule.date;

        if (now.compareTo(widget.startDate) < 0) {
          return Center(
            child: Text(
              'Занятия начнутся ${_convertDate(widget.startDate)}',
              style: textStyle,
            ),
          );
        } else if (now.compareTo(widget.endDate) > 0) {
          return Center(
            child: Text(
              'Занятия закончились ${_convertDate(widget.endDate)}',
              style: textStyle,
            ),
          );
        }
      }

      return Center(
        child: Text(
          'Отдыхай',
          style: textStyle,
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 10),
            ...lessonCards,
            const SizedBox(height: 15),
          ]),
        )
      ],
    );
  }
}
