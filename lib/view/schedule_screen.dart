import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/view/view_constants.dart';
import 'package:bsuir_schedule/view/widget/lecturer_image_factory.dart';
import 'package:bsuir_schedule/view/widget/lesson_bottom_sheet.dart';
import 'package:bsuir_schedule/view/widget/lesson_card.dart';
import 'package:bsuir_schedule/view/widget/lesson_tab.dart';
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
    final lecturerScheduleId = context.select(
        (RootScreenViewModel viewModel) => viewModel.selectedLecturerId);
    final groupScheduleId = context
        .select((RootScreenViewModel viewModel) => viewModel.selectedGroupId);

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
  ScheduleViewType _currentScheduleType = ScheduleViewType.full;
  ScheduleGroupType _currentGroupType = ScheduleGroupType.allGroup;

  void _toggleScheduleTypeAction() {
    if (_currentScheduleType == ScheduleViewType.full) {
      _currentScheduleType = ScheduleViewType.dayly;
    } else {
      _currentScheduleType = ScheduleViewType.full;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final currentWeek = context
    //     .select((ScheduleScreenViewModel viewModel) => viewModel.currentWeek);
    final currentWeek =
        Provider.of<ScheduleScreenViewModel>(context).currentWeek;

    switch (_currentScheduleType) {
      case ScheduleViewType.dayly:
        {
          switch (_currentGroupType) {
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
          switch (_currentGroupType) {
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
              SliverAppBar(
                expandedHeight: 30,
                floating: true,
                pinned: false,
                title: getTitle(DateTime.now(), currentWeek),
                actions: getActions(),
              ),
            ],
            body: getBody(_schedule),
          ),
        ),
      ),
    );
  }

  Widget getTitle(DateTime now, int currentWeek) => Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
                '${now.day}-е ${ScheduleWidgetConstants.monthesList[now.month]}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            Text('$currentWeek-я учебная неделя',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                )),
          ],
        ),
      );

  List<Widget> getActions() => [
        if (_currentScheduleType != ScheduleViewType.exams) ...[
          PopupMenuButton(
            tooltip: 'Подгруппа',
            itemBuilder: (context) => getPopupMenuItems(),
            onSelected: (value) => setState(() {
              _currentGroupType = value;
            }),
            child: const Icon(Icons.group_outlined),
          ),
        ],
        IconButton(
          tooltip: getTooltip(),
          onPressed: _toggleScheduleTypeAction,
          icon: const Icon(Icons.developer_board_outlined),
        ),
      ];

  String getTooltip() => (_currentScheduleType == ScheduleViewType.full)
      ? 'Ежедневное расписание'
      : 'Полное расписание';

  List<PopupMenuItem<ScheduleGroupType>> getPopupMenuItems() => [
        const PopupMenuItem<ScheduleGroupType>(
          value: ScheduleGroupType.allGroup,
          child: Row(
            children: [
              Icon(Icons.group_outlined),
              SizedBox(width: 8),
              Text('Вся группа'),
            ],
          ),
        ),
        const PopupMenuItem<ScheduleGroupType>(
          value: ScheduleGroupType.firstSubgroup,
          child: Row(
            children: [
              Icon(Icons.person_2_outlined),
              SizedBox(width: 8),
              Text('1-я подгруппа'),
            ],
          ),
        ),
        const PopupMenuItem<ScheduleGroupType>(
          value: ScheduleGroupType.secondSubgroup,
          child: Row(
            children: [
              Icon(Icons.person_3_outlined),
              SizedBox(width: 8),
              Text('2-я подгруппа'),
            ],
          ),
        ),
      ];

  Widget getBody(List<DaySchedule> schedule) => Column(
        children: [
          getTabBar(schedule),
          getTabBarView(schedule),
        ],
      );

  Widget getTabBar(List<DaySchedule> schedule) => Container(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          tabs: schedule
              .map((e) => LessonTab(
                    scheduleType: _currentScheduleType,
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
                (e) => _LessonListWidget(
                  daySchedule: e,
                  scheduleViewType: _currentScheduleType,
                  scheduleEntityType: widget.scheduleEntityType!,
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

class _LessonListWidget extends StatefulWidget {
  final ScheduleViewType scheduleViewType;
  final ScheduleEntityType scheduleEntityType;
  final DaySchedule daySchedule;
  final DateTime startDate;
  final DateTime endDate;

  const _LessonListWidget({
    Key? key,
    required this.scheduleViewType,
    required this.scheduleEntityType,
    required this.daySchedule,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<_LessonListWidget> createState() => _LessonListWidgetState();
}

class _LessonListWidgetState extends State<_LessonListWidget>
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
            builder: (context) {
              return LessonBottomSheet(
                lesson: lesson,
                image: imageFactory.fetchImage(
                  radius: 25,
                  borderSize: 0,
                  lecturer: lesson.lecturers.firstOrNull,
                ),
              );
            }),
      );
    });

    if (lessonCards.isEmpty) {
      if (widget.scheduleViewType == ScheduleViewType.dayly) {
        final now = widget.daySchedule.date;

        if (now.compareTo(widget.startDate) < 0) {
          return Center(
            child: Text('Занятия начнутся ${_convertDate(widget.startDate)}'),
          );
        } else if (now.compareTo(widget.endDate) > 0) {
          return Center(
            child: Text('Занятия закончились ${_convertDate(widget.endDate)}'),
          );
        }
      }

      return const Center(
        child: Text('Отдыхай'),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 20),
            ...lessonCards,
            const SizedBox(height: 20),
          ]),
        )
      ],
    );
  }
}
