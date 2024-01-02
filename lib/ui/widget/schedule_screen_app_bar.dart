import 'package:bsuir_schedule/domain/model/schedule_descriptor.dart';
import 'package:bsuir_schedule/domain/view_model/root_screen_view_model.dart';
import 'package:bsuir_schedule/domain/view_model/schedule_screen_view_model.dart';
import 'package:bsuir_schedule/ui/navigation/navigation.dart';
import 'package:bsuir_schedule/ui/screens/view_constants.dart';
import 'package:bsuir_schedule/ui/themes/app_text_theme.dart';
import 'package:bsuir_schedule/ui/widget/date_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleScreenAppBar extends StatefulWidget {
  const ScheduleScreenAppBar({super.key});

  @override
  State<ScheduleScreenAppBar> createState() => _ScheduleScreenAppBarState();
}

class _ScheduleScreenAppBarState extends State<ScheduleScreenAppBar> {
  ScheduleViewType? _currentScheduleType;

  // ignore: unused_field
  ScheduleGroupType? _currentGroupType;
  String? _scheduleName;

  @override
  Widget build(BuildContext context) {
    final currentWeek = 1;
        // Provider.of<ScheduleScreenViewModel>(context).currentWeek;
    _currentScheduleType = ScheduleViewType.full;
        // Provider.of<ScheduleScreenViewModel>(context).scheduleViewType;
    _currentGroupType = ScheduleGroupType.allGroup;
        // Provider.of<ScheduleScreenViewModel>(context).scheduleGroupType;
    final bool isSessonPeriod =
        // context.select(
        //     (ScheduleScreenViewModel viewModel) =>
        //         viewModel.exams.isNotEmpty) ??
        false;
    final bool hasAnnouncements =
        // context.select(
        //     (ScheduleScreenViewModel viewModel) =>
        //         viewModel.announcements.isNotEmpty) ??
        false;

    return SliverAppBar(
      expandedHeight: 30,
      floating: true,
      pinned: false,
      title: getTitle(DateTime.now(), currentWeek),
      actions: getActions(isSessonPeriod, hasAnnouncements),
    );
      // FutureBuilder(
      //   future: fetchData(),
      //   builder: (context, snapshot) {
      //     return SliverAppBar(
      //       expandedHeight: 30,
      //       floating: true,
      //       pinned: false,
      //       title: getTitle(DateTime.now(), currentWeek),
      //       actions: getActions(isSessonPeriod, hasAnnouncements),
      //     );
      //   });
  }

  String getGreeting() {
    if (_scheduleName == null || _currentScheduleType == null) {
      return 'Выберите расписание';
    }

    switch (_currentScheduleType!) {
      case ScheduleViewType.full:
        return 'Расписание $_scheduleName';
      case ScheduleViewType.dayly:
        return 'Расписание $_scheduleName';
      case ScheduleViewType.exams:
        return 'Экзамены $_scheduleName';
      case ScheduleViewType.announcements:
        return 'Объявления $_scheduleName';
      // default:
      //   return 'Выберите расписание';
    }
  }

  Widget getTitle(DateTime now, int currentWeek) => Builder(builder: (context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: Theme.of(context).extension<AppTextTheme>()!.titleStyle,
              ),
              Text(
                '${now.day}-е ${ScheduleWidgetConstants.monthesList[now.month - 1]}, '
                '$currentWeek-я учебная неделя',
                style: Theme.of(context)
                    .extension<AppTextTheme>()!
                    .bodyStyle
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      });

  List<Widget> getActions(bool isSessionPeriod, bool hasAnnouncements) => [
        if (_currentScheduleType != ScheduleViewType.exams) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: PopupMenuButton(
              tooltip: 'Подгруппа',
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: ScheduleGroupType.allGroup,
                  child: Row(
                    children: [
                      Icon(Icons.group_outlined),
                      SizedBox(width: 8),
                      Text('Вся группа'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScheduleGroupType.firstSubgroup,
                  child: Row(
                    children: [
                      Icon(Icons.person_2_outlined),
                      SizedBox(width: 8),
                      Text('1-я подгруппа'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScheduleGroupType.secondSubgroup,
                  child: Row(
                    children: [
                      Icon(Icons.person_3_outlined),
                      SizedBox(width: 8),
                      Text('2-я подгруппа'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                setState(() {
                  _currentGroupType = value;
                });
                Provider.of<ScheduleScreenViewModel>(context, listen: false)
                    .setScheduleGroupType(value);
              },
              child: const Icon(Icons.group_outlined),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: PopupMenuButton(
            tooltip: 'Вид расписания',
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ScheduleViewType.full,
                child: Text('Полное'),
              ),
              const PopupMenuItem(
                value: ScheduleViewType.dayly,
                child: Text('По дням'),
              ),
              if (isSessionPeriod) ...[
                const PopupMenuItem(
                  value: ScheduleViewType.exams,
                  child: Text('Экзамены'),
                ),
              ],
              if (hasAnnouncements) ...[
                const PopupMenuItem(
                  value: ScheduleViewType.announcements,
                  child: Text('Объявления'),
                ),
              ],
            ],
            onSelected: (value) {
              setState(() {
                _currentScheduleType = value;
              });
              Provider.of<ScheduleScreenViewModel>(context, listen: false)
                  .setScheduleViewType(value);
            },
            child: const Icon(Icons.grid_view_rounded),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DateButton(
            onPressed: setDate,
          ),
        ),
        IconButton(
          tooltip: 'На стройку',
          onPressed: () {
            Navigator.of(context).pushNamed(NavigationRoutes.settings);
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ];

  Future<void> setDate() async {
    final now = DateTime.now();
    final startDate = //context.read<ScheduleScreenViewModel>().startDate ??
        DateTime(now.year, 9, 1);
    final endDate = //context.read<ScheduleScreenViewModel>().endDate ??
        DateTime(now.year + 1, 5, 31);

    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: startDate,
      lastDate: endDate,
    );

    if (newDate != null) {
      // context.read<ScheduleScreenViewModel>().setCurrentDate(newDate);
    }
  }

  // Future<void> fetchData() async {
  //   final selectedGroupId = context
  //       .select((RootScreenViewModel viewModel) => viewModel.selectedGroupId);
  //
  //   final selectedLecturerId = context.select(
  //       (RootScreenViewModel viewModel) => viewModel.selectedLecturerId);
  //
  //   final db = context.read<RootScreenViewModel>().db;
  //
  //   final selectedGroupName = selectedGroupId == null
  //       ? null
  //       : await Provider.of<ScheduleScreenViewModel>(context)
  //           .getGroupName(db, selectedGroupId);
  //
  //   final selectedLecturerName = selectedLecturerId == null
  //       ? null
  //       : await Provider.of<ScheduleScreenViewModel>(context)
  //           .getLecturerName(db, selectedLecturerId);
  //
  //   setState(() {
  //     _scheduleName =
  //         selectedGroupName ?? selectedLecturerName ?? 'Выберите расписание';
  //   });
  // }
}
